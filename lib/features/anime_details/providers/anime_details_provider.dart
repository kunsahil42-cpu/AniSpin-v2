import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/anime_cache.dart';
import '../models/anime_details_model.dart';
import '../repository/anime_details_repository.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../core/utils/genre_filter.dart';
import '../../../core/error/app_failure.dart';

final animeDetailsRepositoryProvider =
    Provider<AnimeDetailsRepository>((ref) {
  return AnimeDetailsRepository();
});

class AnimeDetailsNotifier extends FamilyAsyncNotifier<AnimeDetailsModel, int> {
  @override
  FutureOr<AnimeDetailsModel> build(int animeId) async {
    final blocked = ref.watch(blockedGenresProvider);

    // 1. Try to load cached details first
    final cached = await AnimeCache.getAnimeDetails(animeId);
    if (cached != null) {
      if (isMediaBlocked(genres: cached.genres, isAdult: cached.isAdult, blockedGenres: blocked)) {
        throw AppFailure.notFound('This anime is blocked under your settings.');
      }
      // Trigger background update asynchronously
      _refreshAnimeInBackground(animeId);
      return cached;
    }

    // 2. If no cache, fetch from network
    final details = await _fetchAndCacheAnime(animeId);
    if (isMediaBlocked(genres: details.genres, isAdult: details.isAdult, blockedGenres: blocked)) {
      throw AppFailure.notFound('This anime is blocked under your settings.');
    }
    return details;
  }

  void _refreshAnimeInBackground(int animeId) {
    _fetchAndCacheAnime(animeId).catchError((e) {
      if (kDebugMode) {
        debugPrint('[AnimeDetailsNotifier] Background refresh failed: $e');
      }
      return state.value!; // Fallback to current state
    });
  }

  Future<AnimeDetailsModel> _fetchAndCacheAnime(int animeId) async {
    final repository = ref.read(animeDetailsRepositoryProvider);
    final oldModel = state.valueOrNull;
    final details = await repository.getAnimeDetails(animeId, forceRefresh: true);

    // Check for new episodes
    if (oldModel != null) {
      final oldTotal = _getActualEpisodesCount(oldModel);
      final newTotal = _getActualEpisodesCount(details);

      if (newTotal > oldTotal) {
        final newEps = <int>{};
        for (int i = oldTotal + 1; i <= newTotal; i++) {
          newEps.add(i);
        }
        if (newEps.isNotEmpty) {
          ref.read(newEpisodesProvider(animeId).notifier).state = newEps;
        }
      }
    }

    await AnimeCache.saveAnimeDetails(animeId, details);
    state = AsyncValue.data(details);
    return details;
  }

  int _getActualEpisodesCount(AnimeDetailsModel model) {
    if (model.nextAiringEpisode != null) {
      return model.nextAiringEpisode!.episode - 1;
    }

    int maxEp = model.episodes ?? 0;

    if (model.streamingEpisodes.isNotEmpty) {
      for (final ep in model.streamingEpisodes) {
        final epNum = _extractEpisodeNumber(ep.title, 0);
        if (epNum != null && epNum > maxEp) {
          maxEp = epNum;
        }
      }
    }

    return maxEp > 0 ? maxEp : 12;
  }

  int? _extractEpisodeNumber(String title, int indexFallback) {
    final epRegex = RegExp(r'(?:episode|ep|ep\.)\s*(\d+)', caseSensitive: false);
    final match = epRegex.firstMatch(title);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    final numRegex = RegExp(r'\b(\d+)\b');
    final matches = numRegex.allMatches(title);
    for (final m in matches) {
      final val = int.tryParse(m.group(0)!);
      if (val != null) return val;
    }
    return indexFallback;
  }
}

final animeDetailsProvider =
    AsyncNotifierProvider.family<AnimeDetailsNotifier, AnimeDetailsModel, int>(() {
  return AnimeDetailsNotifier();
});

final newEpisodesProvider = StateProvider.family<Set<int>, int>((ref, animeId) => {});