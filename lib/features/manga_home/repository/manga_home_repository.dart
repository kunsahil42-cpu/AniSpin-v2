import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../core/network/graphql_service.dart';
import '../../../core/network/jikan/jikan_api.dart';
import '../../../core/network/queries/manga_queries.dart';
import '../../../core/error/app_failure.dart';
import '../models/manga_home_model.dart';

enum MangaHomeSection {
  trending,
  popular,
  latestReleases,
  latest,
  recommended,
}

class MangaHomeRepository {
  final JikanApi _jikan = JikanApi();

  MangaHomeRepository();

  // In-memory session cache (mirrors HomeRepository) so a section is fetched
  // from whichever source succeeds at most once per [_cacheDuration].
  final Map<MangaHomeSection, List<MangaHomeModel>> _cache = {};
  final Map<MangaHomeSection, DateTime> _cacheTime = {};

  static const Duration _cacheDuration = Duration(minutes: 5);

  Future<List<MangaHomeModel>> getMangaList(MangaHomeSection section, {int page = 1}) async {
    final cached = _cache[section];
    final cachedAt = _cacheTime[section];
    if (page == 1 &&
        cached != null &&
        cachedAt != null &&
        DateTime.now().difference(cachedAt) < _cacheDuration) {
      return cached;
    }

    try {
      late final String query;
      late final Map<String, dynamic> variables;

      switch (section) {
        case MangaHomeSection.trending:
          query = MangaQueries.trendingManga;
          variables = {'page': page};
          break;
        case MangaHomeSection.popular:
          // Best Ongoing — highest rated releasing manga (SCORE_DESC)
          query = MangaQueries.popularManga;
          variables = {'page': page};
          break;
        case MangaHomeSection.latestReleases:
          query = MangaQueries.latestReleasesManga;
          variables = {'page': page};
          break;
        case MangaHomeSection.latest:
          // Top Rated Picks — highest rated manga from the last month.
          // startDateGreater is the first day of last month (FuzzyDateInt).
          query = MangaQueries.latestManga;
          variables = {
            'page': page,
            'startDateGreater': _lastMonthFuzzy(),
          };
          break;
        case MangaHomeSection.recommended:
          // Popular This Week — trending manga from the current week.
          query = MangaQueries.recommendedManga;
          variables = {'page': page};
          break;
      }

      final result = await GraphQLService.client.query(
        QueryOptions(
          document: gql(query),
          variables: variables,
        ),
      );

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final List media = result.data?['Page']?['media'] ?? [];

      final list = media
          .map<MangaHomeModel>((item) => MangaHomeModel.fromJson(item))
          .toList();
      if (page == 1) {
        _cache[section] = list;
        _cacheTime[section] = DateTime.now();
      }
      return list;
    } catch (_) {
      // AniList failed (403 / 429 / 500 / network) → fallback to Jikan.
      final list = await _fetchMangaFromJikan(section);
      _cache[section] = list;
      _cacheTime[section] = DateTime.now();
      return list;
    }
  }

  /// Fetches the equivalent section from Jikan when AniList is unavailable.
  Future<List<MangaHomeModel>> _fetchMangaFromJikan(
    MangaHomeSection section,
  ) async {
    final data = await _jikan.fetchListFallback(_jikanMangaPaths(section));
    return data
        .whereType<Map<String, dynamic>>()
        .map(_mangaFromJikan)
        .toList();
  }

  List<String> _jikanMangaPaths(MangaHomeSection section) {
    switch (section) {
      case MangaHomeSection.trending:
        return const [
          '/top/manga?filter=publishing&limit=20',
          '/top/manga?limit=20',
        ];
      case MangaHomeSection.popular:
        return const [
          '/top/manga?filter=publishing&limit=20',
          '/top/manga?limit=20',
        ];
      case MangaHomeSection.latestReleases:
        return const [
          '/top/manga?filter=publishing&limit=20',
          '/top/manga?limit=20',
        ];
      case MangaHomeSection.latest:
        return const [
          '/top/manga?limit=20',
          '/top/manga?filter=bypopularity&limit=20',
        ];
      case MangaHomeSection.recommended:
        return const [
          '/top/manga?filter=publishing&limit=20',
          '/top/manga?limit=20',
        ];
    }
  }

  MangaHomeModel _mangaFromJikan(Map<String, dynamic> j) {
    final jpg = (j['images'] as Map<String, dynamic>?)?['jpg']
        as Map<String, dynamic>?;
    final english = j['title_english'] as String?;
    final score = j['score'];
    final chapters = j['chapters'];
    final genres = (j['genres'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((g) => g['name']?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        <String>[];

    return MangaHomeModel(
      id: (j['mal_id'] as num?)?.toInt() ?? 0,
      title: (english != null && english.isNotEmpty)
          ? english
          : (j['title'] as String? ?? 'Unknown'),
      coverImage: (jpg?['large_image_url'] ?? jpg?['image_url'] ?? '') as String,
      averageScore: score is num ? (score * 10).round() : null,
      genres: genres,
      chapters: chapters is num ? chapters.toInt() : null,
    );
  }

  // ── date helpers ──────────────────────────────────────────────────────────

  /// Converts a [DateTime] to an AniList FuzzyDateInt (YYYYMMDD format).
  static int _fuzzyDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return int.parse('$y$m$day');
  }

  /// Returns FuzzyDateInt for the first day of last month.
  static int _lastMonthFuzzy() {
    final now = DateTime.now();
    final lastMonth = now.month == 1
        ? DateTime(now.year - 1, 12, 1)
        : DateTime(now.year, now.month - 1, 1);
    return _fuzzyDate(lastMonth);
  }
}
