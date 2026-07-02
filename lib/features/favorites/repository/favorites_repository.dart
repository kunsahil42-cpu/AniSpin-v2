import 'package:isar/isar.dart';

import '../../../core/database/isar_service.dart';
import '../models/favorite_anime.dart';

class FavoritesRepository {
  Isar get _isar => IsarService.instance;

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
}