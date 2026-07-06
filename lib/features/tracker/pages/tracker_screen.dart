import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../providers/tracker_providers.dart';
import '../models/watch_progress.dart';
import '../models/reading_progress.dart';

class TrackerScreen extends ConsumerWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueWatchingAsync = ref.watch(continueWatchingProvider);
    final continueReadingAsync = ref.watch(continueReadingProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('📊 Track progress'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.movie_outlined), text: 'Anime History'),
              Tab(icon: Icon(Icons.menu_book_outlined), text: 'Manga History'),
            ],
            indicatorColor: Color(0xFF7C4DFF),
            labelColor: Color(0xFF7C4DFF),
          ),
        ),
        body: TabBarView(
          children: [
            // Anime History Tab
            continueWatchingAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (list) {
                if (list.isEmpty) {
                  return const _EmptyHistory(
                    icon: Icons.movie_creation_outlined,
                    message: 'No anime watch history found.\nStart streaming an episode to track progress!',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _WatchProgressTile(
                      item: item,
                      onTap: () {
                        context.push(
                          '/anime/${item.animeId}/play/${item.lastWatchedEpisode}',
                          extra: {
                            'malId': item.malId,
                            'romajiTitle': item.romajiTitle,
                            'englishTitle': item.englishTitle,
                            'coverImage': item.coverImage,
                            'bannerImage': item.bannerImage,
                            'totalEpisodes': item.totalEpisodes ?? 12,
                          },
                        );
                      },
                      onDelete: () async {
                        final repo = ref.read(watchProgressRepositoryProvider);
                        await repo.saveProgress(item..watchPercentage = 0.0); // Reset or delete
                        ref.invalidate(continueWatchingProvider);
                      },
                    );
                  },
                );
              },
            ),

            // Manga History Tab
            continueReadingAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (list) {
                if (list.isEmpty) {
                  return const _EmptyHistory(
                    icon: Icons.menu_book_outlined,
                    message: 'No manga reading history found.\nOpen a chapter to track reading progress!',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return _ReadingProgressTile(
                      item: item,
                      onTap: () {
                        context.push(
                          '/manga/${item.mangaId}/read/${item.lastReadChapter}',
                          extra: {
                            'romajiTitle': item.romajiTitle,
                            'englishTitle': item.englishTitle,
                            'coverImage': item.coverImage,
                            'bannerImage': item.bannerImage,
                            'totalChapters': item.totalChapters ?? 100,
                          },
                        );
                      },
                      onDelete: () async {
                        final repo = ref.read(readingProgressRepositoryProvider);
                        await repo.saveProgress(item..readingPercentage = 0.0); // Reset
                        ref.invalidate(continueReadingProvider);
                      },
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
}

class _WatchProgressTile extends StatelessWidget {
  final WatchProgress item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _WatchProgressTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.coverImage,
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.romajiTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Episode ${item.lastWatchedEpisode}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: item.watchPercentage,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(item.watchPercentage * 100).toInt()}% completed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadingProgressTile extends StatelessWidget {
  final ReadingProgress item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ReadingProgressTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.coverImage,
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.romajiTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chapter ${item.lastReadChapter} (Page ${item.lastReadPage})',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: item.readingPercentage,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(item.readingPercentage * 100).toInt()}% completed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyHistory({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}