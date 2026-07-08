class DiscoverAnimeModel {
  final int id;
  final String title;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int? averageScore;
  final int? popularity;
  final int? episodes;
  final List<String> genres;
  final String description;
  final String? status;

  const DiscoverAnimeModel({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.averageScore,
    this.popularity,
    required this.episodes,
    required this.genres,
    required this.description,
    required this.status,
  });

  factory DiscoverAnimeModel.fromJson(Map<String, dynamic> json) {
    return DiscoverAnimeModel(
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

      episodes:
          json['episodes'],

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