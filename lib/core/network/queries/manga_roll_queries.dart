class MangaRollQueries {
  static const String randomManga = r'''
query RandomManga($page: Int, $genre: String, $format: MediaFormat, $minScore: Int) {
  Page(page: $page, perPage: 1) {
    pageInfo {
      total
    }
    media(
      type: MANGA
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

      chapters

      volumes

      genres

      isAdult

      description(asHtml: false)

      status
    }
  }
}
''';
}
