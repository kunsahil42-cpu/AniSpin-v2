import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/chapter_cache.dart';
import '../../../core/network/mangadex/mangadex_api.dart';
import '../../../core/source_fallback/source_fallback_manager.dart';
import '../models/manga_details_model.dart';
import '../repository/manga_details_repository.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../core/utils/genre_filter.dart';
import '../../../core/error/app_failure.dart';

import '../models/chapter_model.dart';

// Repository provider that depends on MangaDexApi
final mangaDetailsRepositoryProvider = Provider<MangaDetailsRepository>((ref) {
  final mangaDexApi = ref.read(mangaDexApiProvider);
  return MangaDetailsRepository(dexApi: mangaDexApi);
});

// Provider for manga details that returns a Future<MangaDetailsModel>
final mangaDetailsProvider =
    FutureProvider.family<MangaDetailsModel, int>((ref, mangaId) async {
  final repository = ref.read(mangaDetailsRepositoryProvider);
  final details = await repository.getMangaDetails(mangaId);
  final blocked = ref.watch(blockedGenresProvider);
  if (isMediaBlocked(genres: details.genres, isAdult: details.isAdult, blockedGenres: blocked)) {
    throw AppFailure.notFound('This manga is blocked under your settings.');
  }
  return details;
});

class MangaChaptersNotifier extends FamilyAsyncNotifier<List<ChapterModel>, int> {
  @override
  FutureOr<List<ChapterModel>> build(int mangaId) async {
    // 1. Try to load cached chapters first
    final cached = await ChapterCache.getChapters(mangaId);
    if (cached != null && cached.isNotEmpty) {
      // Trigger background update asynchronously
      _refreshChaptersInBackground(mangaId);
      return cached;
    }

    // 2. If no cache, fetch from network
    return _fetchAndCacheChapters(mangaId);
  }

  void _refreshChaptersInBackground(int mangaId) {
    _fetchAndCacheChapters(mangaId).catchError((e) {
      if (kDebugMode) {
        debugPrint('[MangaChaptersNotifier] Background refresh failed: $e');
      }
      return const <ChapterModel>[];
    });
  }

  Future<List<ChapterModel>> _fetchAndCacheChapters(int mangaId) async {
    final currentChapters = state.valueOrNull ?? [];
    final chapters = await _fetchFromNetwork(mangaId);

    // Merge network chapters with existing cached chapters to avoid duplicates
    final Map<int, ChapterModel> mergedMap = {
      for (final c in currentChapters) c.number: c,
    };

    final newChs = <int>{};
    for (final c in chapters) {
      if (!mergedMap.containsKey(c.number)) {
        newChs.add(c.number);
      }
      mergedMap[c.number] = c;
    }

    if (newChs.isNotEmpty && currentChapters.isNotEmpty) {
      ref.read(newChaptersProvider(mangaId).notifier).state = newChs;
    }

    final mergedList = mergedMap.values.toList()..sort((a, b) => a.number.compareTo(b.number));
    await ChapterCache.saveChapters(mangaId, mergedList);
    state = AsyncValue.data(mergedList);
    return mergedList;
  }

  Future<List<ChapterModel>> _fetchFromNetwork(int mangaId) async {
    final details = await ref.read(mangaDetailsProvider(mangaId).future);
    final fallbackManager = ref.read(sourceFallbackManagerProvider);
    return await fallbackManager.getChapters(details);
  }
}

final mangaChaptersProvider =
    AsyncNotifierProvider.family<MangaChaptersNotifier, List<ChapterModel>, int>(() {
  return MangaChaptersNotifier();
});

final newChaptersProvider = StateProvider.family<Set<int>, int>((ref, mangaId) => {});