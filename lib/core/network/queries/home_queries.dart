class HomeQueries {
  // 🔥 Trending — ranked by AniList's live trending score (recalculated hourly)
  static const String trendingAnime = r'''
query TrendingAnime($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: ANIME
      sort: TRENDING_DESC
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
      }
      averageScore
      episodes
      genres
    }
  }
}
''';

  // 🌸 This Season — current season is resolved dynamically at call time
  static const String thisSeasonAnime = r'''
query ThisSeasonAnime($season: MediaSeason, $seasonYear: Int, $page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: ANIME
      season: $season
      seasonYear: $seasonYear
      sort: POPULARITY_DESC
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
      }
      averageScore
      episodes
      genres
    }
  }
}
''';

  // 🆕 Just Released — most recently started airing titles, sorted by newest
  //   start date so the freshest premieres appear first.
  //   startDate_greater is passed at call time (30 days ago) so only genuinely
  //   recent shows appear rather than long-running classics.
  static const String justReleasedAnime = r'''
query JustReleasedAnime($startDateGreater: FuzzyDateInt, $page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: ANIME
      status: RELEASING
      sort: [START_DATE_DESC, SCORE_DESC]
      startDate_greater: $startDateGreater
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
      }
      averageScore
      episodes
      genres
    }
  }
}
''';

  // 🏆 Popular This Week — highest rated and most popular airing anime of the current week.
  //   Uses TRENDING_DESC to capture active weekly popularity and SCORE_DESC for quality.
  static const String popularThisWeek = r'''
query PopularThisWeekAnime($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: ANIME
      status: RELEASING
      sort: [TRENDING_DESC, SCORE_DESC]
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
      }
      averageScore
      episodes
      genres
    }
  }
}
''';
}