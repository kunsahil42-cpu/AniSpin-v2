import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../shared/widgets/async_network_view.dart';
import '../../../shared/widgets/skeletons/skeleton_card.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../providers/manga_home_provider.dart';
import '../repository/manga_home_repository.dart';
import '../models/manga_home_model.dart';
import 'package:isar/isar.dart';
import '../../../core/database/isar_service.dart';
import '../../manga_reader/models/chapter_reading_state.dart';

class MangaHomeScreen extends ConsumerWidget {
  final bool embed;

  const MangaHomeScreen({super.key, this.embed = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final continueReading = ref.watch(continueReadingProvider);

    final content = ListView(
      shrinkWrap: embed,
      physics: embed ? const NeverScrollableScrollPhysics() : null,
      children: [
        // Search bar → opens the full search screen with Manga preselected
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: _MangaSearchBar(
            onTap: () => context.push('/search?type=manga'),
          ),
        ),

        // Continue Reading Section
        continueReading.when(
          data: (progressList) {
            if (progressList.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Text(
                    '📖 Continue Reading',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: progressList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final progress = progressList[index];
                      return _ContinueReadingCard(
                        mangaId: progress.mangaId,
                        title: progress.romajiTitle,
                        coverImage: progress.coverImage,
                        chapter: progress.lastReadChapter,
                        percentage: progress.readingPercentage,
                        onTap: () async {
                          String? lastReadChapterId;
                          try {
                            final savedState = await IsarService.instance.chapterReadingStates
                                .filter()
                                .mangaIdEqualTo(progress.mangaId)
                                .chapterNumberEqualTo(progress.lastReadChapter)
                                .findFirst();
                            lastReadChapterId = savedState?.chapterId;
                          } catch (_) {}

                          if (context.mounted) {
                            context.push(
                              '/manga/${progress.mangaId}/read/${progress.lastReadChapter}',
                              extra: {
                                'romajiTitle': progress.romajiTitle,
                                'englishTitle': progress.englishTitle,
                                'coverImage': progress.coverImage,
                                'bannerImage': progress.bannerImage,
                                'totalChapters': (progress.totalChapters != null && progress.totalChapters! > 0) ? progress.totalChapters! : 100,
                                'chapterId': lastReadChapterId,
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        // Trending section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '🔥 Trending Manga',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const _MangaSectionList(section: MangaHomeSection.trending),

        const SizedBox(height: 20),

        // Best Ongoing Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '🆕 Best Ongoing',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const _MangaSectionList(section: MangaHomeSection.popular),

        const SizedBox(height: 20),

        // Latest Releases Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '🆕 Latest Releases',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const _MangaSectionList(section: MangaHomeSection.latestReleases),

        const SizedBox(height: 20),

        // Top Rated Picks Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '🌟 Top Rated Picks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const _MangaSectionList(section: MangaHomeSection.latest),

        const SizedBox(height: 20),

        // Popular This Week Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            '🏆 Popular This Week',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const _MangaSectionList(section: MangaHomeSection.recommended),

        const SizedBox(height: 30),
      ],
    );

    if (embed) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌌 Manga Hub'),
        centerTitle: true,
      ),
      body: content,
    );
  }
}

/// A tappable, read-only search bar. Tapping routes to the full search screen
/// (with the Manga tab preselected) rather than embedding a live query here,
/// so all search logic stays in the search feature.
class _MangaSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const _MangaSearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 12),
              Text(
                'Search manga…',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MangaSectionList extends ConsumerWidget {
  final MangaHomeSection section;

  const _MangaSectionList({required this.section});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mangaAsync = ref.watch(mangaHomeSectionProvider(section));

    return SizedBox(
      height: 280,
      child: AsyncNetworkView(
        value: mangaAsync,
        compact: true,
        loading: () => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (_, __) => const SkeletonCard(),
        ),
        onRetry: () => ref.invalidate(mangaHomeSectionProvider(section)),
        data: (mangaList) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: mangaList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final manga = mangaList[index];
              return _MangaCard(
                manga: manga,
                onTap: () => context.push('/manga/${manga.id}?title=${Uri.encodeComponent(manga.title)}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _MangaCard extends StatelessWidget {
  final MangaHomeModel manga;
  final VoidCallback onTap;

  const _MangaCard({required this.manga, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 150,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: manga.coverImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (_, __) => Container(color: Colors.grey.shade900),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade900,
                    child: const Icon(Icons.broken_image, color: Colors.white24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              manga.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                Text(
                  manga.averageScore != null ? '${manga.averageScore}%' : '-',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _ContinueReadingCard extends StatelessWidget {
  final int mangaId;
  final String title;
  final String coverImage;
  final int chapter;
  final double percentage;
  final VoidCallback onTap;

  const _ContinueReadingCard({
    required this.mangaId,
    required this.title,
    required this.coverImage,
    required this.chapter,
    required this.percentage,
    required this.onTap,
  });

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
          width: 280,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: coverImage,
                  width: 90,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Chapter $chapter',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: (percentage.isNaN || percentage.isInfinite) ? 0.0 : percentage,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${((percentage.isNaN || percentage.isInfinite) ? 0.0 : percentage * 100).toInt()}% completed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
