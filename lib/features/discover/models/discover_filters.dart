class DiscoverFilters {
  final bool isManga;
  final List<String> genres;
  final String? season;
  final List<int> years;
  final List<String> types;
  final List<String> statuses;
  final List<String> languages;
  final List<String> ratings;
  final List<String> sources;
  final int? minRange;
  final int? maxRange;
  final String sortBy;

  const DiscoverFilters({
    required this.isManga,
    required this.genres,
    this.season,
    required this.years,
    required this.types,
    required this.statuses,
    required this.languages,
    required this.ratings,
    required this.sources,
    this.minRange,
    this.maxRange,
    required this.sortBy,
  });

  bool get isEmpty {
    return genres.isEmpty &&
        season == null &&
        years.isEmpty &&
        types.isEmpty &&
        statuses.isEmpty &&
        languages.isEmpty &&
        ratings.isEmpty &&
        sources.isEmpty &&
        minRange == null &&
        maxRange == null &&
        (sortBy == "Default" || sortBy.isEmpty);
  }

  int get activeCount {
    int count = 0;
    if (genres.isNotEmpty) count += genres.length;
    if (season != null) count += 1;
    if (years.isNotEmpty) count += years.length;
    if (types.isNotEmpty) count += types.length;
    if (statuses.isNotEmpty) count += statuses.length;
    if (languages.isNotEmpty) count += languages.length;
    if (ratings.isNotEmpty) count += ratings.length;
    if (sources.isNotEmpty) count += sources.length;
    if (minRange != null) count += 1;
    if (maxRange != null) count += 1;
    if (sortBy != "Default" && sortBy.isNotEmpty) count += 1;
    return count;
  }

  Map<String, dynamic> toVariables(int page) {
    final Map<String, dynamic> vars = {
      'page': page,
      'perPage': 20,
    };

    // 1. Media Type
    vars['type'] = isManga ? 'MANGA' : 'ANIME';

    // 2. Adult filtering
    final hasAdultSelected = genres.contains("Adult") ||
        genres.contains("Hentai") ||
        genres.contains("Smut") ||
        ratings.contains("Adult") ||
        ratings.contains("Rx");
    if (hasAdultSelected) {
      vars['isAdult'] = true;
    } else {
      vars['isAdult'] = false;
    }

    // 3. Genres & Tags
    final aniListGenres = const {
      "Action", "Adventure", "Comedy", "Drama", "Ecchi", "Fantasy",
      "Horror", "Mahou Shoujo", "Mecha", "Music", "Mystery", "Psychological",
      "Romance", "Sci-Fi", "Slice of Life", "Sports", "Supernatural", "Thriller"
    };

    final mappedGenres = <String>[];
    final mappedTags = <String>[];

    for (final genre in genres) {
      if (aniListGenres.contains(genre)) {
        mappedGenres.add(genre);
      } else if (genre == "Magical Girls") {
        mappedGenres.add("Mahou Shoujo");
      } else {
        if (genre == "Gourmet") {
          mappedTags.add("Food");
        } else if (genre == "Avant Garde") {
          mappedTags.add("Experimental");
        } else if (genre == "Boys Love") {
          mappedTags.add("Boys Love");
        } else if (genre == "Girls Love") {
          mappedTags.add("Girls Love");
        } else if (genre == "Shoujo Ai") {
          mappedTags.add("Shoujo Ai");
        } else if (genre == "Shounen Ai") {
          mappedTags.add("Shounen Ai");
        } else if (genre == "Kids") {
          mappedTags.add("Kids");
        } else if (genre == "Magic") {
          mappedTags.add("Magic");
        } else if (genre == "Hentai") {
          mappedTags.add("Hentai");
        } else if (genre == "Smut") {
          mappedTags.add("Smut");
        } else if (genre == "Adult") {
          // Handled via isAdult
        } else {
          mappedTags.add(genre);
        }
      }
    }

    if (mappedGenres.isNotEmpty) {
      vars['genres'] = mappedGenres;
    }
    if (mappedTags.isNotEmpty) {
      vars['tags'] = mappedTags;
    }

    // 4. Season (Anime only)
    if (!isManga && season != null) {
      final allowedSeasons = const ["Winter", "Spring", "Summer", "Fall"];
      if (allowedSeasons.contains(season)) {
        vars['season'] = season!.toUpperCase();
      }
    }

    // 5. Year (Both - AniList seasonYear)
    if (years.isNotEmpty) {
      vars['seasonYear'] = years.first;
    }

    // 6. Type (Format)
    if (!isManga) {
      final allowedAnimeTypes = const {
        "TV": "TV",
        "Movie": "MOVIE",
        "OVA": "OVA",
        "ONA": "ONA",
        "Special": "SPECIAL",
        "TV Special": "TV",
        "Music": "MUSIC",
      };
      final formats = <String>[];
      for (final type in types) {
        if (allowedAnimeTypes.containsKey(type)) {
          formats.add(allowedAnimeTypes[type]!);
        }
      }
      if (formats.isNotEmpty) {
        vars['formats'] = formats;
      }
    } else {
      final allowedMangaTypes = const {
        "Manga": "MANGA",
        "Novel": "NOVEL",
        "One Shot": "ONE_SHOT",
        "Doujinshi": "MANGA",
        "Light Novel": "NOVEL",
        "Web Manga": "MANGA",
        "Web Novel": "NOVEL",
        "Comic": "MANGA",
      };
      final formats = <String>[];
      for (final type in types) {
        if (allowedMangaTypes.containsKey(type)) {
          formats.add(allowedMangaTypes[type]!);
        }
        if (type == "Manhwa") {
          formats.add("MANGA");
          vars['countryOfOrigin'] = "KR";
        } else if (type == "Manhua") {
          formats.add("MANGA");
          vars['countryOfOrigin'] = "CN";
        }
      }
      if (formats.isNotEmpty) {
        vars['formats'] = formats.toSet().toList();
      }
    }

    // 7. Status
    if (!isManga) {
      final allowedAnimeStatuses = const {
        "Currently Airing": "RELEASING",
        "Finished Airing": "FINISHED",
        "Not Yet Aired": "NOT_YET_RELEASED",
      };
      final stats = <String>[];
      for (final status in statuses) {
        if (allowedAnimeStatuses.containsKey(status)) {
          stats.add(allowedAnimeStatuses[status]!);
        }
      }
      if (stats.isNotEmpty) {
        vars['statuses'] = stats;
      }
    } else {
      final allowedMangaStatuses = const {
        "Publishing": "RELEASING",
        "Finished": "FINISHED",
        "On Hiatus": "HIATUS",
        "Cancelled": "CANCELLED",
      };
      final stats = <String>[];
      for (final status in statuses) {
        if (allowedMangaStatuses.containsKey(status)) {
          stats.add(allowedMangaStatuses[status]!);
        }
      }
      if (stats.isNotEmpty) {
        vars['statuses'] = stats;
      }
    }

    // 8. Language (Ignore unsupported filters)

    // 9. Rating (Ignore unsupported filters)

    // 10. Source
    final allowedSources = const {
      "Manga": "MANGA",
      "Original": "ORIGINAL",
      "Light Novel": "LIGHT_NOVEL",
      "Web Novel": "WEB_NOVEL",
      "Novel": "NOVEL",
      "Visual Novel": "VISUAL_NOVEL",
      "Game": "VIDEO_GAME",
      "Comic": "COMIC",
      "Web Manga": "WEB_MANGA",
    };
    final srcs = <String>[];
    for (final src in sources) {
      if (allowedSources.containsKey(src)) {
        srcs.add(allowedSources[src]!);
      }
    }
    if (srcs.isNotEmpty) {
      vars['sources'] = srcs;
    }

    // 11. Ranges
    if (!isManga) {
      if (minRange != null) vars['episodesGreater'] = minRange! - 1;
      if (maxRange != null) vars['episodesLesser'] = maxRange! + 1;
    } else {
      if (minRange != null) vars['chaptersGreater'] = minRange! - 1;
      if (maxRange != null) vars['chaptersLesser'] = maxRange! + 1;
    }

    // 12. Sort
    final sortList = <String>[];
    switch (sortBy) {
      case "Popularity":
        sortList.add("POPULARITY_DESC");
        break;
      case "Trending":
        sortList.add("TRENDING_DESC");
        break;
      case "Latest Updated":
        sortList.add("UPDATED_AT_DESC");
        break;
      case "Recently Added":
        sortList.add("ID_DESC");
        break;
      case "Highest Rated":
        sortList.add("SCORE_DESC");
        break;
      case "Release Date":
        sortList.add("START_DATE_DESC");
        break;
      case "A-Z":
        sortList.add("TITLE_ROMAJI");
        break;
      case "Z-A":
        sortList.add("TITLE_ROMAJI_DESC");
        break;
      default:
        sortList.add("POPULARITY_DESC");
        break;
    }
    vars['sort'] = sortList;

    return vars;
  }
}
