import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/discover_anime_model.dart';

class AnimeGridTile extends StatelessWidget {
  final DiscoverAnimeModel anime;
  final VoidCallback? onTap;

  const AnimeGridTile({
    super.key,
    required this.anime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: anime.coverImage,
                width: double.infinity,
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

            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        "${anime.averageScore ?? "-"}",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}