class MangaHomeModel {
  final int id;
  final String title;
  final String coverImage;
  final int? averageScore;
  final List<String> genres;
  final int? chapters;
  final bool isAdult;

  MangaHomeModel({
    required this.id,
    required this.title,
    required this.coverImage,
    this.averageScore,
    required this.genres,
    this.chapters,
    this.isAdult = false,
  });

  factory MangaHomeModel.fromJson(Map<String, dynamic> json) {
    return MangaHomeModel(
      id: json['id'],
      title: json['title']['romaji'] ?? json['title']['english'] ?? '',
      coverImage: json['coverImage']['extraLarge'] ?? json['coverImage']['large'] ?? '',
      averageScore: json['averageScore'],
      genres: List<String>.from(json['genres'] ?? []),
      chapters: json['chapters'],
      isAdult: json['isAdult'] as bool? ?? false,
    );
  }
}
