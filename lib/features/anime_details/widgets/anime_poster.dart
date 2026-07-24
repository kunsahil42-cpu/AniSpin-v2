import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Premium poster card used on Anime Details and Manga Details screens.
class AnimePoster extends StatelessWidget {
  final String imageUrl;

  static const double _posterWidth = 180;

  const AnimePoster({
    super.key,
    required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty && imageUrl != "null";

    return SizedBox(
      width: _posterWidth,
      child: Material(
        color: Colors.transparent,
        elevation: 20,
        shadowColor: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: hasImage
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                  fadeInDuration: const Duration(milliseconds: 250),
                  fadeOutDuration: Duration.zero,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade900,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF7C4DFF),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade900,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_rounded,
                        color: Colors.white38,
                        size: 48,
                      ),
                    ),
                  ),
                )
              : Container(
                  color: Colors.grey.shade900,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image_rounded,
                      color: Colors.white38,
                      size: 48,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}