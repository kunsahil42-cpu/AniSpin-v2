class AnimeDetailsModel {
  final int id;

  /// MyAnimeList id, used to bridge to Jikan when AniList data is partial.
  /// Non-UI field.
  final int? idMal;

  final String romajiTitle;
  final String? englishTitle;
  final String? nativeTitle;

  final String description;

  final String bannerImage;
  final String coverImage;

  final int? averageScore;
  final int? episodes;
  final String? status;

  final List<String> genres;

  final String? season;
  final int? seasonYear;

  final int? duration;
  final String? format;

  final int? popularity;

  final String studio;
  final List<StreamingEpisode> streamingEpisodes;
  final NextAiringEpisode? nextAiringEpisode;
  final bool isAdult;

  AnimeDetailsModel({
    required this.id,
    this.idMal,
    required this.romajiTitle,
    required this.englishTitle,
    required this.nativeTitle,
    required this.description,
    required this.bannerImage,
    required this.coverImage,
    required this.averageScore,
    required this.episodes,
    required this.status,
    required this.genres,
    required this.season,
    required this.seasonYear,
    required this.duration,
    required this.format,
    required this.popularity,
    required this.studio,
    this.streamingEpisodes = const [],
    this.nextAiringEpisode,
    this.isAdult = false,
  });

  factory AnimeDetailsModel.fromJson(Map<String, dynamic> json) {
    return AnimeDetailsModel(
      id: json['id'],

      idMal: json['idMal'],

      romajiTitle: json['title']['romaji'] ?? '',
      englishTitle: json['title']['english'],
      nativeTitle: json['title']['native'],

      description: json['description'] ?? '',

      bannerImage: json['bannerImage'] ?? '',

      coverImage: json['coverImage']['extraLarge'] ??
          json['coverImage']['large'] ??
          '',

      averageScore: json['averageScore'],

      episodes: json['episodes'],

      status: json['status'],

      genres: List<String>.from(json['genres'] ?? []),

      season: json['season'],

      seasonYear: json['seasonYear'],

      duration: json['duration'],

      format: json['format'],

      popularity: json['popularity'],

      studio: (json['studios']?['nodes'] as List?)?.isNotEmpty == true
          ? json['studios']['nodes'][0]['name']
          : '',

      streamingEpisodes: (json['streamingEpisodes'] as List?)
              ?.map((e) => StreamingEpisode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],

      nextAiringEpisode: json['nextAiringEpisode'] != null
          ? NextAiringEpisode.fromJson(json['nextAiringEpisode'] as Map<String, dynamic>)
          : null,
          
      isAdult: json['isAdult'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idMal': idMal,
      'romajiTitle': romajiTitle,
      'englishTitle': englishTitle,
      'nativeTitle': nativeTitle,
      'description': description,
      'bannerImage': bannerImage,
      'coverImage': coverImage,
      'averageScore': averageScore,
      'episodes': episodes,
      'status': status,
      'genres': genres,
      'season': season,
      'seasonYear': seasonYear,
      'duration': duration,
      'format': format,
      'popularity': popularity,
      'studio': studio,
      'streamingEpisodes': streamingEpisodes.map((e) => e.toJson()).toList(),
      'nextAiringEpisode': nextAiringEpisode?.toJson(),
      'isAdult': isAdult,
    };
  }

  factory AnimeDetailsModel.fromCacheJson(Map<String, dynamic> json) {
    return AnimeDetailsModel(
      id: json['id'] as int,
      idMal: json['idMal'] as int?,
      romajiTitle: json['romajiTitle'] as String? ?? '',
      englishTitle: json['englishTitle'] as String?,
      nativeTitle: json['nativeTitle'] as String?,
      description: json['description'] as String? ?? '',
      bannerImage: json['bannerImage'] as String? ?? '',
      coverImage: json['coverImage'] as String? ?? '',
      averageScore: json['averageScore'] as int?,
      episodes: json['episodes'] as int?,
      status: json['status'] as String?,
      genres: List<String>.from(json['genres'] as Iterable? ?? const []),
      season: json['season'] as String?,
      seasonYear: json['seasonYear'] as int?,
      duration: json['duration'] as int?,
      format: json['format'] as String?,
      popularity: json['popularity'] as int?,
      studio: json['studio'] as String? ?? '',
      streamingEpisodes: (json['streamingEpisodes'] as List?)
              ?.map((e) => StreamingEpisode.fromCacheJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      nextAiringEpisode: json['nextAiringEpisode'] != null
          ? NextAiringEpisode.fromCacheJson(json['nextAiringEpisode'] as Map<String, dynamic>)
          : null,
      isAdult: json['isAdult'] as bool? ?? false,
    );
  }
}

class StreamingEpisode {
  final String title;
  final String thumbnail;
  final String url;
  final String site;

  StreamingEpisode({
    required this.title,
    required this.thumbnail,
    required this.url,
    required this.site,
  });

  factory StreamingEpisode.fromJson(Map<String, dynamic> json) {
    return StreamingEpisode(
      title: json['title']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      site: json['site']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'thumbnail': thumbnail,
      'url': url,
      'site': site,
    };
  }

  factory StreamingEpisode.fromCacheJson(Map<String, dynamic> json) {
    return StreamingEpisode(
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      url: json['url'] as String? ?? '',
      site: json['site'] as String? ?? '',
    );
  }
}

class NextAiringEpisode {
  final int episode;
  final int airingAt;

  NextAiringEpisode({
    required this.episode,
    required this.airingAt,
  });

  factory NextAiringEpisode.fromJson(Map<String, dynamic> json) {
    return NextAiringEpisode(
      episode: json['episode'] ?? 0,
      airingAt: json['airingAt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'episode': episode,
      'airingAt': airingAt,
    };
  }

  factory NextAiringEpisode.fromCacheJson(Map<String, dynamic> json) {
    return NextAiringEpisode(
      episode: json['episode'] as int? ?? 0,
      airingAt: json['airingAt'] as int? ?? 0,
    );
  }
}