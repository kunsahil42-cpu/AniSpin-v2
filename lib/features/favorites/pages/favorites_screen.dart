import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_provider.dart';
import '../widgets/favorite_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("❤️ Favorites"),
        centerTitle: true,
      ),
      body: favorites.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        data: (animeList) {
          if (animeList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 90,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No Favorites Yet",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight:
                                FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Tap the ❤️ button on any anime to save it here.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: animeList.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 14),
            itemBuilder: (context, index) {
              return FavoriteCard(
                anime: animeList[index],
              );
            },
          );
        },
      ),
    );
  }
}