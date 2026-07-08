class DiscoverMangaModel {
  final int id;
  final String title;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int? averageScore;
  final int? popularity;
  final List<String> genres;
  final String description;
  final String? status;

  const DiscoverMangaModel({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.averageScore,
    this.popularity,
    required this.genres,
    required this.description,
    required this.status,
  });

  factory DiscoverMangaModel.fromJson(Map<String, dynamic> json) {
    return DiscoverMangaModel(
      id: json['id'],

      title: json['title']['romaji'] ?? '',

      englishTitle: json['title']['english'],

      coverImage:
          json['coverImage']?['extraLarge'] ?? '',

      bannerImage:
          json['bannerImage'] ?? '',

      averageScore:
          json['averageScore'],

      popularity:
          json['popularity'],

      genres: List<String>.from(
        json['genres'] ?? [],
      ),

      description:
          json['description'] ?? '',

      status:
          json['status'],
    );
  }
}