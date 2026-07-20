class DiscoverFilterQueries {
  static String buildFilterQuery(Map<String, dynamic> variables) {
    final queryArgs = <String>[];
    final mediaArgs = <String>[];

    // Page args are always present
    queryArgs.add(r'$page: Int');
    queryArgs.add(r'$perPage: Int');

    if (variables.containsKey('type')) {
      queryArgs.add(r'$type: MediaType');
      mediaArgs.add(r'type: $type');
    }
    if (variables.containsKey('genres')) {
      queryArgs.add(r'$genres: [String]');
      mediaArgs.add(r'genre_in: $genres');
    }
    if (variables.containsKey('tags')) {
      queryArgs.add(r'$tags: [String]');
      mediaArgs.add(r'tag_in: $tags');
    }
    if (variables.containsKey('season')) {
      queryArgs.add(r'$season: MediaSeason');
      mediaArgs.add(r'season: $season');
    }
    if (variables.containsKey('seasonYear')) {
      queryArgs.add(r'$seasonYear: Int');
      mediaArgs.add(r'seasonYear: $seasonYear');
    }
    if (variables.containsKey('formats')) {
      queryArgs.add(r'$formats: [MediaFormat]');
      mediaArgs.add(r'format_in: $formats');
    }
    if (variables.containsKey('statuses')) {
      queryArgs.add(r'$statuses: [MediaStatus]');
      mediaArgs.add(r'status_in: $statuses');
    }
    if (variables.containsKey('sources')) {
      queryArgs.add(r'$sources: [MediaSource]');
      mediaArgs.add(r'source_in: $sources');
    }
    if (variables.containsKey('episodesGreater')) {
      queryArgs.add(r'$episodesGreater: Int');
      mediaArgs.add(r'episodes_greater: $episodesGreater');
    }
    if (variables.containsKey('episodesLesser')) {
      queryArgs.add(r'$episodesLesser: Int');
      mediaArgs.add(r'episodes_lesser: $episodesLesser');
    }
    if (variables.containsKey('chaptersGreater')) {
      queryArgs.add(r'$chaptersGreater: Int');
      mediaArgs.add(r'chapters_greater: $chaptersGreater');
    }
    if (variables.containsKey('chaptersLesser')) {
      queryArgs.add(r'$chaptersLesser: Int');
      mediaArgs.add(r'chapters_lesser: $chaptersLesser');
    }
    if (variables.containsKey('sort')) {
      queryArgs.add(r'$sort: [MediaSort]');
      mediaArgs.add(r'sort: $sort');
    }
    if (variables.containsKey('countryOfOrigin')) {
      queryArgs.add(r'$countryOfOrigin: CountryCode');
      mediaArgs.add(r'countryOfOrigin: $countryOfOrigin');
    }
    if (variables.containsKey('isAdult')) {
      queryArgs.add(r'$isAdult: Boolean');
      mediaArgs.add(r'isAdult: $isAdult');
    }

    final queryArgsStr = queryArgs.join(', ');
    final mediaArgsStr = mediaArgs.join(', ');

    return '''
query DiscoverFilter($queryArgsStr) {
  Page(page: \$page, perPage: \$perPage) {
    pageInfo {
      total
      perPage
      currentPage
      lastPage
      hasNextPage
    }
    media($mediaArgsStr) {
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
      chapters
      genres
      isAdult
      description(asHtml: false)
      status
    }
  }
}
''';
  }
}
