import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// REST client for the MangaDot Vercel API backend.
///
/// Endpoints (base: https://screper-self.vercel.app)
///   GET /api/search?q={title}          → { success, results: [{id,title,cover}] }
///   GET /api/chapters?id={mangaId}     → { success, total, chapters: [{id,number,title,release_date,language,group}] }
///   GET /api/pages?id={chapterId}      → { success, pages: [url…] }
class MangaDotApi {
  MangaDotApi([http.Client? client]) : _client = client ?? http.Client();

  static const String _base = 'https://screper-self.vercel.app';
  static const Duration _timeout = Duration(seconds: 20);
  static const int _maxRetries = 2;

  final http.Client _client;

  // ─── internal GET helper ──────────────────────────────────────────────────

  Future<Map<String, dynamic>> _get(String path,
      [Map<String, String>? params]) async {
    final uri = Uri.parse(_base).replace(
      path: path,
      queryParameters: params,
    );

    for (int attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        final resp = await _client.get(uri).timeout(_timeout);
        if (resp.statusCode == 200) {
          final decoded = jsonDecode(resp.body);
          if (decoded is Map<String, dynamic>) return decoded;
        }
        if (attempt == _maxRetries) {
          throw Exception(
              'MangaDotApi: HTTP ${resp.statusCode} for $uri');
        }
      } catch (e) {
        if (attempt == _maxRetries) rethrow;
        await Future<void>.delayed(
            Duration(milliseconds: 500 * (attempt + 1)));
      }
    }
    throw Exception('MangaDotApi: unreachable');
  }

  // ─── public methods ───────────────────────────────────────────────────────

  /// Search manga by title. Returns list of {id, title, cover}.
  Future<List<Map<String, dynamic>>> searchManga(String query) async {
    final data = await _get('/api/search', {'q': query});
    final raw = data['results'];
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().toList();
  }

  /// Get English chapters for a manga (deduplicated by number, ascending).
  ///
  /// Pass [language] = 'all' to receive every language.
  Future<List<Map<String, dynamic>>> getChapters(
    int mangaId, {
    String language = 'en',
  }) async {
    final data = await _get('/api/chapters', {
      'id': mangaId.toString(),
      'language': language,
    });
    final raw = data['chapters'];
    if (raw is! List) return const [];
    return raw.whereType<Map<String, dynamic>>().toList();
  }

  /// Get page image URLs for a chapter.
  Future<List<String>> getChapterPages(int chapterId) async {
    final data = await _get('/api/pages', {'id': chapterId.toString()});
    final raw = data['pages'];
    if (raw is! List) return const [];
    return raw.whereType<String>().where((u) => u.isNotEmpty).toList();
  }

  /// Find a MangaDot manga ID by searching for the title.
  ///
  /// Tries exact match first, then falls back to the best fuzzy match.
  Future<int?> findMangaDotId({
    required String title,
  }) async {
    try {
      final results = await searchManga(title);
      if (results.isEmpty) return null;

      final titleLower = title.toLowerCase().trim();

      // 1. Exact match
      for (final r in results) {
        final t = (r['title'] as String? ?? '').toLowerCase().trim();
        if (t == titleLower) return r['id'] as int?;
      }

      // 2. Contains match
      for (final r in results) {
        final t = (r['title'] as String? ?? '').toLowerCase().trim();
        if (t.contains(titleLower) || titleLower.contains(t)) {
          return r['id'] as int?;
        }
      }

      // 3. First result as last resort
      return results.first['id'] as int?;
    } catch (e) {
      if (kDebugMode) debugPrint('[MangaDotApi] findMangaDotId error: $e');
      return null;
    }
  }
}

// Riverpod provider
final mangaDotApiProvider = Provider<MangaDotApi>((ref) => MangaDotApi());
