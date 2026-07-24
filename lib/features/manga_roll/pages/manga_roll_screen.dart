import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../anime_roll/widgets/roll_button.dart';
import '../providers/manga_roll_provider.dart';
import '../widgets/manga_filter_bottom_sheet.dart';
import '../widgets/random_manga_card.dart';

class MangaRollScreen extends ConsumerWidget {
  const MangaRollScreen({super.key});

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const MangaFilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaState = ref.watch(mangaRollProvider);
    final filters = ref.watch(mangaRollFiltersProvider);
    final isRolling = mangaState.isLoading;

    final hasActiveFilters = !filters.isEmpty;

    // Extract background cover image if data loaded
    final coverImage = mangaState.whenOrNull(data: (manga) => manga.coverImage);

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
                        "🎲 Manga Roll",
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
                          value: mangaState,
                          onRetry: () => ref.invalidate(mangaRollProvider),
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
                          data: (manga) {
                            return RandomMangaCard(
                              manga: manga,
                              onTap: () {
                                context.push('/manga/${manga.id}?title=${Uri.encodeComponent(manga.title)}');
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // Active Filters Panel
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
                                    .read(mangaRollFiltersProvider.notifier)
                                    .state = filters.copyWith(clearGenre: true);
                              },
                            ),
                          if (filters.format != null)
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text("Format: ${filters.format}"),
                              onDeleted: () {
                                ref
                                    .read(mangaRollFiltersProvider.notifier)
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
                                    .read(mangaRollFiltersProvider.notifier)
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

                // Bottom Roll Action panel
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Center(
                    child: RollButton(
                      isLoading: isRolling,
                      color: Colors.teal,
                      onPressed: () {
                        ref.invalidate(mangaRollProvider);
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
