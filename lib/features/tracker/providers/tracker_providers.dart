import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/watch_progress.dart';
import '../models/reading_progress.dart';
import '../repository/watch_progress_repository.dart';
import '../repository/reading_progress_repository.dart';
import '../../settings/providers/settings_provider.dart';

final watchProgressRepositoryProvider = Provider<WatchProgressRepository>((ref) {
  return WatchProgressRepository();
});

final readingProgressRepositoryProvider = Provider<ReadingProgressRepository>((ref) {
  return ReadingProgressRepository();
});

final continueWatchingProvider = StreamProvider<List<WatchProgress>>((ref) {
  final repo = ref.watch(watchProgressRepositoryProvider);
  final settings = ref.watch(settingsNotifierProvider);
  final blocked = settings.blockedGenres;

  return repo.watchContinueWatching().map((list) {
    if (blocked.isEmpty) return list;
    final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
    return list.where((item) {
      return !item.genres.any((g) => blockedLower.contains(g.toLowerCase()));
    }).toList();
  });
});

final continueReadingProvider = StreamProvider<List<ReadingProgress>>((ref) {
  final repo = ref.watch(readingProgressRepositoryProvider);
  final settings = ref.watch(settingsNotifierProvider);
  final blocked = settings.blockedGenres;

  return repo.watchContinueReading().map((list) {
    if (blocked.isEmpty) return list;
    final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
    return list.where((item) {
      return !item.genres.any((g) => blockedLower.contains(g.toLowerCase()));
    }).toList();
  });
});

final animeProgressProvider = FutureProvider.family<WatchProgress?, int>((ref, animeId) async {
  final repo = ref.watch(watchProgressRepositoryProvider);
  return repo.getProgress(animeId);
});

final mangaProgressProvider = FutureProvider.family<ReadingProgress?, int>((ref, mangaId) async {
  final repo = ref.watch(readingProgressRepositoryProvider);
  return repo.getProgress(mangaId);
});
