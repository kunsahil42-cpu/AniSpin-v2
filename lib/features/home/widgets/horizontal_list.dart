import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final animeList = ref.watch(homeSectionProvider(section));

    return SizedBox(
      height: 360,
      child: animeList.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
        ),
        data: (anime) {
          if (anime.isEmpty) {
            return const Center(
              child: Text("No anime found"),
            );
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: anime.length,
            separatorBuilder: (_, index) =>
                const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = anime[index];

              return AnimeCard(
                title: item.title,
                rating: (item.averageScore ?? "-").toString(),
                episodes: (item.episodes ?? "?").toString(),
               imageUrl: item.coverImage,
             );
            },
          );
        },
      ),
    );
  }
}