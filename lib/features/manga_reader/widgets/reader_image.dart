import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

/// Renders a manga page from any source the pipeline can produce.
///
/// The Smart Chapter Selection Engine may hand back either a remote page URL
/// (`http`/`https`, straight from MangaDex@Home) or a locally-cached translated
/// page written to disk (`file://…`, produced by the OCR/translation pipeline).
/// [CachedNetworkImage] only understands http(s), so file URIs must be routed
/// through [Image.file] instead — otherwise every auto-translated page renders
/// as a broken-image icon.
class ReaderImage extends StatelessWidget {
  final String source;
  final BoxFit fit;
  final int? memCacheWidth;
  final double? placeholderHeight;

  const ReaderImage({
    super.key,
    required this.source,
    this.fit = BoxFit.contain,
    this.memCacheWidth,
    this.placeholderHeight,
  });

  /// Whether [source] points at a local file rather than a network URL.
  static bool isLocal(String source) =>
      source.startsWith('file://') || source.startsWith('/');

  File _resolveFile() {
    if (source.startsWith('file://')) {
      return File.fromUri(Uri.parse(source));
    }
    return File(source);
  }

  @override
  Widget build(BuildContext context) {
    if (isLocal(source)) {
      return Image.file(
        _resolveFile(),
        fit: fit,
        cacheWidth: memCacheWidth,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _error(),
      );
    }

    return CachedNetworkImage(
      imageUrl: source,
      fit: fit,
      memCacheWidth: memCacheWidth,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[900]!,
        highlightColor: Colors.grey[800]!,
        child: Container(
          height: placeholderHeight,
          color: Colors.black,
        ),
      ),
      errorWidget: (_, __, ___) => _error(),
    );
  }

  Widget _error() => SizedBox(
        height: placeholderHeight ?? 200,
        child: const Center(
          child: Icon(Icons.broken_image, size: 60, color: Colors.white30),
        ),
      );
}
