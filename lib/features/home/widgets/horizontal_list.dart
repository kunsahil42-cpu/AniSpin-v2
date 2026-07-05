import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../../shared/widgets/skeletons/skeleton_card.dart';
import '../../../shared/widgets/states/empty_state.dart';
import '../enums/home_section.dart';
import '../providers/home_provider.dart';
import 'anime_card.dart';

class HorizontalList extends ConsumerWidget {
  final HomeSection section;

  const HorizontalList({
    super.key,
    required this.section,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animeList = ref.watch(
      homeSectionProvider(section),
    );

    return SizedBox(
      height: 320,
      child: AsyncNetworkView(
        value: animeList,
        compact: true,
        loading: () {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            itemCount: 6,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 16),
            itemBuilder: (context, index) =>
                const SkeletonCard(),
          );
        },
        onRetry: () => ref.invalidate(homeSectionProvider(section)),
        data: (anime) {
          if (anime.isEmpty) {
            return const EmptyState(
              title: "Nothing here",
              subtitle:
                  "No anime found in this section.",
              icon: Icons.movie_creation_outlined,
            );
          }

          // 🚀 Pre-cache images
          WidgetsBinding.instance
              .addPostFrameCallback((_) {
            for (final item in anime) {
              precacheImage(
                CachedNetworkImageProvider(
                  item.coverImage,
                ),
                context,
              );
            }
          });

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            itemCount: anime.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = anime[index];

              return AnimeCard(
                animeId: item.id,
                title: item.title,
                rating:
                    (item.averageScore ?? "-")
                        .toString(),
                episodes:
                    (item.episodes ?? "?")
                        .toString(),
                imageUrl: item.coverImage,
              );
            },
          );
        },
      ),
    );
  }
}