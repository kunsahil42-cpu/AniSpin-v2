import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../favorites/models/favorite_anime.dart';

class FavoriteCard extends StatelessWidget {
  final FavoriteAnime anime;

  const FavoriteCard({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(anime.animeId),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return false; // Remove in Sprint 8.5.4
      },
      child: Card(
        elevation: 6,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            context.push('/anime/${anime.animeId}');
          },
          child: Row(
            children: [
              Hero(
                tag: 'anime_${anime.animeId}',
                child: Image.network(
                  anime.coverImage,
                  width: 95,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        anime.romajiTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (anime.englishTitle != null &&
                          anime.englishTitle!.isNotEmpty)
                        Text(
                          anime.englishTitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        children: [
                          Chip(
                            label: Text(
                              "${anime.averageScore ?? "-"}%",
                            ),
                          ),
                          Chip(
                            label: Text(
                              anime.status ?? "-",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}