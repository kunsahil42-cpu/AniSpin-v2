import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../error/app_failure.dart';
import '../../../features/anime_details/models/stream_source_model.dart';

/// Thin client for the Anikoto (megaplay.buzz) embed, which serves the same
/// library and episode-id system as the old HiAnime.
///
/// The public surface is a single [resolveStream] call: given a MyAnimeList id,
/// an episode number and a sub/dub choice it returns a [StreamSource] whose
/// [StreamSource.url] is a raw HLS (`.m3u8`) playlist that can be handed
/// straight to a `VideoPlayerController`. The app keeps its own custom player
/// UI — we never surface megaplay's iframe.
///
/// Like [JikanApi]/[MangadexApi] this never leaks a raw HTTP status, exception
/// or the word "megaplay" to the UI: every failure becomes a friendly
/// [AppFailure] that the player renders as a "Stream unavailable" + Retry state.
///
/// Extraction flow (megaplay's own two-step handshake):
///  1. GET the embed page for `mal/{id}/{ep}/{type}` — the HTML carries an
///     internal numeric player id in a `data-id` attribute.
///  2. GET `/stream/getSources?id={dataId}` (an XHR endpoint) which returns JSON
///     with the `.m3u8` source and any subtitle `tracks`.
/// The CDN validates a `Referer`, so [_headers] is echoed back on both hops and
/// returned on the [StreamSource] for playback.
class AnikotoApi {
  AnikotoApi([http.Client? client]) : _client = client ?? http.Client();

  static const String _base = 'https://megaplay.buzz';
  static const Duration _timeout = Duration(seconds: 12);
  static const int _maxAttempts = 2;
  static const Duration _backoffUnit = Duration(milliseconds: 500);

  final http.Client _client;

  /// Headers every request (and later the video player) must send. megaplay's
  /// CDN rejects segment requests that arrive without a matching `Referer`.
  static const Map<String, String> _headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/124.0 Safari/537.36',
    'Referer': '$_base/',
  };

  /// Resolves a playable stream for a single episode.
  ///
  /// [malId] is the anime's MyAnimeList id (available as `idMal` on the details
  /// model). [dub] selects the English dub track, otherwise the subbed source.
  /// Throws an [AppFailure] if the episode can't be resolved.
  Future<StreamSource> resolveStream({
    required int malId,
    required int episode,
    required bool dub,
  }) async {
    final type = dub ? 'dub' : 'sub';
    final embedUrl = '$_base/stream/mal/$malId/$episode/$type';

    final html = await _get(embedUrl);
    final dataId = _extractDataId(html);
    if (dataId == null) {
      _log('no data-id in embed page for mal/$malId/$episode/$type');
      throw AppFailure.notFound('This episode is not available yet.');
    }

    final sourcesJson = await _get(
      '$_base/stream/getSources?id=$dataId',
      xhr: true,
    );
    return _parseSources(sourcesJson);
  }

  /// GETs [url] with retry/backoff on transient failures. Returns the body.
  Future<String> _get(String url, {bool xhr = false}) async {
    final headers = {
      ..._headers,
      if (xhr) 'X-Requested-With': 'XMLHttpRequest',
    };

    AppFailure lastFailure = AppFailure.server();
    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      try {
        final res = await _client
            .get(Uri.parse(url), headers: headers)
            .timeout(_timeout);

        if (res.statusCode == 200) return res.body;
        if (res.statusCode == 404) {
          throw AppFailure.notFound('This episode is not available yet.');
        }
        // 429 / 5xx — retryable.
        lastFailure = AppFailure.server('HTTP ${res.statusCode}');
      } on AppFailure {
        rethrow; // definitive (e.g. 404) — don't retry.
      } catch (e) {
        lastFailure = AppFailure.from(e);
      }

      if (attempt < _maxAttempts) {
        await Future<void>.delayed(_backoffUnit * attempt);
      }
    }
    throw lastFailure;
  }

  /// Pulls megaplay's internal player id out of the embed HTML. The id lives in
  /// a `data-id` attribute on the player container; we accept a few shapes
  /// (attribute order varies, and older markup inlines it in a script) so a
  /// cosmetic template change doesn't break playback.
  static String? _extractDataId(String html) {
    final patterns = <RegExp>[
      RegExp(r'data-id\s*=\s*"(\d+)"'),
      RegExp(r"data-id\s*=\s*'(\d+)'"),
      RegExp(r'id\s*=\s*"megaplay-player"[^>]*data-id\s*=\s*"(\d+)"'),
      RegExp(r'getSources\?id=(\d+)'),
    ];
    for (final re in patterns) {
      final m = re.firstMatch(html);
      if (m != null) return m.group(1);
    }
    return null;
  }

  /// Parses the getSources JSON into a [StreamSource].
  ///
  /// megaplay is inconsistent about `sources`: sometimes an object `{file: ...}`,
  /// sometimes a list `[{file: ...}]`. `tracks` is a list of subtitle/thumbnail
  /// entries; we keep only real caption tracks with a URL.
  static StreamSource _parseSources(String body) {
    final Map<String, dynamic> json;
    try {
      json = jsonDecode(body) as Map<String, dynamic>;
    } catch (e) {
      throw AppFailure.server('Bad stream response.');
    }

    final url = _firstFile(json['sources']);
    if (url == null || url.isEmpty) {
      throw AppFailure.notFound('No playable source for this episode.');
    }

    final tracks = <SubtitleTrack>[];
    final rawTracks = json['tracks'];
    if (rawTracks is List) {
      for (final t in rawTracks) {
        if (t is! Map) continue;
        final kind = (t['kind'] ?? '').toString().toLowerCase();
        // Skip thumbnail/preview tracks — captions/subtitles only.
        if (kind.isNotEmpty && kind != 'captions' && kind != 'subtitles') {
          continue;
        }
        final file = t['file']?.toString();
        if (file == null || file.isEmpty) continue;
        final label = (t['label'] ?? t['lang'] ?? 'Subtitle').toString();
        tracks.add(SubtitleTrack(label: label, url: file));
      }
    }

    return StreamSource(url: url, headers: _headers, subtitles: tracks);
  }

  /// Extracts the first `file` URL from either an object or a list of sources.
  static String? _firstFile(dynamic sources) {
    if (sources is Map) return sources['file']?.toString();
    if (sources is List) {
      for (final s in sources) {
        if (s is Map && s['file'] != null) return s['file'].toString();
      }
    }
    return null;
  }

  static void _log(String msg) {
    if (kDebugMode) debugPrint('[AnikotoApi] $msg');
  }
}
