import 'package:isar/isar.dart';

part 'watch_progress.g.dart';

@collection
class WatchProgress {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int animeId;

  /// MyAnimeList id — needed to resolve the real stream when resuming playback
  /// straight from Continue Watching / the tracker (where we don't re-fetch the
  /// AniList details). Nullable for rows written before this field existed.
  int? malId;

  late String romajiTitle;
  String? englishTitle;
  late String coverImage;
  String? bannerImage;

  int? totalEpisodes;

  // Last watched episode info
  late int lastWatchedEpisode;
  late int lastWatchedPosition; // in milliseconds
  late int lastWatchedDuration; // in milliseconds
  late double watchPercentage;
  late String lastWatchedSource;
  late String lastWatchedAudio; // sub or dub
  late DateTime lastWatchedAt;

  // Completed episodes list
  List<int> completedEpisodes = [];

  // Tracking fields
  String? status; // Watching, Completed, Plan To Watch, On Hold, Dropped
  int? score; // 0-10
  DateTime? dateStarted;
  DateTime? dateFinished;
  int rewatchCount = 0;
  String? notes;
}
