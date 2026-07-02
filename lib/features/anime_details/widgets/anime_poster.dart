import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AnimePoster extends StatelessWidget {
  final String imageUrl;

  const AnimePoster({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CachedNetworkImage(
              imageUrl: imageUrl,

              fit: BoxFit.cover,

              // 🚀 Performance
              memCacheWidth: 360,
              memCacheHeight: 540,
              maxWidthDiskCache: 360,
              maxHeightDiskCache: 540,

              filterQuality: FilterQuality.low,

              fadeInDuration: const Duration(
                milliseconds: 180,
              ),

              fadeOutDuration: Duration.zero,

              placeholder: (context, url) => Container(
                color: const Color(0xFF1B1B1B),
              ),

              errorWidget: (context, url, error) =>
                  Container(
                color: Colors.grey.shade800,
                child: const Center(
                  child: Icon(
                    Icons.movie_rounded,
                    color: Colors.white54,
                    size: 70,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}