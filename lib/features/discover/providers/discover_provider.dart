import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/discover_mode.dart';
import '../models/discover_anime_model.dart';
import '../models/discover_manga_model.dart';
import '../repository/discover_repository.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../core/utils/genre_filter.dart';

final discoverRepositoryProvider =
    Provider<DiscoverRepository>((ref) {
  return DiscoverRepository();
});

final animeOfTheDayProvider =
    FutureProvider<DiscoverAnimeModel?>((ref) async {
  final blocked = ref.watch(blockedGenresProvider);
  final anime = await ref
      .read(discoverRepositoryProvider)
      .getAnimeOfTheDay();

  if (blocked.isEmpty) return anime;

  if (isMediaBlocked(genres: anime.genres, isAdult: anime.isAdult, blockedGenres: blocked)) {
    return null;
  }
  return anime;
});

final mangaOfTheDayProvider =
    FutureProvider<DiscoverMangaModel?>((ref) async {
  final blocked = ref.watch(blockedGenresProvider);
  final manga = await ref
      .read(discoverRepositoryProvider)
      .getMangaOfTheDay();

  if (blocked.isEmpty) return manga;

  if (isMediaBlocked(genres: manga.genres, isAdult: manga.isAdult, blockedGenres: blocked)) {
    return null;
  }
  return manga;
});

final discoverListProvider =
    FutureProvider.family<
        List<DiscoverAnimeModel>,
        DiscoverMode>((ref, mode) async {
  final repo = ref.read(discoverRepositoryProvider);
  final blocked = ref.watch(blockedGenresProvider);

  if (blocked.isEmpty) {
    return repo.getAnimeList(mode);
  }

  bool isBlocked(DiscoverAnimeModel item) =>
      isMediaBlocked(genres: item.genres, isAdult: item.isAdult, blockedGenres: blocked);

  const targetCount = 20;
  const maxPages = 4;

  final accumulated = <DiscoverAnimeModel>[];
  for (int page = 1; page <= maxPages; page++) {
    final raw = await repo.getAnimeList(mode, page: page);
    for (final item in raw) {
      if (!isBlocked(item)) accumulated.add(item);
    }
    if (accumulated.length >= targetCount || raw.length < 20) break;
  }
  return accumulated;
});

final discoverMangaListProvider =
    FutureProvider.family<
        List<DiscoverMangaModel>,
        DiscoverMode>((ref, mode) async {
  final repo = ref.read(discoverRepositoryProvider);
  final blocked = ref.watch(blockedGenresProvider);

  if (blocked.isEmpty) {
    return repo.getMangaList(mode);
  }

  bool isBlocked(DiscoverMangaModel item) =>
      isMediaBlocked(genres: item.genres, isAdult: item.isAdult, blockedGenres: blocked);

  const targetCount = 20;
  const maxPages = 4;

  final accumulated = <DiscoverMangaModel>[];
  for (int page = 1; page <= maxPages; page++) {
    final raw = await repo.getMangaList(mode, page: page);
    for (final item in raw) {
      if (!isBlocked(item)) accumulated.add(item);
    }
    if (accumulated.length >= targetCount || raw.length < 20) break;
  }
  return accumulated;
});