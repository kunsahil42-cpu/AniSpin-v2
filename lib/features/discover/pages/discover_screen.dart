import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../../shared/widgets/states/loading_state.dart';
import '../enums/discover_mode.dart';
import '../pages/discover_results_screen.dart';
import '../providers/discover_provider.dart';
import '../providers/discover_filters_provider.dart';
import '../models/discover_filters.dart';
import '../models/discover_media_model.dart';
import '../widgets/anime_of_day_card.dart';
import '../widgets/discover_section.dart';
import '../widgets/discover_tile.dart';
import '../widgets/manga_of_day_card.dart';
import '../widgets/discover_filter_bottom_sheet.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final filters = ref.read(discoverFiltersProvider);
    if (filters.isEmpty) return;

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(filteredMediaProvider(filters).notifier).fetchNextPage();
    }
  }

  void _openFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: DiscoverFilterBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(discoverFiltersProvider);

    return PopScope(
      canPop: filters.isEmpty,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ref.read(discoverFiltersProvider.notifier).resetAll();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("✨ Discover"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Badge(
                label: Text(filters.activeCount.toString()),
                isLabelVisible: filters.activeCount > 0,
                child: const Icon(Icons.filter_alt_outlined),
              ),
              onPressed: _openFilterBottomSheet,
            ),
          ],
        ),
        body: filters.isEmpty
            ? _buildDefaultExploreView(filters)
            : _buildFilteredResultsView(filters),
      ),
    );
  }

  Widget _buildDefaultExploreView(DiscoverFilters filters) {
    final anime = ref.watch(animeOfTheDayProvider);
    final manga = ref.watch(mangaOfTheDayProvider);

    return ListView(
      children: [
        AsyncNetworkView(
          value: anime,
          compact: true,
          loading: () => const LoadingState(
            message: "Loading Anime of the Day...",
          ),
          onRetry: () => ref.invalidate(animeOfTheDayProvider),
          data: (animeData) {
            if (animeData == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DiscoverSection(
                  title: "Anime of the Day",
                  icon: Icons.wb_sunny,
                ),
                AnimeOfDayCard(
                  anime: animeData,
                  onTap: () {
                    context.push('/anime/${animeData.id}?title=${Uri.encodeComponent(animeData.title)}');
                  },
                ),
              ],
            );
          },
        ),

        AsyncNetworkView(
          value: manga,
          compact: true,
          loading: () => const LoadingState(
            message: "Loading Manga of the Day...",
          ),
          onRetry: () => ref.invalidate(mangaOfTheDayProvider),
          data: (mangaData) {
            if (mangaData == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DiscoverSection(
                  title: "Manga of the Day",
                  icon: Icons.menu_book,
                ),
                MangaOfDayCard(
                  manga: mangaData,
                  onTap: () {
                    context.push(
                      '/manga/${mangaData.id}',
                    );
                  },
                ),
              ],
            );
          },
        ),

        const DiscoverSection(
          title: "Explore",
          icon: Icons.explore,
        ),

        DiscoverTile(
          icon: Icons.card_giftcard,
          title: "🎁 Surprise Me",
          subtitle: filters.isManga ? "Surprise me with Manga" : "Surprise me with Anime",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiscoverResultsScreen(
                  mode: DiscoverMode.surpriseMe,
                  isManga: filters.isManga,
                ),
              ),
            );
          },
        ),

        DiscoverTile(
          icon: Icons.local_fire_department,
          title: "🔥 Trending Now",
          subtitle: filters.isManga ? "Most popular manga right now" : "Most popular anime right now",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiscoverResultsScreen(
                  mode: DiscoverMode.trending,
                  isManga: filters.isManga,
                ),
              ),
            );
          },
        ),

        DiscoverTile(
          icon: Icons.diamond,
          title: "💎 Hidden Gems",
          subtitle: filters.isManga ? "Underrated manga masterpieces" : "Underrated anime masterpieces",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiscoverResultsScreen(
                  mode: DiscoverMode.hiddenGems,
                  isManga: filters.isManga,
                ),
              ),
            );
          },
        ),

        DiscoverTile(
          icon: Icons.calendar_today,
          title: "📅 Airing This Season",
          subtitle: filters.isManga ? "Currently publishing/ongoing manga" : "Currently releasing anime",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiscoverResultsScreen(
                  mode: DiscoverMode.airing,
                  isManga: filters.isManga,
                ),
              ),
            );
          },
        ),

        DiscoverTile(
          icon: Icons.star,
          title: "⭐ Top Rated",
          subtitle: filters.isManga ? "Highest rated manga" : "Highest rated anime",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiscoverResultsScreen(
                  mode: DiscoverMode.topRated,
                  isManga: filters.isManga,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildFilteredResultsView(DiscoverFilters filters) {
    final state = ref.watch(filteredMediaProvider(filters));
    final notifier = ref.read(discoverFiltersProvider.notifier);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tab Segment at top
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment<bool>(
                value: false,
                label: Text("Anime"),
                icon: Icon(Icons.movie_filter_rounded),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text("Manga"),
                icon: Icon(Icons.book_rounded),
              ),
            ],
            selected: {filters.isManga},
            onSelectionChanged: (Set<bool> selection) {
              notifier.updateIsManga(selection.first);
            },
          ),
        ),

        // Active Chips List
        _buildActiveChipsRow(filters, notifier, theme),

        // Grid Results
        Expanded(
          child: state.items.isEmpty && !state.isLoading
              ? _buildEmptyResultsView(theme)
              : GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: state.items.length + (state.isLoading ? 2 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      return const Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final media = state.items[index];
                    return _buildMediaGridTile(media);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildActiveChipsRow(DiscoverFilters filters, DiscoverFiltersNotifier notifier, ThemeData theme) {
    final chips = <Widget>[];

    for (final genre in filters.genres) {
      chips.add(InputChip(
        label: Text(genre),
        onDeleted: () => notifier.updateGenres(List.from(filters.genres)..remove(genre)),
      ));
    }

    if (filters.season != null) {
      chips.add(InputChip(
        label: Text("Season: ${filters.season}"),
        onDeleted: () => notifier.updateSeason(null),
      ));
    }

    for (final year in filters.years) {
      chips.add(InputChip(
        label: Text(year.toString()),
        onDeleted: () => notifier.updateYears(List.from(filters.years)..remove(year)),
      ));
    }

    for (final type in filters.types) {
      chips.add(InputChip(
        label: Text(type),
        onDeleted: () => notifier.updateTypes(List.from(filters.types)..remove(type)),
      ));
    }

    for (final status in filters.statuses) {
      chips.add(InputChip(
        label: Text(status),
        onDeleted: () => notifier.updateStatuses(List.from(filters.statuses)..remove(status)),
      ));
    }

    for (final lang in filters.languages) {
      chips.add(InputChip(
        label: Text(lang),
        onDeleted: () => notifier.updateLanguages(List.from(filters.languages)..remove(lang)),
      ));
    }

    for (final rating in filters.ratings) {
      chips.add(InputChip(
        label: Text(rating),
        onDeleted: () => notifier.updateRatings(List.from(filters.ratings)..remove(rating)),
      ));
    }

    for (final src in filters.sources) {
      chips.add(InputChip(
        label: Text("Source: $src"),
        onDeleted: () => notifier.updateSources(List.from(filters.sources)..remove(src)),
      ));
    }

    if (filters.minRange != null || filters.maxRange != null) {
      final label = filters.isManga
          ? "Chapters: ${filters.minRange ?? 0} - ${filters.maxRange ?? '∞'}"
          : "Episodes: ${filters.minRange ?? 0} - ${filters.maxRange ?? '∞'}";
      chips.add(InputChip(
        label: Text(label),
        onDeleted: () => notifier.updateRanges(null, null),
      ));
    }

    if (filters.sortBy != "Default" && filters.sortBy.isNotEmpty) {
      chips.add(InputChip(
        label: Text("Sort: ${filters.sortBy}"),
        onDeleted: () => notifier.updateSortBy("Default"),
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        physics: const BouncingScrollPhysics(),
        itemCount: chips.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) => chips[index],
      ),
    );
  }

  Widget _buildEmptyResultsView(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list_off_rounded,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "No results found",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your filters",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGridTile(DiscoverMediaModel media) {
    return InkWell(
      onTap: () {
        if (media.episodes != null) {
          context.push('/anime/${media.id}?title=${Uri.encodeComponent(media.title)}');
        } else {
          context.push('/manga/${media.id}?title=${Uri.encodeComponent(media.title)}');
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: media.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade900,
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: Colors.white24,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    media.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        "${media.averageScore ?? "-"}",
                      ),
                      const Spacer(),
                      Text(
                        media.episodes != null
                            ? "${media.episodes} Ep"
                            : media.chapters != null
                                ? "${media.chapters} Ch"
                                : "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}