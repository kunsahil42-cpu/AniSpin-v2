/// A resolved playable stream for a single anime episode.
///
/// Produced by [AnikotoApi.resolveStream] after extracting the raw HLS (`.m3u8`)
/// URL out of the Anikoto / megaplay embed. Unlike an iframe embed, [url] can be
/// handed straight to a `VideoPlayerController`, so the app keeps its own custom
/// player UI (gestures, speed, resume, auto-next).
class StreamSource {
  /// Direct playable URL — almost always an HLS `.m3u8` master playlist.
  final String url;

  /// Headers the CDN requires at playback time (typically a `Referer` pointing
  /// back at the embed host). Passed to `VideoPlayerController.networkUrl`'s
  /// `httpHeaders` so the segment requests are not rejected.
  final Map<String, String> headers;

  /// Subtitle tracks bundled with the stream (may be empty for dub sources).
  final List<SubtitleTrack> subtitles;

  const StreamSource({
    required this.url,
    this.headers = const {},
    this.subtitles = const [],
  });
}

/// A single selectable subtitle track for a [StreamSource].
class SubtitleTrack {
  /// Human-readable label, e.g. `English`. Falls back to the raw language code
  /// when the source does not provide a label.
  final String label;

  /// URL of the subtitle file (usually `.vtt`).
  final String url;

  const SubtitleTrack({required this.label, required this.url});
}
