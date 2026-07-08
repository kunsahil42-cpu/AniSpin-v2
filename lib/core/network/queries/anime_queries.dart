class AnimeQueries {
  static const String searchAnime = r'''
query SearchAnime($search: String) {
  Page(page: 1, perPage: 20) {
    media(search: $search, type: ANIME) {
      id
      title {
        romaji
        english
      }
      coverImage {
        large
      }
      averageScore
      episodes
      status
      genres
    }
  }
}
''';
}