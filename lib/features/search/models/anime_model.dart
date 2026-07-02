class AnimeModel {
  final int id;
  final String title;
  final String? englishTitle;
  final String imageUrl;
  final int? score;
  final int? episodes;
  final String? status;

  AnimeModel({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.imageUrl,
    required this.score,
    required this.episodes,
    required this.status,
  });

  factory AnimeModel.fromJson(Map<String, dynamic> json) {
    return AnimeModel(
      id: json['id'],
      title: json['title']['romaji'] ?? '',
      englishTitle: json['title']['english'],
      imageUrl: json['coverImage']['large'] ?? '',
      score: json['averageScore'],
      episodes: json['episodes'],
      status: json['status'],
    );
  }
}