import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/anime_model.dart';
import '../models/manga_model.dart';
import '../repository/search_repository.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../core/utils/genre_filter.dart';

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepository();
});

/// Sanitizes search input by trimming, stripping control characters, and limiting length.
String sanitizeSearchQuery(String input) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return '';
  // Strip control characters (ASCII 0-31 and 127) and restrict maximum length to 100
  final clean = trimmed.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
  return clean.length > 100 ? clean.substring(0, 100) : clean;
}

final animeSearchProvider =
    FutureProvider.family<List<AnimeModel>, String>((ref, query) async {
  final repository = ref.read(searchRepositoryProvider);
  final sanitizedQuery = sanitizeSearchQuery(query);

  if (sanitizedQuery.isEmpty) {
    return [];
  }

  final list = await repository.searchAnime(sanitizedQuery);
  final blocked = ref.watch(blockedGenresProvider);
  if (blocked.isEmpty) return list;

  return list.where((item) {
    return !isMediaBlocked(genres: item.genres, isAdult: item.isAdult, blockedGenres: blocked);
  }).toList();
});

final mangaSearchProvider =
    FutureProvider.family<List<MangaModel>, String>((ref, query) async {
  final repository = ref.read(searchRepositoryProvider);
  final sanitizedQuery = sanitizeSearchQuery(query);

  if (sanitizedQuery.isEmpty) {
    return [];
  }

  final list = await repository.searchManga(sanitizedQuery);
  final blocked = ref.watch(blockedGenresProvider);
  if (blocked.isEmpty) return list;

  return list.where((item) {
    return !isMediaBlocked(genres: item.genres, isAdult: item.isAdult, blockedGenres: blocked);
  }).toList();
});