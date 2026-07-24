import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/favorite_anime.dart';
import '../models/favorite_manga.dart';
import '../repository/favorites_repository.dart';
import '../../../core/sync/sync_service.dart';

final favoritesRepositoryProvider =
    Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(),
);

/// =========================
/// Anime Favorites
/// =========================

final favoritesProvider =
    StreamProvider<List<FavoriteAnime>>(
  (ref) {
    return ref
        .read(favoritesRepositoryProvider)
        .watchFavorites();
  },
);

final isFavoriteProvider =
    FutureProvider.family<bool, int>(
  (ref, animeId) async {
    return ref
        .read(favoritesRepositoryProvider)
        .isFavorite(animeId);
  },
);

/// =========================
/// Manga Favorites
/// =========================

final mangaFavoritesProvider =
    StreamProvider<List<FavoriteManga>>(
  (ref) {
    return ref
        .read(favoritesRepositoryProvider)
        .watchMangaFavorites();
  },
);

final isMangaFavoriteProvider =
    FutureProvider.family<bool, int>(
  (ref, mangaId) async {
    return ref
        .read(favoritesRepositoryProvider)
        .isMangaFavorite(mangaId);
  },
);

/// =========================
/// Favorites Controller
/// =========================

final favoritesControllerProvider =
    Provider<FavoritesController>(
  (ref) {
    return FavoritesController(
      ref.read(favoritesRepositoryProvider),
      ref,
    );
  },
);

final mangaFavoritesControllerProvider =
    Provider<FavoritesController>(
  (ref) {
    return FavoritesController(
      ref.read(favoritesRepositoryProvider),
      ref,
    );
  },
);

class FavoritesController {
  FavoritesController(this._repository, this._ref);

  final FavoritesRepository _repository;
  final Ref _ref;

  // =========================
  // Anime
  // =========================

  Future<void> addFavorite(
    FavoriteAnime anime,
  ) async {
    await _repository.addFavorite(anime, syncService: _ref.read(syncServiceProvider));
  }

  Future<void> removeFavorite(
    int animeId,
  ) async {
    await _repository.removeFavorite(animeId, syncService: _ref.read(syncServiceProvider));
  }

  Future<void> toggleFavorite(
    FavoriteAnime anime,
  ) async {
    await _repository.toggleFavorite(anime, syncService: _ref.read(syncServiceProvider));
  }

  Future<bool> isFavorite(
    int animeId,
  ) async {
    return _repository.isFavorite(animeId);
  }

  // =========================
  // Manga
  // =========================

  Future<void> addMangaFavorite(
    FavoriteManga manga,
  ) async {
    await _repository.addMangaFavorite(manga, syncService: _ref.read(syncServiceProvider));
  }

  Future<void> removeMangaFavorite(
    int mangaId,
  ) async {
    await _repository.removeMangaFavorite(mangaId, syncService: _ref.read(syncServiceProvider));
  }

  Future<void> toggleMangaFavorite(
    FavoriteManga manga,
  ) async {
    await _repository.toggleMangaFavorite(manga, syncService: _ref.read(syncServiceProvider));
  }

  Future<bool> isMangaFavorite(
    int mangaId,
  ) async {
    return _repository.isMangaFavorite(mangaId);
  }
}