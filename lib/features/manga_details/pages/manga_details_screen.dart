import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/skeletons/skeleton_details.dart';
import '../../../shared/widgets/states/error_state.dart';

import '../../anime_details/widgets/anime_banner.dart';
import '../../anime_details/widgets/anime_poster.dart';
import '../../anime_details/widgets/description_section.dart';
import '../../anime_details/widgets/genre_chip.dart';
import '../../anime_details/widgets/score_badge.dart';
import '../../anime_details/widgets/status_chip.dart';

import '../providers/manga_details_provider.dart';
import '../widgets/manga_favorite_button.dart';

class MangaDetailsScreen extends ConsumerWidget {
  final int mangaId;

  const MangaDetailsScreen({
    super.key,
    required this.mangaId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manga = ref.watch(
      mangaDetailsProvider(mangaId),
    );

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      body: manga.when(
        loading: () => const SkeletonDetails(),

        error: (error, stackTrace) => ErrorState(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(
              mangaDetailsProvider(mangaId),
            );
          },
        ),

        data: (mangaData) {
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
                              Navigator.pop(context),
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
                              // Sprint 10
                              // Share Manga
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.share_rounded,
                                color: Colors.white,
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
                    imageUrl:
                        mangaData.bannerImage,
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
                          tag: 'manga_$mangaId',
                          child: AnimePoster(
                            imageUrl:
                                mangaData.coverImage,
                          ),
                        ),

                        const SizedBox(height: 28),

                        Text(
                          mangaData.romajiTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                        ),

                        if (mangaData.englishTitle !=
                                null &&
                            mangaData
                                .englishTitle!
                                .isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(
                              top: 8,
                            ),
                            child: Text(
                              mangaData.englishTitle!,
                              textAlign:
                                  TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                          ),

                        const SizedBox(height: 20),

                        Wrap(
                          alignment:
                              WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ScoreBadge(
                              score:
                                  mangaData.averageScore,
                            ),
                            StatusChip(
                              status:
                                  mangaData.status,
                            ),
                            MangaFavoriteButton(
                              mangaId:
                                  mangaData.id,
                              romajiTitle:
                                  mangaData.romajiTitle,
                              englishTitle:
                                  mangaData.englishTitle,
                              coverImage:
                                  mangaData.coverImage,
                              bannerImage:
                                  mangaData.bannerImage,
                              chapters:
                                  mangaData.chapters,
                              volumes:
                                  mangaData.volumes,
                              status:
                                  mangaData.status,
                              author:
                                  mangaData.author,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                                                Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: mangaData.genres
                              .map(
                                (genre) => GenreChip(
                                  genre: genre,
                                ),
                              )
                              .toList(),
                        ),

                        const SizedBox(height: 24),

                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.menu_book_rounded,
                                  ),
                                  title: const Text("Chapters"),
                                  trailing: Text(
                                    mangaData.chapters?.toString() ??
                                        "-",
                                  ),
                                ),

                                const Divider(),

                                ListTile(
                                  leading: const Icon(
                                    Icons.library_books_rounded,
                                  ),
                                  title: const Text("Volumes"),
                                  trailing: Text(
                                    mangaData.volumes?.toString() ??
                                        "-",
                                  ),
                                ),

                                const Divider(),

                                ListTile(
                                  leading: const Icon(
                                    Icons.edit_rounded,
                                  ),
                                  title: const Text("Author"),
                                  trailing: Text(
                                    mangaData.author.isEmpty
                                        ? "-"
                                        : mangaData.author,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        DescriptionSection(
                          description:
                              mangaData.description,
                        ),

                        const SizedBox(height: 24),

                        FilledButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Reader coming soon",
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.menu_book,
                          ),
                          label: const Text(
                            "Read Manga",
                          ),
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