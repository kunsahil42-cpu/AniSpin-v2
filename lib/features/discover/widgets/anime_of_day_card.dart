import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/discover_anime_model.dart';
import 'discover_card.dart';

class AnimeOfDayCard extends StatelessWidget {
  final DiscoverAnimeModel anime;
  final VoidCallback? onTap;

  const AnimeOfDayCard({
    super.key,
    required this.anime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DiscoverCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: anime.coverImage,
              width: 90,
              height: 130,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade900,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade900,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_rounded,
                    color: Colors.white24,
                    size: 32,
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
                Text(
                  anime.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${anime.averageScore ?? "-"}",
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  anime.genres.take(2).join(" • "),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                const Row(
                  children: [
                    Text(
                      "View Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}