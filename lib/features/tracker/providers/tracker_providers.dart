import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/watch_progress.dart';
import '../models/reading_progress.dart';
import '../repository/watch_progress_repository.dart';
import '../repository/reading_progress_repository.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../core/utils/genre_filter.dart';

final watchProgressRepositoryProvider = Provider<WatchProgressRepository>((ref) {
  return WatchProgressRepository(ref);
});

final readingProgressRepositoryProvider = Provider<ReadingProgressRepository>((ref) {
  return ReadingProgressRepository(ref);
});

final continueWatchingProvider = StreamProvider<List<WatchProgress>>((ref) {
  final repo = ref.watch(watchProgressRepositoryProvider);
  final blocked = ref.watch(blockedGenresProvider);

  return repo.watchContinueWatching().map((list) {
    if (blocked.isEmpty) return list;
    return list.where((item) {
      return !isMediaBlocked(genres: item.genres, isAdult: false, blockedGenres: blocked);
    }).toList();
  });
});

final continueReadingProvider = StreamProvider<List<ReadingProgress>>((ref) {
  final repo = ref.watch(readingProgressRepositoryProvider);
  final blocked = ref.watch(blockedGenresProvider);

  return repo.watchContinueReading().map((list) {
    if (blocked.isEmpty) return list;
    return list.where((item) {
      return !isMediaBlocked(genres: item.genres, isAdult: false, blockedGenres: blocked);
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
