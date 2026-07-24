class MangaDetailsModel {
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

  final int? chapters;
  final int? volumes;

  final String? status;

  final List<String> genres;

  final String? format;

  final int? popularity;

  final String author;
  final bool isAdult;
  final String? mangaDexId;
  final int? aniListId;
  final String? sourceName;

  MangaDetailsModel({
    required this.id,
    this.idMal,
    required this.romajiTitle,
    required this.englishTitle,
    required this.nativeTitle,
    required this.description,
    required this.bannerImage,
    required this.coverImage,
    required this.averageScore,
    required this.chapters,
    required this.volumes,
    required this.status,
    required this.genres,
    required this.format,
    required this.popularity,
    required this.author,
    this.isAdult = false,
    this.mangaDexId,
    this.aniListId,
    this.sourceName,
  });

  factory MangaDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MangaDetailsModel(
      id: json['id'],

      idMal: json['idMal'],

      romajiTitle: json['title']['romaji'] ?? '',
      englishTitle: json['title']['english'],
      nativeTitle: json['title']['native'],

      description: json['description'] ?? '',

      bannerImage: json['bannerImage'] ?? '',

      coverImage:
          json['coverImage']['extraLarge'] ??
          json['coverImage']['large'] ??
          '',

      averageScore: json['averageScore'],

      chapters: json['chapters'],

      volumes: json['volumes'],

      status: json['status'],

      genres: List<String>.from(
        json['genres'] ?? [],
      ),

      format: json['format'],

      popularity: json['popularity'],

      isAdult: json['isAdult'] as bool? ?? false,

      author:
          (json['staff']?['edges'] as List?)
                      ?.isNotEmpty ==
                  true
              ? json['staff']['edges'][0]
                      ['node']['name']['full'] ??
                  ''
              : '',
      mangaDexId: null,
      aniListId: json['id'],
      sourceName: 'anilist',
    );
  }
}