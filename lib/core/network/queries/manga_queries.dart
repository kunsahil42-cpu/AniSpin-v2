class MangaQueries {
  // 🔥 Trending — manga trending right now by AniList trend weight
  static const String trendingManga = r'''
query TrendingManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
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
        large
      }
      averageScore
      genres
      chapters
      isAdult
    }
  }
}
''';

  // 🆕 Best Ongoing — highest RATED ongoing manga (status: RELEASING,
  //   sorted by SCORE_DESC so the best-quality serialised manga appear first).
  static const String popularManga = r'''
query BestOngoingManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
      status: RELEASING
      sort: SCORE_DESC
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
        large
      }
      averageScore
      genres
      chapters
      isAdult
    }
  }
}
''';

  // 🌟 Top Rated Picks — highest rated manga released in the last month.
  //   startDate_greater is computed at call time (first day of last month,
  //   FuzzyDateInt = YYYYMMDD0) and passed as a variable.
  //   Completed + ongoing are both allowed (no status filter).
  static const String latestManga = r'''
query TopRatedPicksManga($page: Int, $startDateGreater: FuzzyDateInt) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
      sort: SCORE_DESC
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
        large
      }
      averageScore
      genres
      chapters
      isAdult
    }
  }
}
''';

  // 🏆 Popular This Week — highest trending manga from the current week.
  //   Uses TRENDING_DESC and SCORE_DESC for currently publishing manga.
  static const String recommendedManga = r'''
query PopularThisWeekManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
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
        large
      }
      averageScore
      genres
      chapters
      isAdult
    }
  }
}
''';

  // 🆕 Latest Releases — recently updated manga from AniList (UPDATED_AT_DESC)
  static const String latestReleasesManga = r'''
query LatestReleasesManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
      sort: UPDATED_AT_DESC
      isAdult: false
    ) {
      id
      title {
        romaji
        english
      }
      coverImage {
        extraLarge
        large
      }
      averageScore
      genres
      chapters
      isAdult
    }
  }
}
''';

  static const String searchManga = r'''
query SearchManga($search: String) {
  Page(page: 1, perPage: 20) {
    media(search: $search, type: MANGA) {
      id
      title {
        romaji
        english
      }
      coverImage {
        large
      }
      averageScore
      chapters
      status
      genres
      isAdult
    }
  }
}
''';
}
