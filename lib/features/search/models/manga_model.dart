class MangaModel {
  final int id;
  final String title;
  final String? englishTitle;
  final String imageUrl;
  final int? score;
  final int? chapters;
  final String? status;
  final List<String> genres;

  MangaModel({
    required this.id,
    required this.title,
    required this.englishTitle,
    required this.imageUrl,
    required this.score,
    required this.chapters,
    required this.status,
    required this.genres,
  });

  factory MangaModel.fromJson(Map<String, dynamic> json) {
    return MangaModel(
      id: json['id'],
      title: json['title']['romaji'] ?? '',
      englishTitle: json['title']['english'],
      imageUrl: json['coverImage']['large'] ?? '',
      score: json['averageScore'],
      chapters: json['chapters'],
      status: json['status'],
      genres: List<String>.from(json['genres'] ?? []),
    );
  }
}
