import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../../tracker/models/watch_progress.dart';

class ContinueWatchingList extends ConsumerWidget {
  const ContinueWatchingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueWatchingAsync = ref.watch(continueWatchingProvider);

    return continueWatchingAsync.when(
      loading: () => const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = list[index];
              return _ContinueWatchingCard(
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
                      'totalEpisodes': (item.totalEpisodes != null && item.totalEpisodes! > 0) ? item.totalEpisodes! : 12,
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ContinueWatchingCard extends StatelessWidget {
  final WatchProgress item;
  final VoidCallback onTap;

  const _ContinueWatchingCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.coverImage,
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.romajiTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Episode ${item.lastWatchedEpisode}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: (item.watchPercentage.isNaN || item.watchPercentage.isInfinite) ? 0.0 : item.watchPercentage,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${((item.watchPercentage.isNaN || item.watchPercentage.isInfinite) ? 0.0 : item.watchPercentage * 100).toInt()}% completed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
