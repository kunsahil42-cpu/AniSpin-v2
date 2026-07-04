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
    FavoriteAnime anime,
  ) async {
    await _isar.writeTxn(() async {
      await _isar.favoriteAnimes.put(anime);
    });
  }

  Future<void> removeFavorite(
    int animeId,
  ) async {
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
    FavoriteAnime anime,
  ) async {
    final exists = await isFavorite(
      anime.animeId,
    );

    if (exists) {
      await removeFavorite(
        anime.animeId,
      );
    } else {
      await addFavorite(
        anime,
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
    FavoriteManga manga,
  ) async {
    await _isar.writeTxn(() async {
      await _isar.favoriteMangas.put(manga);
    });
  }

  Future<void> removeMangaFavorite(
    int mangaId,
  ) async {
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
    FavoriteManga manga,
  ) async {
    final exists = await isMangaFavorite(
      manga.mangaId,
    );

    if (exists) {
      await removeMangaFavorite(
        manga.mangaId,
      );
    } else {
      await addMangaFavorite(
        manga,
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