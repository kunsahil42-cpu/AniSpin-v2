import '../../../core/error/app_failure.dart';
import '../../../core/merge/anime_merge_service.dart';
import '../../../core/network/jikan/jikan_api.dart';
import '../../../core/network/mock_data_helper.dart';
import '../data/anime_details_api.dart';
import '../models/anime_details_model.dart';

class AnimeDetailsRepository {
  final AnimeDetailsApi _api = AnimeDetailsApi();
  final JikanApi _jikan = JikanApi();
  final AnimeMergeService _merge = const AnimeMergeService();

  // In-memory session cache of merged models by id.
  final Map<int, AnimeDetailsModel> _cache = {};

  Future<AnimeDetailsModel> getAnimeDetails(int id, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = _cache[id];
      if (cached != null) return cached;
    }

    AnimeDetailsModel model;
    try {
      final result = await _api.getAnimeDetails(id);

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final data = result.data?['Media'];
      if (data == null) {
        throw AppFailure.notFound("This anime couldn't be found.");
      }

      model = AnimeDetailsModel.fromJson(data);

      // AniList responded but left gaps → back-fill only the missing fields
      // from Jikan (never overwrites valid AniList data).
      if (_merge.hasGaps(model)) {
        final jikan = await _tryJikan(model.idMal ?? id);
        if (jikan != null) {
          model = _merge.fillMissing(model, jikan);
        }
      }
    } catch (_) {
      try {
        // AniList failed (403 / 429 / 500 / network). Try to load from Jikan.
        final jikan = await _tryJikan(id);
        if (jikan == null) {
          // If Jikan also fails/404s (e.g. for mock IDs), fallback to mock data
          return MockDataHelper.getAnimeDetails(id);
        }
        model = _merge.fromJikan(jikan);
      } catch (_) {
        return MockDataHelper.getAnimeDetails(id);
      }
    }

    _cache[id] = model;
    return model;
  }

  /// Fetches a Jikan anime record, returning null on any failure so callers can
  /// decide whether a missing fallback is fatal.
  Future<Map<String, dynamic>?> _tryJikan(int malId) async {
    try {
      return await _jikan.fetchOne('/anime/$malId/full');
    } catch (_) {
      return null;
    }
  }
}
