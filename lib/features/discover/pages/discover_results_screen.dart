import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../../shared/widgets/states/empty_state.dart';
import '../../../shared/widgets/states/loading_state.dart';
import '../enums/discover_mode.dart';
import '../providers/discover_provider.dart';
import '../widgets/anime_grid_tile.dart';
import '../widgets/manga_grid_tile.dart';

class DiscoverResultsScreen extends ConsumerStatefulWidget {
  final DiscoverMode mode;
  final bool isManga;

  const DiscoverResultsScreen({
    super.key,
    required this.mode,
    required this.isManga,
  });

  @override
  ConsumerState<DiscoverResultsScreen> createState() => _DiscoverResultsScreenState();
}

class _DiscoverResultsScreenState extends ConsumerState<DiscoverResultsScreen> {
  late bool _isManga;

  @override
  void initState() {
    super.initState();
    _isManga = widget.isManga;
  }

  String get pageTitle {
    if (_isManga) {
      switch (widget.mode) {
        case DiscoverMode.trending:
          return "🔥 Trending Manga";
        case DiscoverMode.hiddenGems:
          return "💎 Underrated Manga";
        case DiscoverMode.airing:
          return "📅 Currently Publishing/Ongoing Manga";
        case DiscoverMode.topRated:
          return "⭐ Highest Rated Manga";
        case DiscoverMode.surpriseMe:
          return "🎁 Surprise Me Manga";
      }
    } else {
      switch (widget.mode) {
        case DiscoverMode.trending:
          return "🔥 Trending Anime";
        case DiscoverMode.hiddenGems:
          return "💎 Underrated Anime";
        case DiscoverMode.airing:
          return "📅 Currently Airing Anime";
        case DiscoverMode.topRated:
          return "⭐ Highest Rated Anime";
        case DiscoverMode.surpriseMe:
          return "🎁 Surprise Me Anime";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Same segmented control style as filter bottom sheet
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text("Anime"),
                    icon: Icon(Icons.movie_filter_rounded),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text("Manga"),
                    icon: Icon(Icons.menu_book_rounded),
                  ),
                ],
                selected: {_isManga},
                onSelectionChanged: (Set<bool> selection) {
                  setState(() {
                    _isManga = selection.first;
                  });
                },
              ),
            ),
          ),
          
          Expanded(
            child: _isManga ? _buildMangaBody() : _buildAnimeBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildMangaBody() {
    final mangaList = ref.watch(discoverMangaListProvider(widget.mode));
    return AsyncNetworkView(
      value: mangaList,
      loading: () => const LoadingState(
        message: "Loading Manga...",
      ),
      onRetry: () => ref.invalidate(discoverMangaListProvider(widget.mode)),
      data: (manga) {
        if (manga.isEmpty) {
          return const EmptyState(
            title: "No Manga Found",
            subtitle: "Try another Discover category.",
            icon: Icons.menu_book_outlined,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(discoverMangaListProvider(widget.mode));
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.70,
            ),
            itemCount: manga.length,
            itemBuilder: (context, index) {
              final item = manga[index];
              return MangaGridTile(
                manga: item,
                onTap: () {
                  context.push('/manga/${item.id}?title=${Uri.encodeComponent(item.title)}');
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAnimeBody() {
    final animeList = ref.watch(discoverListProvider(widget.mode));
    return AsyncNetworkView(
      value: animeList,
      loading: () => const LoadingState(
        message: "Loading Anime...",
      ),
      onRetry: () => ref.invalidate(discoverListProvider(widget.mode)),
      data: (anime) {
        if (anime.isEmpty) {
          return const EmptyState(
            title: "No Anime Found",
            subtitle: "Try another Discover category.",
            icon: Icons.movie_creation_outlined,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(discoverListProvider(widget.mode));
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  context.push('/anime/${item.id}?title=${Uri.encodeComponent(item.title)}');
                },
              );
            },
          ),
        );
      },
    );
  }
}