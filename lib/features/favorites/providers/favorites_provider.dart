import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/favorite_anime.dart';
import '../repository/favorites_repository.dart';

final favoritesRepositoryProvider =
    Provider<FavoritesRepository>(
  (ref) => FavoritesRepository(),
);

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