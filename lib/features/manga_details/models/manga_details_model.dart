class MangaDetailsModel {
  final int id;

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

  MangaDetailsModel({
    required this.id,
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
  });

  factory MangaDetailsModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MangaDetailsModel(
      id: json['id'],

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

      author:
          (json['staff']?['edges'] as List?)
                      ?.isNotEmpty ==
                  true
              ? json['staff']['edges'][0]
                      ['node']['name']['full'] ??
                  ''
              : '',
    );
  }
}