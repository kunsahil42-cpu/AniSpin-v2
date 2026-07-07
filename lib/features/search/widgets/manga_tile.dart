import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/manga_model.dart';

class MangaTile extends StatelessWidget {
  final MangaModel manga;

  const MangaTile({
    super.key,
    required this.manga,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () {
          context.push('/manga/${manga.id}');
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: manga.imageUrl,
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
        title: Text(manga.title),
        subtitle: Text(
          "⭐ ${manga.score ?? '-'} | 📖 ${manga.chapters ?? '-'}",
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
