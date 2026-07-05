import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_provider.dart';
import '../widgets/favorite_card.dart';
import '../widgets/manga_favorite_card.dart';
import '../../../shared/widgets/states/error_state.dart';
import '../../../shared/widgets/states/loading_state.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  // ---------------------------------------------------------------------------
  // Optimistic-deletion state (the Gmail pattern).
  //
  // When an item is swiped we DO NOT delete it from Isar. We only add its id
  // here so it is hidden from the list, then show a 5-second undo bar. The
  // permanent Isar delete happens ONLY if that bar closes for a reason other
  // than the user tapping UNDO. This makes the delete fully reversible and
  // keeps the database and the UI in lockstep (never delete-then-restore).
  // ---------------------------------------------------------------------------
  final Set<int> _pendingAnime = <int>{};
  final Set<int> _pendingManga = <int>{};

  // We manage the 5-second countdown ourselves with a real dart:async Timer
  // instead of relying on SnackBar.duration. The framework only arms its own
  // auto-dismiss timer inside ScaffoldMessengerState.build() when the entrance
  // animation has fully settled -- which is unreliable here because the screen
  // is always mounted in an IndexedStack and rebuilds on every Isar emission.
  // Owning the timer guarantees the bar is dismissed after exactly 5 seconds.
  Timer? _undoTimer;
  Completer<bool>? _activeUndo; // completes: true = UNDO tapped, false = commit

  @override
  void dispose() {
    _undoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animeFavorites = ref.watch(favoritesProvider);
    final mangaFavorites = ref.watch(mangaFavoritesProvider);

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
            // ===========================
            // Anime Tab
            // ===========================
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
              data: (list) {
                // Hide anything currently in its undo window.
                final animeList = list
                    .where((a) => !_pendingAnime.contains(a.animeId))
                    .toList();

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
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: animeList.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final anime = animeList[index];

                    return Dismissible(
                      movementDuration:
                          const Duration(milliseconds: 300),
                      resizeDuration:
                          const Duration(milliseconds: 250),
                      crossAxisEndOffset: 0,
                      key: ValueKey("anime_${anime.animeId}"),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _runUndoableRemoval(
                        pending: _pendingAnime,
                        id: anime.animeId,
                        controller:
                            ref.read(favoritesControllerProvider),
                        commit: (c) => c.removeFavorite(anime.animeId),
                      ),
                      background: _deleteBackground(),
                      child: FavoriteCard(
                        anime: anime,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 350.ms)
                        .slideY(
                          begin: .15,
                          end: 0,
                          duration: 350.ms,
                        );
                  },
                );
              },
            ),

            // ===========================
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
              data: (list) {
                final mangaList = list
                    .where((m) => !_pendingManga.contains(m.mangaId))
                    .toList();

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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
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
                      key: ValueKey("manga_${manga.mangaId}"),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _runUndoableRemoval(
                        pending: _pendingManga,
                        id: manga.mangaId,
                        controller:
                            ref.read(mangaFavoritesControllerProvider),
                        commit: (c) =>
                            c.removeMangaFavorite(manga.mangaId),
                      ),
                      background: _deleteBackground(),
                      child: MangaFavoriteCard(
                        manga: manga,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 350.ms)
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

  // ---------------------------------------------------------------------------
  // Core undo flow — identical for anime and manga.
  // ---------------------------------------------------------------------------

  /// Runs the optimistic swipe-to-delete + undo lifecycle for a single item.
  ///
  /// 1. Hide the item from the list (add its id to [pending]).
  /// 2. Show the undo SnackBar and start OUR OWN 5-second timer.
  /// 3. If the user taps UNDO before the timer fires → un-hide it. The item was
  ///    never deleted from Isar, so it simply reappears.
  /// 4. When our timer fires (or a newer swipe supersedes this one) → hide the
  ///    bar ourselves and commit the permanent Isar delete.
  ///
  /// [controller] is read from Riverpod BEFORE the first await, so the commit
  /// stays valid even if this widget is disposed while the bar is open.
  Future<void> _runUndoableRemoval({
    required Set<int> pending,
    required int id,
    required FavoritesController controller,
    required Future<void> Function(FavoritesController c) commit,
  }) async {
    final messenger = ScaffoldMessenger.of(context);

    // A newer swipe supersedes any bar still open: commit that older delete now
    // and take its bar off screen, so only the most recent item is undoable.
    _undoTimer?.cancel();
    final previous = _activeUndo;
    if (previous != null && !previous.isCompleted) {
      previous.complete(false);
    }
    messenger.hideCurrentSnackBar();

    // Step 1: hide immediately. setState is synchronous here (before the first
    // await), so the ListView drops the dismissed item on the next frame — no
    // "dismissed Dismissible still in tree" error.
    setState(() => pending.add(id));

    // Step 2: this completer is the single source of truth for the outcome.
    final completer = Completer<bool>();
    _activeUndo = completer;
    _undoTimer = Timer(const Duration(seconds: 5), () {
      if (!completer.isCompleted) completer.complete(false);
    });

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        // Long fallback only. OUR _undoTimer above is what actually dismisses
        // the bar at 5s, so we never depend on the framework's flaky timer.
        duration: const Duration(minutes: 1),
        content: const Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text("Removed from Favorites"),
            ),
          ],
        ),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            if (!completer.isCompleted) completer.complete(true);
          },
        ),
      ),
    );

    final undo = await completer.future;

    // Only the still-active removal owns the timer and the visible bar.
    if (identical(_activeUndo, completer)) {
      _undoTimer?.cancel();
      _undoTimer = null;
      _activeUndo = null;
      // Timeout path: pull the bar off screen ourselves. (On UNDO the
      // SnackBarAction already dismissed it, so this is a harmless no-op.)
      messenger.hideCurrentSnackBar();
    }

    // Step 3/4: commit the permanent delete unless the user chose UNDO.
    if (!undo) {
      await commit(controller);
    }
    pending.remove(id);
    if (mounted) setState(() {});
  }

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.red.shade400,
            Colors.red.shade700,
          ],
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
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
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
          mainAxisAlignment: MainAxisAlignment.center,
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
                    fontWeight: FontWeight.bold,
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
        .fadeIn(duration: 400.ms)
        .scale(
          begin: const Offset(.95, .95),
        );
  }
}
