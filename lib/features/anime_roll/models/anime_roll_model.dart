class AnimeRollModel {
  final int id;
  final int? idMal;
  final String title;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int? averageScore;
  final int? episodes;
  final List<String> genres;
  final String description;
  final String? status;
  final bool isAdult;

  AnimeRollModel({
    required this.id,
    this.idMal,
    required this.title,
    required this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.averageScore,
    required this.episodes,
    required this.genres,
    required this.description,
    required this.status,
    this.isAdult = false,
  });

  String get romajiTitle => title;

  bool get hasGaps {
    return coverImage.isEmpty ||
        averageScore == null ||
        episodes == null ||
        genres.isEmpty ||
        description.isEmpty ||
        status == null;
  }

  factory AnimeRollModel.fromJson(Map<String, dynamic> json) {
    return AnimeRollModel(
      id: json['id'],
      idMal: json['idMal'],
      title: json['title']['romaji'] ?? '',
      englishTitle: json['title']['english'],
      coverImage: json['coverImage']?['extraLarge'] ?? '',
      bannerImage: json['bannerImage'] ?? '',
      averageScore: json['averageScore'],
      episodes: json['episodes'],
      genres: List<String>.from(json['genres'] ?? []),
      description: json['description'] ?? '',
      status: json['status'],
      isAdult: json['isAdult'] as bool? ?? false,
    );
  }

  factory AnimeRollModel.fromJikan(Map<String, dynamic> j) {
    final jpg = (j['images'] as Map?)?['jpg'] as Map?;
    final cover = jpg?['large_image_url'] ?? jpg?['image_url'] ?? '';
    final score = j['score'];
    final score100 = score is num ? (score * 10).round() : null;

    final genresList = (j['genres'] as List?)
            ?.whereType<Map>()
            .map((g) => g['name']?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        const <String>[];

    String? mediaStatus(Object? value) {
      if (value is! String) return null;
      switch (value) {
        case 'Currently Airing':
        case 'Publishing':
          return 'RELEASING';
        case 'Finished Airing':
        case 'Finished':
          return 'FINISHED';
        case 'Not yet aired':
        case 'Upcoming':
          return 'NOT_YET_RELEASED';
        case 'On Hiatus':
          return 'HIATUS';
        case 'Discontinued':
          return 'CANCELLED';
        default:
          return value.toUpperCase();
      }
    }

    return AnimeRollModel(
      id: j['mal_id'] ?? 0,
      idMal: j['mal_id'],
      title: j['title'] ?? '',
      englishTitle: j['title_english'] as String?,
      coverImage: cover,
      bannerImage: ((j['trailer'] as Map?)?['images'] as Map?)?['maximum_image_url'] as String? ?? '',
      averageScore: score100,
      episodes: j['episodes'] is num ? (j['episodes'] as num).toInt() : null,
      genres: genresList,
      description: j['synopsis'] ?? '',
      status: mediaStatus(j['status']),
      isAdult: false,
    );
  }

  AnimeRollModel fillMissing(Map<String, dynamic> j) {
    final jpg = (j['images'] as Map?)?['jpg'] as Map?;
    final cover = jpg?['large_image_url'] ?? jpg?['image_url'] ?? '';
    final score = j['score'];
    final score100 = score is num ? (score * 10).round() : null;

    final genresList = (j['genres'] as List?)
            ?.whereType<Map>()
            .map((g) => g['name']?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        const <String>[];

    String? mediaStatus(Object? value) {
      if (value is! String) return null;
      switch (value) {
        case 'Currently Airing':
        case 'Publishing':
          return 'RELEASING';
        case 'Finished Airing':
        case 'Finished':
          return 'FINISHED';
        case 'Not yet aired':
        case 'Upcoming':
          return 'NOT_YET_RELEASED';
        case 'On Hiatus':
          return 'HIATUS';
        case 'Discontinued':
          return 'CANCELLED';
        default:
          return value.toUpperCase();
      }
    }

    return AnimeRollModel(
      id: id,
      idMal: idMal ?? j['mal_id'] as int?,
      title: title.isEmpty ? (j['title'] ?? '') : title,
      englishTitle: englishTitle ?? j['title_english'] as String?,
      coverImage: coverImage.isEmpty ? cover : coverImage,
      bannerImage: bannerImage.isEmpty
          ? (((j['trailer'] as Map?)?['images'] as Map?)?['maximum_image_url'] as String? ?? '')
          : bannerImage,
      averageScore: averageScore ?? score100,
      episodes: episodes ?? (j['episodes'] as int?),
      genres: genres.isEmpty ? genresList : genres,
      description: description.isEmpty ? (j['synopsis'] ?? '') : description,
      status: status ?? mediaStatus(j['status']),
      isAdult: isAdult,
    );
  }
}