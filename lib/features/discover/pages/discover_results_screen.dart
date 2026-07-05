import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../../shared/widgets/states/empty_state.dart';
import '../../../shared/widgets/states/loading_state.dart';
import '../enums/discover_mode.dart';
import '../providers/discover_provider.dart';
import '../widgets/anime_grid_tile.dart';

class DiscoverResultsScreen extends ConsumerWidget {
  final DiscoverMode mode;

  const DiscoverResultsScreen({
    super.key,
    required this.mode,
  });

  String get pageTitle {
    switch (mode) {
      case DiscoverMode.trending:
        return "🔥 Trending";

      case DiscoverMode.hiddenGems:
        return "💎 Hidden Gems";

      case DiscoverMode.airing:
        return "📅 Airing This Season";

      case DiscoverMode.topRated:
        return "⭐ Top Rated";

      case DiscoverMode.surpriseMe:
        return "🎁 Surprise Me";
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeList = ref.watch(
      discoverListProvider(mode),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        centerTitle: true,
      ),
      body: AsyncNetworkView(
        value: animeList,
        loading: () => const LoadingState(
          message: "Loading Anime...",
        ),
        onRetry: () => ref.invalidate(discoverListProvider(mode)),
        data: (anime) {
          if (anime.isEmpty) {
            return const EmptyState(
              title: "No Anime Found",
              subtitle:
                  "Try another Discover category.",
              icon: Icons.movie_creation_outlined,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(
                discoverListProvider(mode),
              );
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.70,
              ),
              itemCount: anime.length,
              itemBuilder: (context, index) {
                final item = anime[index];

                return AnimeGridTile(
                  anime: item,
                  onTap: () {
                    context.push(
                      '/anime/${item.id}',
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}