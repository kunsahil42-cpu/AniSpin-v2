import 'package:isar/isar.dart';

part 'reading_progress.g.dart';

@collection
class ReadingProgress {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int mangaId;

  late String romajiTitle;
  String? englishTitle;
  late String coverImage;
  String? bannerImage;

  int? totalChapters;

  // Last read chapter info
  late int lastReadChapter;
  late int lastReadPage;
  late double readingPercentage;
  late DateTime lastReadAt;

  // Completed chapters list
  List<int> completedChapters = [];

  // Tracking fields
  String? status; // Reading, Completed, Plan To Read, On Hold, Dropped
  int? score; // 0-10
  DateTime? dateStarted;
  DateTime? dateFinished;
  int rereadCount = 0;
  String? notes;
  int lastReadVolume = 0;
  int? totalVolumes;
  List<String> genres = [];
  String? author;
}
