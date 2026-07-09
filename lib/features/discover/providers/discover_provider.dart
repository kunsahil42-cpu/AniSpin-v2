import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/discover_mode.dart';
import '../models/discover_anime_model.dart';
import '../models/discover_manga_model.dart';
import '../repository/discover_repository.dart';
import '../../settings/providers/settings_provider.dart';

final discoverRepositoryProvider =
    Provider<DiscoverRepository>((ref) {
  return DiscoverRepository();
});

final animeOfTheDayProvider =
    FutureProvider<DiscoverAnimeModel?>((ref) async {
  // Read blocked genres BEFORE any await so the dependency is registered
  // before this provider becomes async — prevents stale filtering.
  final blocked = ref.watch(blockedGenresProvider);
  if (kDebugMode) {
    debugPrint('[Discover] animeOfTheDayProvider — blockedGenres used during filtering: $blocked');
  }

  final anime = await ref
      .read(discoverRepositoryProvider)
      .getAnimeOfTheDay();

  if (blocked.isEmpty) return anime;

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  if (anime.genres.any((g) => blockedLower.contains(g.toLowerCase()))) {
    return null;
  }
  return anime;
});

final mangaOfTheDayProvider =
    FutureProvider<DiscoverMangaModel?>((ref) async {
  // Read blocked genres BEFORE any await so the dependency is registered
  // before this provider becomes async — prevents stale filtering.
  final blocked = ref.watch(blockedGenresProvider);
  if (kDebugMode) {
    debugPrint('[Discover] mangaOfTheDayProvider — blockedGenres used during filtering: $blocked');
  }

  final manga = await ref
      .read(discoverRepositoryProvider)
      .getMangaOfTheDay();

  if (blocked.isEmpty) return manga;

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  if (manga.genres.any((g) => blockedLower.contains(g.toLowerCase()))) {
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
  if (kDebugMode) {
    debugPrint('[Discover] discoverListProvider($mode) — blockedGenres used during filtering: $blocked');
  }

  if (blocked.isEmpty) {
    return repo.getAnimeList(mode);
  }

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  bool isBlocked(DiscoverAnimeModel item) =>
      item.genres.any((g) => blockedLower.contains(g.toLowerCase()));

  const targetCount = 20;
  const maxPages = 4;

  final accumulated = <DiscoverAnimeModel>[];
  for (int page = 1; page <= maxPages; page++) {
    final raw = await repo.getAnimeList(mode, page: page);
    for (final item in raw) {
      if (!isBlocked(item)) accumulated.add(item);
    }
    // Stop early if we have enough or API returned fewer than a full page
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
  if (kDebugMode) {
    debugPrint('[Discover] discoverMangaListProvider($mode) — blockedGenres used during filtering: $blocked');
  }

  if (blocked.isEmpty) {
    return repo.getMangaList(mode);
  }

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  bool isBlocked(DiscoverMangaModel item) =>
      item.genres.any((g) => blockedLower.contains(g.toLowerCase()));

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