import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimeCard extends StatelessWidget {
  final int animeId;
  final String title;
  final String rating;
  final String episodes;
  final String imageUrl;

  const AnimeCard({
    super.key,
    required this.animeId,
    required this.title,
    required this.rating,
    required this.episodes,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnknownEpisode = episodes == "?";

    final screenWidth = MediaQuery.of(context).size.width;

    double cardWidth = 175;

    if (screenWidth >= 1200) {
      cardWidth = 240;
    } else if (screenWidth >= 900) {
      cardWidth = 220;
    } else if (screenWidth >= 600) {
      cardWidth = 200;
    }

    return SizedBox(
      width: cardWidth,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push('/anime/$animeId?title=${Uri.encodeComponent(title)}'),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 10,
          shadowColor: Colors.black38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: "anime_$animeId",
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade900,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.deepPurple,
                    child: const Center(
                      child: Icon(
                        Icons.movie,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned.fill(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Color(0x33000000),
                        Color(0x99000000),
                        Color(0xEE000000),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                left: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 12,
                      sigmaY: 12,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white24,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 10,
                right: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 12,
                      sigmaY: 12,
                    ),
                    child: Material(
                      color: Colors.black26,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          // Sprint 8 - Isar Favorites
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toUpperCase(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth >= 600 ? 17 : 15,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        shadows: const [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.tv_rounded,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isUnknownEpisode
                              ? "Ongoing"
                              : "$episodes eps",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenWidth >= 600 ? 13 : 12,
                            fontWeight: FontWeight.w500,
                          ),
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
}