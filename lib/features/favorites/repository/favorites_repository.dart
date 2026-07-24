import 'package:isar/isar.dart';

import '../../../core/database/isar_service.dart';
import '../models/favorite_anime.dart';
import '../models/favorite_manga.dart';

class FavoritesRepository {
  Isar get _isar => IsarService.instance;

  // =========================
  // Anime Favorites
  // =========================

  Future<void> addFavorite(
    FavoriteAnime anime, {
    dynamic syncService,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.favoriteAnimes.put(anime);
    });
    if (syncService != null) {
      try {
        syncService.syncFavorite(anime.animeId, false);
      } catch (_) {}
    }
  }

  Future<void> removeFavorite(
    int animeId, {
    dynamic syncService,
  }) async {
    final favorite = await _isar.favoriteAnimes
        .filter()
        .animeIdEqualTo(animeId)
        .findFirst();

    if (favorite == null) return;

    await _isar.writeTxn(() async {
      await _isar.favoriteAnimes.delete(
        favorite.id,
      );
    });
    if (syncService != null) {
      try {
        syncService.syncFavorite(animeId, false);
      } catch (_) {}
    }
  }

  Future<bool> isFavorite(
    int animeId,
  ) async {
    final favorite = await _isar.favoriteAnimes
        .filter()
        .animeIdEqualTo(animeId)
        .findFirst();

    return favorite != null;
  }

  Future<List<FavoriteAnime>> getFavorites() async {
    return await _isar.favoriteAnimes
        .where()
        .sortByAddedAtDesc()
        .findAll();
  }

  Future<void> toggleFavorite(
    FavoriteAnime anime, {
    dynamic syncService,
  }) async {
    final exists = await isFavorite(
      anime.animeId,
    );

    if (exists) {
      await removeFavorite(
        anime.animeId,
        syncService: syncService,
      );
    } else {
      await addFavorite(
        anime,
        syncService: syncService,
      );
    }
  }

  Stream<List<FavoriteAnime>> watchFavorites() {
    return _isar.favoriteAnimes
        .where()
        .watch(
          fireImmediately: true,
        );
  }

  // =========================
  // Manga Favorites
  // =========================

  Future<void> addMangaFavorite(
    FavoriteManga manga, {
    dynamic syncService,
  }) async {
    await _isar.writeTxn(() async {
      await _isar.favoriteMangas.put(manga);
    });
    if (syncService != null) {
      try {
        syncService.syncFavorite(manga.mangaId, true);
      } catch (_) {}
    }
  }

  Future<void> removeMangaFavorite(
    int mangaId, {
    dynamic syncService,
  }) async {
    final favorite = await _isar.favoriteMangas
        .filter()
        .mangaIdEqualTo(mangaId)
        .findFirst();

    if (favorite == null) return;

    await _isar.writeTxn(() async {
      await _isar.favoriteMangas.delete(
        favorite.id,
      );
    });
    if (syncService != null) {
      try {
        syncService.syncFavorite(mangaId, true);
      } catch (_) {}
    }
  }

  Future<bool> isMangaFavorite(
    int mangaId,
  ) async {
    final favorite = await _isar.favoriteMangas
        .filter()
        .mangaIdEqualTo(mangaId)
        .findFirst();

    return favorite != null;
  }

  Future<List<FavoriteManga>> getMangaFavorites() async {
    return await _isar.favoriteMangas
        .where()
        .sortByAddedAtDesc()
        .findAll();
  }

  Future<void> toggleMangaFavorite(
    FavoriteManga manga, {
    dynamic syncService,
  }) async {
    final exists = await isMangaFavorite(
      manga.mangaId,
    );

    if (exists) {
      await removeMangaFavorite(
        manga.mangaId,
        syncService: syncService,
      );
    } else {
      await addMangaFavorite(
        manga,
        syncService: syncService,
      );
    }
  }

  Stream<List<FavoriteManga>> watchMangaFavorites() {
    return _isar.favoriteMangas
        .where()
        .watch(
          fireImmediately: true,
        );
  }
}