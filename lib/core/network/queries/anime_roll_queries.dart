class AnimeRollQueries {
  static const String randomAnime = r'''
query RandomAnime($page: Int, $genre: String, $format: MediaFormat, $minScore: Int) {
  Page(page: $page, perPage: 1) {
    pageInfo {
      total
    }
    media(
      type: ANIME
      sort: POPULARITY_DESC
      genre: $genre
      format: $format
      averageScore_greater: $minScore
      isAdult: false
    ) {
      id
      idMal

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

      isAdult

      description(asHtml: false)

      status
    }
  }
}
''';
}