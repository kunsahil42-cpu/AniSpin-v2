class MangaDetailsQueries {
  static const String getMangaDetails = r'''
query GetMangaDetails($id: Int) {
  Media(id: $id, type: MANGA) {
    id
    idMal

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

    isAdult

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