import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../../shared/widgets/skeletons/skeleton_details.dart';
import '../providers/anime_details_provider.dart';
import '../widgets/anime_banner.dart';
import '../widgets/anime_poster.dart';
import '../widgets/description_section.dart';
import '../widgets/episode_list.dart';
import '../widgets/favorite_button.dart';
import '../widgets/genre_chip.dart';
import '../widgets/score_badge.dart';
import '../widgets/status_chip.dart';
import '../../tracker/widgets/anime_tracking_section.dart';

class AnimeDetailsScreen extends ConsumerWidget {
  final int animeId;

  const AnimeDetailsScreen({super.key, required this.animeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anime = ref.watch(animeDetailsProvider(animeId));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AsyncNetworkView(
        value: anime,
        loading: () => const SkeletonDetails(),
        onRetry: () => ref.invalidate(animeDetailsProvider(animeId)),
        data: (animeData) {
          final theme = Theme.of(context);
          final isTablet = MediaQuery.of(context).size.width >= 600;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(animeDetailsProvider(animeId));
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
                              onTap: () {},
                              child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.share_rounded, color: Colors.white, size: 22),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: AnimeBanner(imageUrl: animeData.bannerImage),
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
                            tag: 'anime_$animeId',
                            flightShuttleBuilder: (_, __, ___, ____, toCtx) =>
                                toCtx.widget,
                            child: AnimePoster(imageUrl: animeData.coverImage),
                          ),
  
                          const SizedBox(height: 16),
  
                          // Romaji title
                          Text(
                            animeData.romajiTitle,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
  
                          // English title
                          if (animeData.englishTitle != null &&
                              animeData.englishTitle!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                animeData.englishTitle!,
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
                              Expanded(child: ScoreBadge(score: animeData.averageScore)),
                              const SizedBox(width: 8),
                              Expanded(child: StatusChip(status: animeData.status)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: FavoriteButton(
                                  animeId: animeData.id,
                                  romajiTitle: animeData.romajiTitle,
                                  englishTitle: animeData.englishTitle,
                                  coverImage: animeData.coverImage,
                                  bannerImage: animeData.bannerImage,
                                  status: animeData.status,
                                  studio: animeData.studio,
                                  averageScore: animeData.averageScore,
                                  episodes: animeData.episodes,
                                  season: animeData.season,
                                  seasonYear: animeData.seasonYear,
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
                            children: animeData.genres
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
                                icon: Icons.tv_rounded,
                                title: 'Episodes',
                                value: "${animeData.episodes ?? '?'} Ep",
                              ),
                              _MetadataCard(
                                icon: Icons.business_rounded,
                                title: 'Studio',
                                value: animeData.studio.isEmpty
                                    ? 'Unknown'
                                    : animeData.studio,
                              ),
                              _MetadataCard(
                                icon: Icons.schedule_rounded,
                                title: 'Duration',
                                value: animeData.duration == null
                                    ? '-'
                                    : '${animeData.duration} min',
                              ),
                              _MetadataCard(
                                icon: Icons.calendar_today_rounded,
                                title: 'Season',
                                value:
                                    "${animeData.season ?? '-'} ${animeData.seasonYear ?? ''}",
                              ),
                            ],
                          ),
  
                          const SizedBox(height: 26),

                          AnimeTrackingSection(
                            animeId: animeData.id,
                            malId: animeData.idMal,
                            title: animeData.romajiTitle,
                            englishTitle: animeData.englishTitle,
                            coverImage: animeData.coverImage,
                            bannerImage: animeData.bannerImage,
                            totalEpisodes: animeData.episodes,
                            genres: animeData.genres,
                            studio: animeData.studio,
                          ),

                          const SizedBox(height: 26),
  
                          DescriptionSection(description: animeData.description),
  
                          const SizedBox(height: 24),
  
                          EpisodeList(
                            animeId: animeData.id,
                            malId: animeData.idMal,
                            totalEpisodes: animeData.episodes ?? 12,
                            status: animeData.status,
                            romajiTitle: animeData.romajiTitle,
                            englishTitle: animeData.englishTitle,
                            coverImage: animeData.coverImage,
                            bannerImage: animeData.bannerImage,
                            streamingEpisodes: animeData.streamingEpisodes,
                            nextAiringEpisode: animeData.nextAiringEpisode,
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