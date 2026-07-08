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
  final anime = await ref
      .read(discoverRepositoryProvider)
      .getAnimeOfTheDay();

  final settings = ref.watch(settingsNotifierProvider);
  final blocked = settings.blockedGenres;
  if (blocked.isEmpty) return anime;

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  if (anime.genres.any((g) => blockedLower.contains(g.toLowerCase()))) {
    return null;
  }
  return anime;
});

final mangaOfTheDayProvider =
    FutureProvider<DiscoverMangaModel?>((ref) async {
  final manga = await ref
      .read(discoverRepositoryProvider)
      .getMangaOfTheDay();

  final settings = ref.watch(settingsNotifierProvider);
  final blocked = settings.blockedGenres;
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
  final list = await ref
      .read(discoverRepositoryProvider)
      .getAnimeList(mode);

  final settings = ref.watch(settingsNotifierProvider);
  final blocked = settings.blockedGenres;
  if (blocked.isEmpty) return list;

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  return list.where((item) {
    return !item.genres.any((g) => blockedLower.contains(g.toLowerCase()));
  }).toList();
});

final discoverMangaListProvider =
    FutureProvider.family<
        List<DiscoverMangaModel>,
        DiscoverMode>((ref, mode) async {
  final list = await ref
      .read(discoverRepositoryProvider)
      .getMangaList(mode);

  final settings = ref.watch(settingsNotifierProvider);
  final blocked = settings.blockedGenres;
  if (blocked.isEmpty) return list;

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  return list.where((item) {
    return !item.genres.any((g) => blockedLower.contains(g.toLowerCase()));
  }).toList();
});