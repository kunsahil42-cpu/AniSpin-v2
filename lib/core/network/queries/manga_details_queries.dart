class MangaDetailsQueries {
  static const String getMangaDetails = r'''
query GetMangaDetails($id: Int) {
  Media(id: $id, type: MANGA) {
    id

    title {
      romaji
      english
      native
    }

    description(asHtml: false)

    bannerImage

    coverImage {
      extraLarge
      large
    }

    averageScore

    chapters

    volumes

    status

    genres

    format

    popularity

    staff(sort: RELEVANCE, perPage: 1) {
      edges {
        node {
          name {
            full
          }
        }
      }
    }
  }
}
''';
}