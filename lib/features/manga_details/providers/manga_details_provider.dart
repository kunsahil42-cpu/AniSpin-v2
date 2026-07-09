import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/chapter_cache.dart';
import '../../../core/network/mangadex/mangadex_api.dart';
import '../../../core/source_fallback/source_fallback_manager.dart';
import '../models/manga_details_model.dart';
import '../repository/manga_details_repository.dart';

import '../models/chapter_model.dart';

// Repository provider that depends on MangaDexApi
final mangaDetailsRepositoryProvider = Provider<MangaDetailsRepository>((ref) {
  final mangaDexApi = ref.read(mangaDexApiProvider);
  return MangaDetailsRepository(dexApi: mangaDexApi);
});

// Provider for manga details that returns a Future<MangaDetailsModel>
final mangaDetailsProvider =
    FutureProvider.family<MangaDetailsModel, int>((ref, mangaId) {
  final repository = ref.read(mangaDetailsRepositoryProvider);
  return repository.getMangaDetails(mangaId);
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
      print('MangaChaptersNotifier: Background refresh failed: $e');
      return const <ChapterModel>[];
    });
  }

  Future<List<ChapterModel>> _fetchAndCacheChapters(int mangaId) async {
    final chapters = await _fetchFromNetwork(mangaId);
    await ChapterCache.saveChapters(mangaId, chapters);
    state = AsyncValue.data(chapters);
    return chapters;
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