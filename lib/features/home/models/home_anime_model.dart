class HomeAnimeModel {
  final int id;
  final String title;
  final String coverImage;
  final int? averageScore;
  final int? episodes;
  final List<String> genres;

  const HomeAnimeModel({
    required this.id,
    required this.title,
    required this.coverImage,
    this.averageScore,
    this.episodes,
    required this.genres,
  });

  factory HomeAnimeModel.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as Map<String, dynamic>?;

    return HomeAnimeModel(
      id: json['id'],
      title: title?['english'] ??
          title?['romaji'] ??
          'Unknown',
      coverImage: json['coverImage']['extraLarge'],
      averageScore: json['averageScore'],
      episodes: json['episodes'],
      genres: List<String>.from(json['genres'] ?? []),
    );
  }
}