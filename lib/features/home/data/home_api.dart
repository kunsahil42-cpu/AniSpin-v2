import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/network/graphql_service.dart';
import '../../../core/network/queries/home_queries.dart';

class HomeApi {
  Future<QueryResult> getTrendingAnime({int page = 1}) {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(
          HomeQueries.trendingAnime,
        ),
        variables: {'page': page},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  Future<QueryResult> getThisSeasonAnime({
    required String season,
    required int seasonYear,
    int page = 1,
  }) {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(
          HomeQueries.thisSeasonAnime,
        ),
        variables: {
          'season': season,
          'seasonYear': seasonYear,
          'page': page,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  /// Returns the 20 most-recently-started airing anime.
  ///
  /// The [startDateGreater] AniList FuzzyDateInt (YYYYMMDD0 format) is
  /// computed here so results are always restricted to the past 30 days,
  /// ensuring genuinely new premieres appear rather than classic long-runners.
  Future<QueryResult> getJustReleasedAnime({int page = 1}) {
    final startDateGreater = _fuzzyDate(
      DateTime.now().subtract(const Duration(days: 30)),
    );
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(
          HomeQueries.justReleasedAnime,
        ),
        variables: {'startDateGreater': startDateGreater, 'page': page},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  /// Returns the most-trending airing anime for the current week.
  ///
  /// Uses TRENDING_DESC and SCORE_DESC to capture currently active/airing
  /// shows that are highly rated.
  Future<QueryResult> getPopularThisWeek({int page = 1}) {
    return GraphQLService.client.query(
      QueryOptions(
        document: gql(
          HomeQueries.popularThisWeek,
        ),
        variables: {'page': page},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  /// Converts a [DateTime] to an AniList FuzzyDateInt (YYYYMMDD).
  ///
  /// AniList uses standard 8-digit integers like 20260701 for 2026-07-01
  /// for date filtering arguments (startDate_greater / startDate_lesser).
  static int _fuzzyDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return int.parse('$y$m$day');
  }
}