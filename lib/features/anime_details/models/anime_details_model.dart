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
}