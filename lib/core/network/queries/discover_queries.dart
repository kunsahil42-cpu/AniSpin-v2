class DiscoverQueries {
  // 🌅 Anime of the Day
  static const String animeOfTheDay = r'''
query AnimeOfTheDay($page: Int) {
  Page(page: $page, perPage: 1) {
    media(
      type: ANIME
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
      }
      bannerImage
      averageScore
      episodes
      genres
      description(asHtml: false)
      status
    }
  }
}
''';

  // 📖 Manga of the Day
  static const String mangaOfTheDay = r'''
query MangaOfTheDay($page: Int) {
  Page(page: $page, perPage: 1) {
    media(
      type: MANGA
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
      }
      bannerImage
      averageScore
      genres
      description(asHtml: false)
      status
    }
  }
}
''';

  // 🎲 Random Anime
  static const String randomAnime = r'''
query RandomAnime($page: Int) {
  Page(page: $page, perPage: 1) {
    media(
      type: ANIME
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
      bannerImage
      averageScore
      episodes
      genres
      description(asHtml: false)
      status
    }
  }
}
''';

  // 🔥 Trending
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
      genres
    }
  }
}
''';

  // 💎 Hidden Gems
  static const String hiddenGems = r'''
query HiddenGems($page: Int) {
  Page(page: $page, perPage: 50) {
    media(
      type: ANIME
      sort: SCORE_DESC
      averageScore_greater: 80
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
      popularity
      genres
    }
  }
}
''';

  // 📅 Airing This Season
  static const String airingAnime = r'''
query AiringAnime($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: ANIME
      status: RELEASING
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
      genres
    }
  }
}
''';

  // ⭐ Top Rated
  static const String topRatedAnime = r'''
query TopRatedAnime($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: ANIME
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
      }
      averageScore
      genres
    }
  }
}
''';

  // 🎲 Random Manga
  static const String randomManga = r'''
query RandomManga($page: Int) {
  Page(page: $page, perPage: 1) {
    media(
      type: MANGA
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
      bannerImage
      averageScore
      genres
      description(asHtml: false)
      status
    }
  }
}
''';

  // 🔥 Trending Manga
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
      }
      averageScore
      genres
    }
  }
}
''';

  // 💎 Hidden Gems Manga
  static const String hiddenGemsManga = r'''
query HiddenGemsManga($page: Int) {
  Page(page: $page, perPage: 50) {
    media(
      type: MANGA
      sort: SCORE_DESC
      averageScore_greater: 80
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
      popularity
      genres
    }
  }
}
''';

  // 📅 Airing This Season Manga (Currently Publishing)
  static const String airingManga = r'''
query AiringManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
      status: RELEASING
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
      genres
    }
  }
}
''';

  // ⭐ Top Rated Manga
  static const String topRatedManga = r'''
query TopRatedManga($page: Int) {
  Page(page: $page, perPage: 20) {
    media(
      type: MANGA
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
      }
      averageScore
      genres
    }
  }
}
''';
}