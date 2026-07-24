import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../error/app_failure.dart';

/// REST client for the MangaFire API.
class MangaFireApi {
  MangaFireApi([http.Client? client]) : _client = client ?? http.Client();

  static const String _base = 'https://mangafire.to';
  static const Duration _timeout = Duration(seconds: 10);
  static const int _maxAttempts = 2;
  static const Duration _backoffUnit = Duration(milliseconds: 500);

  final http.Client _client;

  /// GET /api/titles (Search Manga)
  Future<List<Map<String, dynamic>>> searchManga(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final path = '/api/titles?keyword=$encodedQuery&page=1&limit=30';
    final response = await _requestWithRetry(path);
    final items = response['items'] as List?;
    if (items == null) return const [];
    return items.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  /// GET /api/titles/{hid} (Get Manga Details)
  Future<Map<String, dynamic>> getMangaDetails(String hid) async {
    final path = '/api/titles/$hid';
    return await _requestWithRetry(path);
  }

  /// GET /api/titles/{hid}/chapters (Get All Chapters - Paginated)
  Future<List<Map<String, dynamic>>> getChapters(String hid) async {
    final allChapters = <Map<String, dynamic>>[];
    int page = 1;
    const int limit = 200;

    while (true) {
      final path = '/api/titles/$hid/chapters?sort=number&order=desc&page=$page&limit=$limit';
      
      Map<String, dynamic> response;
      try {
        response = await _requestWithRetry(path);
      } catch (e) {
        _log('Chapters page $page for hid $hid failed: $e');
        break;
      }

      final items = response['items'] as List?;
      if (items == null || items.isEmpty) break;

      allChapters.addAll(items.map((item) => Map<String, dynamic>.from(item as Map)));

      final meta = response['meta'] as Map?;
      final hasNext = meta?['hasNext'] as bool? ?? false;
      if (!hasNext) break;

      page++;
    }

    return allChapters;
  }

  /// GET /api/chapters/{chapterId} (Get Chapter Pages)
  Future<List<String>> getChapterPages(String chapterId) async {
    final path = '/api/chapters/$chapterId';
    final response = await _requestWithRetry(path);

    final data = response['data'] as Map?;
    if (data == null) {
      throw AppFailure.server('Invalid chapter pages response.');
    }

    final pages = data['pages'] as List?;
    if (pages == null || pages.isEmpty) {
      throw AppFailure.server('No pages found for this chapter.');
    }

    return pages
        .map((p) {
          if (p is Map) {
            return p['url']?.toString() ?? '';
          }
          return '';
        })
        .where((url) => url.isNotEmpty)
        .toList();
  }

  /// Internal request sender with Linear Backoff and Retries.
  Future<Map<String, dynamic>> _requestWithRetry(String path) async {
    AppFailure lastFailure = AppFailure.server();

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      if (attempt > 1) {
        await Future<void>.delayed(_backoffUnit * (attempt - 1));
      }

      try {
        final res = await _rawGet(path);

        if (res.statusCode == 200) {
          return jsonDecode(res.body) as Map<String, dynamic>;
        }

        if (res.statusCode == 404) {
          throw AppFailure.notFound('Requested MangaFire item could not be found.');
        }

        lastFailure = AppFailure.server('MangaFire API returned status ${res.statusCode}');
        _log('HTTP ${res.statusCode} on $path (attempt $attempt/$_maxAttempts)');
      } on AppFailure catch (e) {
        if (e.type == AppFailureType.notFound) rethrow;
        lastFailure = e;
        _log('${e.type.name} on $path (attempt $attempt/$_maxAttempts)');
      } catch (e) {
        lastFailure = AppFailure.server('MangaFire API request error: $e');
        _log('Error on $path (attempt $attempt/$_maxAttempts): $e');
      }
    }

    throw lastFailure;
  }

  Future<http.Response> _rawGet(String path) async {
    try {
      final uri = Uri.parse('$_base$path');
      return await _client.get(
        uri,
        headers: const {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          'Accept': 'application/json',
          'Accept-Language': 'en-US,en;q=0.9',
        },
      ).timeout(_timeout);
    } catch (e) {
      throw AppFailure.server('Request failed: $e');
    }
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[MangaFireApi] $message');
  }
}

// Global provider for MangaFireApi
final mangaFireApiProvider = Provider<MangaFireApi>((ref) => MangaFireApi());
