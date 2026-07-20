class DiscoverMediaModel {
  final int id;
  final String title;
  final String imageUrl;
  final int? averageScore;
  final int? episodes;
  final int? chapters;
  final List<String> genres;
  final String status;
  final String description;
  final bool isAdult;

  const DiscoverMediaModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.averageScore,
    this.episodes,
    this.chapters,
    required this.genres,
    required this.status,
    required this.description,
    this.isAdult = false,
  });

  factory DiscoverMediaModel.fromJson(Map<String, dynamic> json) {
    final titleJson = json['title'] as Map<String, dynamic>?;
    final coverJson = json['coverImage'] as Map<String, dynamic>?;

    return DiscoverMediaModel(
      id: json['id'] as int? ?? 0,
      title: titleJson?['romaji'] ?? titleJson?['english'] ?? 'Unknown',
      imageUrl: coverJson?['extraLarge'] ?? coverJson?['large'] ?? '',
      averageScore: json['averageScore'] as int?,
      episodes: json['episodes'] as int?,
      chapters: json['chapters'] as int?,
      genres: (json['genres'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      status: json['status'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      isAdult: json['isAdult'] as bool? ?? false,
    );
  }
}
