import '../../../core/error/app_failure.dart';
import '../data/home_api.dart';
import '../enums/home_section.dart';
import '../models/home_anime_model.dart';

class HomeRepository {
  final HomeApi _api = HomeApi();

  // In-memory cache
  final Map<HomeSection, List<HomeAnimeModel>> _cache = {};

  // Cache timestamps
  final Map<HomeSection, DateTime> _cacheTime = {};

  static const Duration _cacheDuration = Duration(
    minutes: 5,
  );

  Future<List<HomeAnimeModel>> getAnime(
    HomeSection section, {
    bool forceRefresh = false,
  }) async {
    // Return cached data if valid
    if (!forceRefresh &&
        _cache.containsKey(section) &&
        _cacheTime.containsKey(section)) {
      final age = DateTime.now().difference(
        _cacheTime[section]!,
      );

      if (age < _cacheDuration) {
        return _cache[section]!;
      }
    }

    try {
      late final dynamic result;

      switch (section) {
        case HomeSection.trending:
          result = await _api.getTrendingAnime();
          break;

        case HomeSection.thisSeason:
          result = await _api.getThisSeasonAnime();
          break;

        case HomeSection.justReleased:
          result = await _api.getJustReleasedAnime();
          break;

        case HomeSection.popularThisWeek:
          result = await _api.getPopularThisWeek();
          break;

        case HomeSection.continueWatching:
          // Temporary until implemented
          result = await _api.getTrendingAnime();
          break;
      }

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final List media =
          result.data!['Page']['media'];

      final anime = media
          .map<HomeAnimeModel>(
            (item) => HomeAnimeModel.fromJson(item),
          )
          .toList();

      // Save in memory cache
      _cache[section] = anime;
      _cacheTime[section] = DateTime.now();

      return anime;
    } catch (e) {
      throw AppFailure.from(e);
    }
  }

  /// Clear one section
  void clearSection(HomeSection section) {
    _cache.remove(section);
    _cacheTime.remove(section);
  }

  /// Clear all cached data
  void clearAllCache() {
    _cache.clear();
    _cacheTime.clear();
  }
}