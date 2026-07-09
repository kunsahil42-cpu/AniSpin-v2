import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/anime_model.dart';
import '../models/manga_model.dart';
import '../repository/search_repository.dart';
import '../../settings/providers/settings_provider.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository();
});

final animeSearchProvider =
    FutureProvider.family<List<AnimeModel>, String>((ref, query) async {
  final repository = ref.read(searchRepositoryProvider);

  if (query.trim().isEmpty) {
    return [];
  }

  final list = await repository.searchAnime(query);
  final blocked = ref.watch(blockedGenresProvider);
  if (kDebugMode) {
    debugPrint('[Search] animeSearchProvider — blockedGenres used during filtering: $blocked');
  }
  if (blocked.isEmpty) return list;

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  return list.where((item) {
    return !item.genres.any((g) => blockedLower.contains(g.toLowerCase()));
  }).toList();
});

final mangaSearchProvider =
    FutureProvider.family<List<MangaModel>, String>((ref, query) async {
  final repository = ref.read(searchRepositoryProvider);

  if (query.trim().isEmpty) {
    return [];
  }

  final list = await repository.searchManga(query);
  final blocked = ref.watch(blockedGenresProvider);
  if (kDebugMode) {
    debugPrint('[Search] mangaSearchProvider — blockedGenres used during filtering: $blocked');
  }
  if (blocked.isEmpty) return list;

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  return list.where((item) {
    return !item.genres.any((g) => blockedLower.contains(g.toLowerCase()));
  }).toList();
});