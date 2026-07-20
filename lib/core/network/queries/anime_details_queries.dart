class AnimeDetailsQueries {
  static const String getAnimeDetails = r'''
query GetAnimeDetails($id: Int) {
  Media(id: $id, type: ANIME) {
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

    episodes

    status

    genres

    isAdult

    season

    seasonYear

    duration

    format

    popularity

    studios(isMain: true) {
      nodes {
        name
      }
    }

    streamingEpisodes {
      title
      thumbnail
      url
      site
    }

    nextAiringEpisode {
      episode
      airingAt
    }
  }
}
''';
}