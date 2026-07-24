import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/anime_model.dart';

class AnimeTile extends StatelessWidget {
  final AnimeModel anime;

  const AnimeTile({
    super.key,
    required this.anime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () {
          context.push('/anime/${anime.id}?title=${Uri.encodeComponent(anime.title)}');
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: anime.imageUrl,
            width: 55,
            height: 80,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade900,
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade900,
              child: const Icon(
                Icons.broken_image_rounded,
                color: Colors.white24,
              ),
            ),
          ),
        ),
        title: Text(anime.title),
        subtitle: Text(
          "⭐ ${anime.score ?? '-'} | 📺 ${anime.episodes ?? '-'}",
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}