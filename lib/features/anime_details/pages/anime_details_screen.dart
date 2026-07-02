import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/skeletons/skeleton_details.dart';
import '../providers/anime_details_provider.dart';
import '../widgets/anime_banner.dart';
import '../widgets/anime_poster.dart';
import '../widgets/description_section.dart';
import '../widgets/favorite_button.dart';
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
    final anime = ref.watch(
      animeDetailsProvider(animeId),
    );

    return Scaffold(
      body: anime.when(
        loading: () => const SkeletonDetails(),

        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),

        data: (animeData) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,

                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ClipOval(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 12,
                        sigmaY: 12,
                      ),
                      child: Material(
                        color: Colors.black26,
                        child: InkWell(
                          onTap: () =>
                              Navigator.of(context).pop(),
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
                    padding: const EdgeInsets.only(
                      right: 10,
                      top: 8,
                      bottom: 8,
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 12,
                          sigmaY: 12,
                        ),
                        child: Material(
                          color: Colors.black26,
                          child: InkWell(
                            onTap: () {
                              // Sprint 9 - Share
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.share_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],

                flexibleSpace: FlexibleSpaceBar(
                  background: AnimeBanner(
                    imageUrl: animeData.bannerImage,
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Transform.translate(
                  offset: const Offset(0, -100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'anime_$animeId',
                          flightShuttleBuilder: (
                          flightContext,
                          animation,
                          flightDirection,
                          fromHeroContext,
                          toHeroContext,
                        ) {
                          return toHeroContext.widget;
                        },
                        child: AnimePoster(
                          imageUrl: animeData.coverImage,
                        ),
                      ),

                        const SizedBox(height: 28),

                        Text(
                          animeData.romajiTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),

                        if (animeData.englishTitle !=
                                null &&
                            animeData
                                .englishTitle!
                                .isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Text(
                              animeData.englishTitle!,
                              textAlign:
                                  TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        Colors.white70,
                                  ),
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
                             FavoriteButton(
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
                          ],
                        ),

                        const SizedBox(height: 22),

                        Wrap(
                          alignment:
                              WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: animeData.genres
                              .map(
                                (genre) =>
                                    GenreChip(
                                  genre: genre,
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 24),

                        Wrap(
                          alignment:
                              WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            Chip(
                              avatar: const Icon(
                                Icons.tv,
                                size: 18,
                              ),
                              label: Text(
                                "${animeData.episodes ?? "?"} Episodes",
                              ),
                            ),
                            Chip(
                              avatar: const Icon(
                                Icons.business,
                                size: 18,
                              ),
                              label: Text(
                                animeData.studio.isEmpty
                                    ? "Unknown"
                                    : animeData
                                        .studio,
                              ),
                            ),
                            Chip(
                              avatar: const Icon(
                                Icons.schedule,
                                size: 18,
                              ),
                              label: Text(
                                animeData.duration ==
                                        null
                                    ? "-"
                                    : "${animeData.duration} min",
                              ),
                            ),
                            Chip(
                              avatar: const Icon(
                                Icons.calendar_today,
                                size: 18,
                              ),
                              label: Text(
                                "${animeData.season ?? "-"} ${animeData.seasonYear ?? ""}",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        DescriptionSection(
                          description:
                              animeData.description,
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
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