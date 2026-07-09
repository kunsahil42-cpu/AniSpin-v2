import '../../../core/error/app_failure.dart';
import '../../../core/network/jikan/jikan_api.dart';
import '../data/home_api.dart';
import '../enums/home_section.dart';
import '../models/home_anime_model.dart';

class HomeRepository {
  final HomeApi _api = HomeApi();
  final JikanApi _jikan = JikanApi();

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
    int page = 1,
  }) async {
    // Return cached data if valid (only for page 1 to avoid cache pollution)
    if (!forceRefresh &&
        page == 1 &&
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
          result = await _api.getTrendingAnime(page: page);
          break;

        case HomeSection.thisSeason:
          final (season, seasonYear) = _currentSeason();
          result = await _api.getThisSeasonAnime(
            season: season,
            seasonYear: seasonYear,
            page: page,
          );
          break;

        case HomeSection.justReleased:
          result = await _api.getJustReleasedAnime(page: page);
          break;

        case HomeSection.popularThisWeek:
          result = await _api.getPopularThisWeek(page: page);
          break;

        case HomeSection.continueWatching:
          // Temporary until implemented
          result = await _api.getTrendingAnime(page: page);
          break;
      }

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final List media = result.data!['Page']['media'];

      final anime = media
          .map<HomeAnimeModel>(
            (item) => HomeAnimeModel.fromJson(item),
          )
          .toList();

      // Save in memory cache (only for page 1)
      if (page == 1) {
        _cache[section] = anime;
        _cacheTime[section] = DateTime.now();
      }

      return anime;
    } catch (_) {
      // AniList failed (403 / 429 / 500 / network) → automatic Jikan fallback.
      // If Jikan also fails, the AppFailure propagates and the UI shows a clean
      // error/retry state — never mock data.
      final anime = await _fetchAnimeFromJikan(section);
      if (page == 1) {
        _cache[section] = anime;
        _cacheTime[section] = DateTime.now();
      }
      return anime;
    }
  }

  /// Resolves the current AniList [MediaSeason] and its year from the device
  /// clock. December rolls into the next year's WINTER season, matching
  /// AniList's convention.
  (String, int) _currentSeason() {
    final now = DateTime.now();
    final month = now.month;

    if (month == 12) {
      return ('WINTER', now.year + 1);
    } else if (month <= 2) {
      return ('WINTER', now.year);
    } else if (month <= 5) {
      return ('SPRING', now.year);
    } else if (month <= 8) {
      return ('SUMMER', now.year);
    } else {
      return ('FALL', now.year);
    }
  }

  /// Fetches the equivalent section from Jikan (MyAnimeList) when AniList is
  /// unavailable. Each section has an ordered list of candidate endpoints: the
  /// ideal (semantically-correct) one first, then lighter/more reliable ones so
  /// a single upstream timeout never blanks the section.
  Future<List<HomeAnimeModel>> _fetchAnimeFromJikan(HomeSection section) async {
    final data = await _jikan.fetchListFallback(_jikanAnimePaths(section));
    return data
        .whereType<Map<String, dynamic>>()
        .map(_animeFromJikan)
        .toList();
  }

  List<String> _jikanAnimePaths(HomeSection section) {
    switch (section) {
      case HomeSection.trending:
      case HomeSection.continueWatching:
        return const ['/top/anime?filter=airing&limit=20'];
      case HomeSection.thisSeason:
        return const ['/seasons/now?limit=20'];
      case HomeSection.justReleased:
        // /seasons/now is sorted by recent start date on Jikan — ideal for
        // "just released".  Top airing is the safety net.
        return const [
          '/seasons/now?limit=20',
          '/top/anime?filter=airing&limit=20',
        ];
      case HomeSection.popularThisWeek:
        // Jikan has no "this week" filter; closest approximation is top airing
        // sorted by score (bypopularity includes all-time; airing is current).
        return const [
          '/top/anime?filter=airing&limit=20',
          '/seasons/now?limit=20',
        ];
    }
  }

  HomeAnimeModel _animeFromJikan(Map<String, dynamic> j) {
    final jpg = (j['images'] as Map<String, dynamic>?)?['jpg']
        as Map<String, dynamic>?;
    final english = j['title_english'] as String?;
    final score = j['score'];
    final episodes = j['episodes'];
    final genresList = (j['genres'] as List?)
            ?.whereType<Map>()
            .map((g) => g['name']?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        const <String>[];

    return HomeAnimeModel(
      id: (j['mal_id'] as num?)?.toInt() ?? 0,
      title: (english != null && english.isNotEmpty)
          ? english
          : (j['title'] as String? ?? 'Unknown'),
      coverImage: (jpg?['large_image_url'] ?? jpg?['image_url'] ?? '') as String,
      averageScore: score is num ? (score * 10).round() : null,
      episodes: episodes is num ? episodes.toInt() : null,
      genres: genresList,
    );
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