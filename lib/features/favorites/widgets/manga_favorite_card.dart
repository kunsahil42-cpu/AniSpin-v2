import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/favorite_manga.dart';

class MangaFavoriteCard extends StatelessWidget {
  final FavoriteManga manga;

  const MangaFavoriteCard({
    super.key,
    required this.manga,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        context.push('/manga/${manga.mangaId}?title=${Uri.encodeComponent(manga.romajiTitle)}');
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'manga_${manga.mangaId}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: manga.coverImage,
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            manga.romajiTitle,
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
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    if (manga.englishTitle != null &&
                        manga.englishTitle!.isNotEmpty)
                      Text(
                        manga.englishTitle!,
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
                        _chip(
                          Icons.menu_book,
                          "${manga.chapters ?? "-"} Ch",
                          Colors.blue,
                        ),
                        _chip(
                          Icons.library_books,
                          "${manga.volumes ?? "-"} Vol",
                          Colors.green,
                        ),
                        _chip(
                          Icons.edit,
                          manga.status ?? "-",
                          Colors.orange,
                        ),
                        if (manga.author != null &&
                            manga.author!.isNotEmpty)
                          _chip(
                            Icons.person,
                            manga.author!,
                            Colors.deepPurple,
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

  Widget _chip(
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