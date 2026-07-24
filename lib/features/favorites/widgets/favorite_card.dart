import 'package:cached_network_image/cached_network_image.dart';
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          context.push('/anime/${anime.animeId}?title=${Uri.encodeComponent(anime.romajiTitle)}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'anime_${anime.animeId}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: anime.coverImage,
                    width: 95,
                    height: 140,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 95,
                      height: 140,
                      color: Colors.grey.shade900,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 95,
                      height: 140,
                      color: Colors.grey.shade900,
                      child: const Icon(
                        Icons.broken_image_rounded,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            anime.romajiTitle,
                            maxLines: 2,
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                          size: 22,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    if (anime.englishTitle != null &&
                        anime.englishTitle!.isNotEmpty)
                      Text(
                        anime.englishTitle!,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                      ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChip(
                          Icons.star_rounded,
                          "${anime.averageScore ?? "-"}%",
                          Colors.amber,
                        ),
                        _buildChip(
                          Icons.tv_rounded,
                          anime.status ?? "-",
                          Colors.green,
                        ),
                        _buildChip(
                          Icons.movie_rounded,
                          "${anime.episodes ?? "-"} EP",
                          Colors.blue,
                        ),
                        if (anime.season != null ||
                            anime.seasonYear != null)
                          _buildChip(
                            Icons.calendar_today_rounded,
                            "${anime.season ?? ""} ${anime.seasonYear ?? ""}",
                            Colors.deepPurple,
                          ),
                        if (anime.studio != null &&
                            anime.studio!.isNotEmpty)
                          _buildChip(
                            Icons.apartment_rounded,
                            anime.studio!,
                            Colors.orange,
                          ),
                      ],
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

  Widget _buildChip(
    IconData icon,
    String text,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}