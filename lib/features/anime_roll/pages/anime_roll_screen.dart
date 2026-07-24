import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../providers/anime_roll_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/random_anime_card.dart';
import '../widgets/roll_button.dart';

class AnimeRollScreen extends ConsumerWidget {
  const AnimeRollScreen({super.key});

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeState = ref.watch(animeRollProvider);
    final filters = ref.watch(animeRollFiltersProvider);
    final isRolling = animeState.isLoading;

    final hasActiveFilters = !filters.isEmpty;

    // Extract background image URL if state has data
    final coverImage = animeState.whenOrNull(data: (anime) => anime.coverImage);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Blurry Ambient Background cover
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: coverImage != null
                  ? Container(
                      key: ValueKey(coverImage),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(coverImage),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.75),
                        ),
                      ),
                    )
                  : Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
            ),
          ),

          // 2. Content Layout
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top AppBar Action Row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        "🎲 Anime Roll",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.filter_list_rounded),
                            onPressed: () => _showFilters(context),
                          ),
                          if (hasActiveFilters)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Card Presenter Area
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: AsyncNetworkView(
                          value: animeState,
                          onRetry: () => ref.invalidate(animeRollProvider),
                          loading: () => Shimmer.fromColors(
                            baseColor: Colors.grey[900]!,
                            highlightColor: Colors.grey[800]!,
                            child: Container(
                              height: 480,
                              width: 320,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                          data: (anime) {
                            return RandomAnimeCard(
                              anime: anime,
                              onTap: () {
                                context.push('/anime/${anime.id}?title=${Uri.encodeComponent(anime.title)}');
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Filters summary with deletes
                if (hasActiveFilters)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Center(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        alignment: WrapAlignment.center,
                        children: [
                          if (filters.genre != null)
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text("Genre: ${filters.genre}"),
                              onDeleted: () {
                                ref
                                    .read(animeRollFiltersProvider.notifier)
                                    .state = filters.copyWith(clearGenre: true);
                              },
                            ),
                          if (filters.format != null)
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text("Format: ${filters.format}"),
                              onDeleted: () {
                                ref
                                    .read(animeRollFiltersProvider.notifier)
                                    .state = filters.copyWith(
                                  clearFormat: true,
                                );
                              },
                            ),
                          if (filters.minScore != null)
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text("Score: >= ${filters.minScore}%"),
                              onDeleted: () {
                                ref
                                    .read(animeRollFiltersProvider.notifier)
                                    .state = filters.copyWith(
                                  clearMinScore: true,
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 12),

                // Action roll panel
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Center(
                    child: RollButton(
                      isLoading: isRolling,
                      onPressed: () {
                        ref.invalidate(animeRollProvider);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
