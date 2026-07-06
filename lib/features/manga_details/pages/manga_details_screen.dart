import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../../shared/widgets/skeletons/skeleton_details.dart';
import '../../anime_details/widgets/anime_banner.dart';
import '../../anime_details/widgets/anime_poster.dart';
import '../../anime_details/widgets/description_section.dart';
import '../../anime_details/widgets/genre_chip.dart';
import '../../anime_details/widgets/score_badge.dart';
import '../../anime_details/widgets/status_chip.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../providers/manga_details_provider.dart';
import '../widgets/chapter_list.dart';
import '../widgets/manga_favorite_button.dart';
import '../../tracker/widgets/manga_tracking_section.dart';

class MangaDetailsScreen extends ConsumerWidget {
  final int mangaId;

  const MangaDetailsScreen({super.key, required this.mangaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manga = ref.watch(mangaDetailsProvider(mangaId));
    final progressAsync = ref.watch(mangaProgressProvider(mangaId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AsyncNetworkView(
        value: manga,
        loading: () => const SkeletonDetails(),
        onRetry: () => ref.invalidate(mangaDetailsProvider(mangaId)),
        data: (mangaData) {
          final theme = Theme.of(context);
          final isTablet = MediaQuery.of(context).size.width >= 600;
          final progress = progressAsync.valueOrNull;
          final currentChapter = progress?.lastReadChapter ?? 1;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(mangaDetailsProvider(mangaId));
              ref.invalidate(mangaChaptersProvider(mangaId));
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ── Banner ──────────────────────────────────────────────────
                SliverAppBar(
                  expandedHeight: 240,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Material(
                          color: Colors.black26,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Material(
                            color: Colors.black26,
                            child: InkWell(
                              onTap: () {
                                // Sprint 10 — Share Manga
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.share_rounded, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: AnimeBanner(imageUrl: mangaData.bannerImage),
                  ),
                ),
  
                // ── Content ─────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -80),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
  
                          // Poster
                          Hero(
                            tag: 'manga_$mangaId',
                            child: AnimePoster(imageUrl: mangaData.coverImage),
                          ),
  
                          const SizedBox(height: 16),
  
                          // Romaji title
                          Text(
                            mangaData.romajiTitle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
  
                          // English title
                          if (mangaData.englishTitle != null &&
                              mangaData.englishTitle!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                mangaData.englishTitle!,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.65),
                                  fontSize: 15,
                                ),
                              ),
                            ),
  
                          const SizedBox(height: 18),
  
                          // Score / Status / Favorite row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: ScoreBadge(score: mangaData.averageScore)),
                              const SizedBox(width: 8),
                              Expanded(child: StatusChip(status: mangaData.status)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: MangaFavoriteButton(
                                  mangaId: mangaData.id,
                                  romajiTitle: mangaData.romajiTitle,
                                  englishTitle: mangaData.englishTitle,
                                  coverImage: mangaData.coverImage,
                                  bannerImage: mangaData.bannerImage,
                                  chapters: mangaData.chapters,
                                  volumes: mangaData.volumes,
                                  status: mangaData.status,
                                  author: mangaData.author,
                                ),
                              ),
                            ],
                          ),
  
                          const SizedBox(height: 20),
  
                          // Genres
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: mangaData.genres
                                .map((g) => GenreChip(genre: g))
                                .toList(),
                          ),
  
                          const SizedBox(height: 24),
  
                          // Metadata grid
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: isTablet ? 4 : 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: isTablet ? 3.0 : 2.8,
                            children: [
                              _MetadataCard(
                                icon: Icons.menu_book_rounded,
                                title: 'Chapters',
                                value: mangaData.chapters?.toString() ?? '-',
                              ),
                              _MetadataCard(
                                icon: Icons.library_books_rounded,
                                title: 'Volumes',
                                value: mangaData.volumes?.toString() ?? '-',
                              ),
                              _MetadataCard(
                                icon: Icons.edit_rounded,
                                title: 'Author',
                                value: mangaData.author.isEmpty
                                    ? '-'
                                    : mangaData.author,
                              ),
                              _MetadataCard(
                                icon: Icons.format_list_bulleted_rounded,
                                title: 'Format',
                                value: mangaData.format?.replaceAll('_', ' ') ?? '-',
                              ),
                            ],
                          ),
  
                          const SizedBox(height: 26),

                          MangaTrackingSection(
                            mangaId: mangaData.id,
                            title: mangaData.romajiTitle,
                            englishTitle: mangaData.englishTitle,
                            coverImage: mangaData.coverImage,
                            bannerImage: mangaData.bannerImage,
                            totalChapters: mangaData.chapters,
                            totalVolumes: mangaData.volumes,
                          ),

                          const SizedBox(height: 26),
  
                          DescriptionSection(description: mangaData.description),
  
                          const SizedBox(height: 24),
  
                          FilledButton.icon(
                            onPressed: () {
                              context.push(
                                '/manga/${mangaData.id}/read/$currentChapter',
                                extra: {
                                  'romajiTitle': mangaData.romajiTitle,
                                  'englishTitle': mangaData.englishTitle,
                                  'coverImage': mangaData.coverImage,
                                  'bannerImage': mangaData.bannerImage,
                                  'totalChapters': mangaData.chapters ?? 100,
                                },
                              );
                            },
                            icon: const Icon(Icons.menu_book),
                            label: Text(progress != null ? 'Continue Chapter $currentChapter' : 'Read Manga'),
                          ),
  
                          const SizedBox(height: 24),
  
                          ChapterList(
                            mangaId: mangaData.id,
                            totalChapters: mangaData.chapters ?? 50,
                            romajiTitle: mangaData.romajiTitle,
                            englishTitle: mangaData.englishTitle,
                            coverImage: mangaData.coverImage,
                            bannerImage: mangaData.bannerImage,
                          ),
  
                          const SizedBox(height: 40),
  
                        ], // Column children
                      ), // Column
                    ), // Padding
                  ), // Transform.translate
                ), // SliverToBoxAdapter
  
              ], // slivers
            ), // CustomScrollView
          ); // RefreshIndicator
        },
      ),
    );
  }
}

// ── Metadata card ────────────────────────────────────────────────────────────

class _MetadataCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _MetadataCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}