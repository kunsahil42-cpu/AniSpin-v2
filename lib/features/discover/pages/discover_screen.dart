import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../../shared/widgets/states/loading_state.dart';
import '../enums/discover_mode.dart';
import '../pages/discover_results_screen.dart';
import '../providers/discover_provider.dart';
import '../widgets/anime_of_day_card.dart';
import '../widgets/discover_section.dart';
import '../widgets/discover_tile.dart';
import '../widgets/manga_of_day_card.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anime = ref.watch(animeOfTheDayProvider);
    final manga = ref.watch(mangaOfTheDayProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("✨ Discover"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const DiscoverSection(
            title: "Anime of the Day",
            icon: Icons.wb_sunny,
          ),

          AsyncNetworkView(
            value: anime,
            compact: true,
            loading: () => const LoadingState(
              message: "Loading Anime of the Day...",
            ),
            onRetry: () => ref.invalidate(animeOfTheDayProvider),
            data: (animeData) => AnimeOfDayCard(
              anime: animeData,
              onTap: () {
                context.push('/anime/${animeData.id}');
              },
            ),
          ),

          const DiscoverSection(
            title: "Manga of the Day",
            icon: Icons.menu_book,
          ),

          AsyncNetworkView(
            value: manga,
            compact: true,
            loading: () => const LoadingState(
              message: "Loading Manga of the Day...",
            ),
            onRetry: () => ref.invalidate(mangaOfTheDayProvider),
            data: (mangaData) => MangaOfDayCard(
              manga: mangaData,
              onTap: () {
                context.push(
                  '/manga/${mangaData.id}',
                );
              },
            ),
          ),

          const DiscoverSection(
            title: "Explore",
            icon: Icons.explore,
          ),

          DiscoverTile(
            icon: Icons.card_giftcard,
            title: "🎁 Surprise Me",
            subtitle: "Anime • Manga • Both",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DiscoverResultsScreen(
                    mode: DiscoverMode.surpriseMe,
                  ),
                ),
              );
            },
          ),

          DiscoverTile(
            icon: Icons.local_fire_department,
            title: "🔥 Trending Now",
            subtitle: "Most popular right now",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DiscoverResultsScreen(
                    mode: DiscoverMode.trending,
                  ),
                ),
              );
            },
          ),

          DiscoverTile(
            icon: Icons.diamond,
            title: "💎 Hidden Gems",
            subtitle: "Underrated masterpieces",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DiscoverResultsScreen(
                    mode: DiscoverMode.hiddenGems,
                  ),
                ),
              );
            },
          ),

          DiscoverTile(
            icon: Icons.calendar_today,
            title: "📅 Airing This Season",
            subtitle: "Currently releasing anime",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DiscoverResultsScreen(
                    mode: DiscoverMode.airing,
                  ),
                ),
              );
            },
          ),

          DiscoverTile(
            icon: Icons.star,
            title: "⭐ Top Rated",
            subtitle: "Highest rated anime",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DiscoverResultsScreen(
                    mode: DiscoverMode.topRated,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}