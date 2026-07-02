import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/anime_details_provider.dart';
import '../widgets/anime_banner.dart';
import '../widgets/anime_info_card.dart';
import '../widgets/anime_poster.dart';
import '../widgets/description_section.dart';
import '../widgets/genre_chip.dart';
import '../widgets/score_badge.dart';
import '../widgets/status_chip.dart';

class AnimeDetailsScreen extends ConsumerWidget {
  final int animeId;

  const AnimeDetailsScreen({
    super.key,
    required this.animeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anime = ref.watch(animeDetailsProvider(animeId));

    return Scaffold(
      body: anime.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(error.toString()),
        ),
        data: (animeData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    animeData.romajiTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: AnimeBanner(
                    imageUrl: animeData.bannerImage,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: AnimePoster(
                          imageUrl: animeData.coverImage,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        animeData.romajiTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      if (animeData.englishTitle != null &&
                          animeData.englishTitle!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            animeData.englishTitle!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),

                      const SizedBox(height: 20),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ScoreBadge(
                            score: animeData.averageScore,
                          ),
                          StatusChip(
                            status: animeData.status,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 8,
                        children: animeData.genres
                            .map(
                              (genre) => GenreChip(
                                genre: genre,
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 24),

                      AnimeInfoCard(
                        title: "Episodes",
                        value:
                            animeData.episodes?.toString() ?? "Unknown",
                        icon: Icons.movie,
                      ),

                      AnimeInfoCard(
                        title: "Studio",
                        value: animeData.studio.isEmpty
                            ? "Unknown"
                            : animeData.studio,
                        icon: Icons.business,
                      ),

                      AnimeInfoCard(
                        title: "Season",
                        value:
                            "${animeData.season ?? "-"} ${animeData.seasonYear ?? ""}",
                        icon: Icons.calendar_month,
                      ),

                      AnimeInfoCard(
                        title: "Duration",
                        value: animeData.duration == null
                            ? "-"
                            : "${animeData.duration} min",
                        icon: Icons.schedule,
                      ),

                      const SizedBox(height: 24),

                      DescriptionSection(
                        description: animeData.description,
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}