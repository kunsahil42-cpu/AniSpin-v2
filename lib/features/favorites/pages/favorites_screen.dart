import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_provider.dart';
import '../widgets/favorite_card.dart';
import '../widgets/manga_favorite_card.dart';
import '../../../shared/widgets/states/error_state.dart';
import '../../../shared/widgets/states/loading_state.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeFavorites = ref.watch(
      favoritesProvider,
    );

    final mangaFavorites = ref.watch(
      mangaFavoritesProvider,
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("❤️ Favorites"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.movie),
                text: "Anime",
              ),
              Tab(
                icon: Icon(Icons.menu_book),
                text: "Manga",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            animeFavorites.when(
              loading: () => const LoadingState(
                message: "Loading Favorite Anime...",
              ),
              error: (error, _) => ErrorState(
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(favoritesProvider);
                  },
              ),
              data: (animeList) {
                if (animeList.isEmpty) {
                  return _buildEmptyState(
                    context,
                    icon: Icons.favorite_border_rounded,
                    title: "No Favorite Anime Yet",
                    subtitle:
                        "Tap ❤️ on any anime to save it here.",
                  );
                }

                return ListView.separated(
                  physics:
                      const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    100,
                  ),
                  itemCount: animeList.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 16),
                  itemBuilder:
                      (context, index) {
                    final anime =
                        animeList[index];

                    return Dismissible(
                      movementDuration:
                          const Duration(
                        milliseconds: 300,
                      ),
                      resizeDuration:
                          const Duration(
                        milliseconds: 250,
                      ),
                      crossAxisEndOffset: 0,
                      key: ValueKey(
                        anime.animeId,
                      ),
                      direction:
                          DismissDirection
                              .endToStart,
                      confirmDismiss:
                          (_) async {
                        await ref
                            .read(
                              favoritesControllerProvider,
                            )
                            .removeFavorite(
                              anime.animeId,
                            );

                        if (context
                            .mounted) {
                          ScaffoldMessenger.of(
                            context,
                          )
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                behavior:
                                    SnackBarBehavior
                                        .floating,
                                margin:
                                    const EdgeInsets
                                        .all(
                                  16,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    14,
                                  ),
                                ),
                                duration:
                                    const Duration(
                                  seconds: 5,
                                ),
                                content:
                                    const Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .check_circle_rounded,
                                      color: Colors
                                          .white,
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Expanded(
                                      child:
                                          Text(
                                        "Removed from Favorites",
                                      ),
                                    ),
                                  ],
                                ),
                                action:
                                    SnackBarAction(
                                  label:
                                      "UNDO",
                                  onPressed:
                                      () async {
                                    await ref
                                        .read(
                                          favoritesControllerProvider,
                                        )
                                        .addFavorite(
                                          anime,
                                        );
                                  },
                                ),
                              ),
                            );
                        }

                        return true;
                      },
                      background:
                          Container(
                        alignment:
                            Alignment
                                .centerRight,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              24,
                        ),
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                          gradient:
                              LinearGradient(
                            colors: [
                              Colors.red
                                  .shade400,
                              Colors.red
                                  .shade700,
                            ],
                          ),
                        ),
                        child:
                            const Row(
                          mainAxisSize:
                              MainAxisSize
                                  .min,
                          children: [
                            Icon(
                              Icons
                                  .delete_rounded,
                              color: Colors
                                  .white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Delete",
                              style:
                                  TextStyle(
                                color: Colors
                                    .white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      child:
                          FavoriteCard(
                        anime: anime,
                      ),
                    )
                        .animate()
                        .fadeIn(
                          duration:
                              350.ms,
                        )
                        .slideY(
                          begin: .15,
                          end: 0,
                          duration:
                              350.ms,
                        );
                  },
                );
              },
            ),            // ===========================
            // Manga Tab
            // ===========================

            mangaFavorites.when(
              loading: () => const LoadingState(
                message: "Loading Favorite Manga...",
              ),
              error: (error, _) => ErrorState(
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(mangaFavoritesProvider);
                },
              ),
              data: (mangaList) {
                if (mangaList.isEmpty) {
                  return _buildEmptyState(
                    context,
                    icon: Icons.menu_book_rounded,
                    title: "No Favorite Manga Yet",
                    subtitle:
                        "Tap ❤️ on any manga to save it here.",
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    16,
                    16,
                    100,
                  ),
                  itemCount: mangaList.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final manga = mangaList[index];

                    return Dismissible(
                      movementDuration:
                          const Duration(milliseconds: 300),
                      resizeDuration:
                          const Duration(milliseconds: 250),
                      crossAxisEndOffset: 0,
                      key: ValueKey(
                        "manga_${manga.mangaId}",
                      ),
                      direction:
                          DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        await ref
                            .read(
                              mangaFavoritesControllerProvider,
                            )
                            .removeFavorite(
                              manga.mangaId,
                            );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                behavior:
                                    SnackBarBehavior.floating,
                                margin:
                                    const EdgeInsets.all(
                                  16,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    14,
                                  ),
                                ),
                                duration:
                                    const Duration(
                                  seconds: 5,
                                ),
                                content: const Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .check_circle_rounded,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Removed from Favorites",
                                      ),
                                    ),
                                  ],
                                ),
                                action: SnackBarAction(
                                  label: "UNDO",
                                  onPressed: () async {
                                    await ref
                                        .read(
                                          mangaFavoritesControllerProvider,
                                        )
                                        .addMangaFavorite(
                                          manga,
                                        );
                                  },
                                ),
                              ),
                            );
                        }

                        return true;
                      },
                      background: Container(
                        alignment:
                            Alignment.centerRight,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.shade400,
                              Colors.red.shade700,
                            ],
                          ),
                        ),
                        child: const Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.delete_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: MangaFavoriteCard(
                        manga: manga,
                      ),
                    )
                        .animate()
                        .fadeIn(
                          duration: 350.ms,
                        )
                        .slideY(
                          begin: .15,
                          end: 0,
                          duration: 350.ms,
                          curve: Curves.easeOut,
                        );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 90,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 20),
            Text(
              title,
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
              subtitle,
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
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
        )
        .scale(
          begin: const Offset(
            .95,
            .95,
          ),
        );
  }
}