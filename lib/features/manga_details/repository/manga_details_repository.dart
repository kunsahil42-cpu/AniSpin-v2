import 'package:isar/isar.dart';
import '../../../core/database/isar_service.dart';
import '../../../features/tracker/models/reading_progress.dart';
import '../../search/data/search_api.dart';
import '../../../core/error/app_failure.dart';
import '../../../core/merge/manga_merge_service.dart';
import '../../../core/network/jikan/jikan_api.dart';
import '../../../core/network/mock_data_helper.dart';
import '../data/manga_details_api.dart';
import '../models/manga_details_model.dart';

class MangaDetailsRepository {
  final MangaDetailsApi _api = MangaDetailsApi();
  final JikanApi _jikan = JikanApi();
  final MangaMergeService _merge = const MangaMergeService();

  MangaDetailsRepository();

  // In-memory session cache of merged models by id.
  final Map<int, MangaDetailsModel> _cache = {};

  Future<MangaDetailsModel> getMangaDetails(int id) async {
    final cached = _cache[id];
    if (cached != null) return cached;

    // Check if we have tracking progress in Isar
    ReadingProgress? progress;
    try {
      progress = await IsarService.instance.readingProgress
          .filter()
          .mangaIdEqualTo(id)
          .findFirst();
    } catch (_) {}

    MangaDetailsModel? model;

    if (progress != null) {
      final aniListId = progress.aniListId;
      final malId = progress.malId;
      final title = progress.romajiTitle;

      // 1. Try AniList
      if (aniListId != null && aniListId > 0) {
        try {
          final result = await _api.getMangaDetails(aniListId);
          final data = result.data?['Media'];
          if (data != null) {
            var m = MangaDetailsModel.fromJson(data);
            if (_merge.hasGaps(m)) {
              final jikan = await _tryJikan(m.idMal ?? m.id);
              if (jikan != null) {
                m = _merge.fillMissing(m, jikan);
              }
            }
            model = m;
          }
        } catch (_) {}
      }

      // 2. Try MAL
      if (model == null && malId != null && malId > 0) {
        try {
          final jikan = await _tryJikan(malId);
          if (jikan != null) {
            model = _merge.fromJikan(jikan);
          }
        } catch (_) {}
      }

      // 3. Try Title Search Fallback (if all IDs are missing)
      if (model == null &&
          (aniListId == null || aniListId == 0) &&
          (malId == null || malId == 0) &&
          title.isNotEmpty) {
        model = await _titleBasedSearch(title);
      }

      // 4. Offline Fallback (if all network requests failed but progress exists)
      if (model == null) {
        model = MangaDetailsModel(
          id: progress.mangaId,
          idMal: progress.malId,
          romajiTitle: progress.romajiTitle,
          englishTitle: progress.englishTitle,
          nativeTitle: null,
          description: progress.description ?? 'No description available. (Offline Mode)',
          bannerImage: progress.bannerImage ?? progress.coverImage,
          coverImage: progress.coverImage,
          averageScore: progress.score != null ? progress.score! * 10 : null,
          chapters: progress.totalChapters,
          volumes: progress.totalVolumes,
          status: progress.status,
          genres: progress.genres,
          format: 'MANGA',
          popularity: null,
          author: progress.author ?? 'Unknown Author',
          mangaDexId: progress.mangaDexId,
          aniListId: progress.aniListId,
          sourceName: 'Offline',
        );
      }
    }

    // If we didn't resolve via progress/tracker, fall back to the normal route
    if (model == null) {
      try {
        final result = await _api.getMangaDetails(id);

        if (result.hasException) {
          throw AppFailure.fromOperation(result.exception);
        }

        final data = result.data?['Media'];
        if (data == null) {
          throw AppFailure.notFound("This manga couldn't be found.");
        }

        var m = MangaDetailsModel.fromJson(data);

        // If there are still gaps, back-fill from Jikan
        if (_merge.hasGaps(m)) {
          final jikan = await _tryJikan(m.idMal ?? id);
          if (jikan != null) {
            m = _merge.fillMissing(m, jikan);
          }
        }
        model = m;
      } catch (_) {
        try {
          // AniList failed. Try to fetch from Jikan first to resolve the metadata/title.
          final jikan = await _tryJikan(id);
          if (jikan == null) {
            return MockDataHelper.getMangaDetails(id);
          }
          model = _merge.fromJikan(jikan);
        } catch (_) {
          return MockDataHelper.getMangaDetails(id);
        }
      }
    }

    final finalModel = model;
    _cache[id] = finalModel;
    return finalModel;
  }

  Future<MangaDetailsModel?> _titleBasedSearch(String title) async {
    // 1. Try AniList search
    try {
      final searchApi = SearchApi();
      final searchResult = await searchApi.searchManga(title);
      if (searchResult.hasException == false) {
        final list = searchResult.data?['Page']?['media'] as List?;
        if (list != null && list.isNotEmpty) {
          final firstItem = list.first;
          return MangaDetailsModel.fromJson(firstItem);
        }
      }
    } catch (_) {}

    // 2. Try MAL / Jikan search
    try {
      final results = await _jikan.fetchList('/manga?q=${Uri.encodeComponent(title)}&limit=1');
      if (results.isNotEmpty) {
        final first = results.first as Map<String, dynamic>;
        return _merge.fromJikan(first);
      }
    } catch (_) {}

    return null;
  }

  /// Fetches a Jikan manga record, returning null on any failure.
  Future<Map<String, dynamic>?> _tryJikan(int malId) async {
    try {
      return await _jikan.fetchOne('/manga/$malId/full');
    } catch (_) {
      return null;
    }
  }
}
