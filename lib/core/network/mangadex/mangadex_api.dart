import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../error/app_failure.dart';

/// REST client for the MangaDex API.
///
/// Used to retrieve real manga chapters and pages. Implements rate-limiting
/// guards and retries for transient upstream failures to ensure reliability.
class MangaDexApi {
  MangaDexApi([http.Client? client]) : _client = client ?? http.Client();

  static const String _base = 'https://api.mangadex.org';
  static const Duration _minGap = Duration(milliseconds: 250); // Max 4 req/s to stay safe under MangaDex's 5 req/s limit
  static const Duration _timeout = Duration(seconds: 10);
  static const int _maxAttempts = 2;
  static const Duration _backoffUnit = Duration(milliseconds: 500);

  final http.Client _client;

  /// Serial gate to pace request bursts and avoid 429 Rate Limit responses.
  static Future<void> _gate = Future<void>.value();

  // In-memory caches to map string UUIDs to stable integer IDs.
  static final Map<int, String> _idToUuid = {};
  static final Map<String, int> _uuidToId = {};

  /// Convert a MangaDex UUID to a stable integer ID, maintaining an in-memory mapping.
  static int uuidToId(String uuid) {
    if (_uuidToId.containsKey(uuid)) {
      return _uuidToId[uuid]!;
    }
    // Generate a positive stable hash code
    int hash = uuid.hashCode.abs();
    // Resolve collisions
    while (_idToUuid.containsKey(hash) && _idToUuid[hash] != uuid) {
      hash++;
    }
    _idToUuid[hash] = uuid;
    _uuidToId[uuid] = hash;
    return hash;
  }

  /// Resolve a stable integer ID back to a MangaDex UUID. Returns null if not in cache.
  static String? idToUuid(int id) {
    return _idToUuid[id];
  }

  Future<T> _throttled<T>(Future<T> Function() task) {
    final completer = Completer<T>();
    _gate = _gate.then((_) async {
      try {
        completer.complete(await task());
      } catch (e, s) {
        completer.completeError(e, s);
      }
      await Future<void>.delayed(_minGap);
    }).catchError((_) {});
    return completer.future;
  }

  /// Helper to construct URI paths with query parameters.
  String _buildPath(String basePath, [Map<String, dynamic>? queryParams]) {
    if (queryParams == null || queryParams.isEmpty) return basePath;
    final cleanParams = <String, dynamic>{};
    queryParams.forEach((key, val) {
      if (val is Iterable) {
        cleanParams[key] = val.map((e) => e.toString()).toList();
      } else if (val != null) {
        cleanParams[key] = val.toString();
      }
    });
    final uri = Uri(path: basePath, queryParameters: cleanParams);
    return uri.toString();
  }

  /// GET /manga (Search/List Manga)
  Future<Map<String, dynamic>> searchManga([Map<String, dynamic>? queryParams]) async {
    final path = _buildPath('/manga', queryParams);
    return await _requestWithRetry(path);
  }

  /// GET /manga/{id} (Get Manga Details)
  Future<Map<String, dynamic>> getMangaDetails(String id) async {
    final path = _buildPath('/manga/$id', {
      'includes[]': ['author', 'cover_art', 'artist']
    });
    return await _requestWithRetry(path);
  }

  /// GET /manga/{id}/feed (Manga Feed (Chapters))
  ///
  /// Walks the feed page-by-page until every chapter has been retrieved. The
  /// page size is fixed at MangaDex's maximum (500) and [offset] advances until
  /// it reaches `total`, so the full list is returned regardless of length —
  /// no artificial cap. `contentRating` is fully specified so nothing is hidden
  /// by MangaDex's default (which silently drops `pornographic`).
  Future<List<dynamic>> getMangaFeed(String mangaDexId, [Map<String, dynamic>? queryParams]) async {
    final allData = <dynamic>[];
    int offset = 0;
    const int limit = 500;
    // MangaDex hard-caps paginated endpoints at offset + limit <= 10000.
    const int maxOffset = 10000;

    while (true) {
      final params = <String, dynamic>{
        'translatedLanguage[]': ['en'],
        'limit': limit.toString(),
        'offset': offset.toString(),
        'order[chapter]': 'asc',
        'contentRating[]': ['safe', 'suggestive', 'erotica', 'pornographic'],
        'includes[]': ['scanlation_group'],
        ...?queryParams,
      };

      if (queryParams != null &&
          queryParams.containsKey('translatedLanguage[]') &&
          queryParams['translatedLanguage[]'] == null) {
        params.remove('translatedLanguage[]');
      }

      final path = _buildPath('/manga/$mangaDexId/feed', params);

      Map<String, dynamic> response;
      try {
        response = await _requestWithRetry(path);
      } catch (e) {
        // A later page failing must not throw away the pages already fetched.
        _log('Feed page at offset $offset for $mangaDexId failed: $e');
        break;
      }

      final data = response['data'] as List?;
      if (data == null || data.isEmpty) break;

      allData.addAll(data);

      final total = response['total'] as int? ?? 0;
      offset += limit;
      if (offset >= total) break;
      if (offset + limit > maxOffset) {
        // Cannot advance further without exceeding MangaDex's offset ceiling.
        _log('Reached MangaDex offset ceiling for $mangaDexId ($total entries).');
        break;
      }
    }

    return allData;
  }

  /// GET /manga/random (Random Manga)
  Future<Map<String, dynamic>> getRandomManga([Map<String, dynamic>? queryParams]) async {
    final params = <String, dynamic>{
      'includes[]': ['author', 'cover_art'],
      ...?queryParams,
    };
    final path = _buildPath('/manga/random', params);
    return await _requestWithRetry(path);
  }

  /// GET /chapter (Search Chapters)
  Future<Map<String, dynamic>> searchChapters([Map<String, dynamic>? queryParams]) async {
    final path = _buildPath('/chapter', queryParams);
    return await _requestWithRetry(path);
  }

  /// GET /chapter/{id} (Get Chapter)
  Future<Map<String, dynamic>> getChapter(String id) async {
    final path = _buildPath('/chapter/$id', {
      'includes[]': ['manga']
    });
    return await _requestWithRetry(path);
  }

  /// GET /cover (List Covers)
  Future<Map<String, dynamic>> listCovers([Map<String, dynamic>? queryParams]) async {
    final path = _buildPath('/cover', queryParams);
    return await _requestWithRetry(path);
  }

  /// GET /cover/{id} (Get Cover)
  Future<Map<String, dynamic>> getCover(String id) async {
    final path = _buildPath('/cover/$id');
    return await _requestWithRetry(path);
  }

  /// GET /author (Search Authors)
  Future<Map<String, dynamic>> searchAuthors([Map<String, dynamic>? queryParams]) async {
    final path = _buildPath('/author', queryParams);
    return await _requestWithRetry(path);
  }

  /// GET /author/{id} (Author Details)
  Future<Map<String, dynamic>> getAuthorDetails(String id) async {
    final path = _buildPath('/author/$id');
    return await _requestWithRetry(path);
  }

  /// GET /group (Search Groups)
  Future<Map<String, dynamic>> searchGroups([Map<String, dynamic>? queryParams]) async {
    final path = _buildPath('/group', queryParams);
    return await _requestWithRetry(path);
  }

  /// GET /at-home/server/{chapterId} (Chapter Images)
  Future<List<String>> getChapterPages(String chapterDexId) async {
    final path = '/at-home/server/$chapterDexId';
    final response = await _requestWithRetry(path);
    
    final baseUrl = response['baseUrl'] as String?;
    final chapter = response['chapter'] as Map<String, dynamic>?;
    if (baseUrl == null || chapter == null) {
      throw AppFailure.server('Invalid server response from MangaDex@Home.');
    }

    final hash = chapter['hash'] as String?;
    final filenames = chapter['data'] as List?;
    if (hash == null || filenames == null || filenames.isEmpty) {
      throw AppFailure.server('No pages found for this chapter.');
    }

    return filenames
        .whereType<String>()
        .map((filename) => '$baseUrl/data/$hash/$filename')
        .toList();
  }

  /// Finds the MangaDex UUID of a manga matching the given AniList ID or MAL ID.
  Future<String?> findMangaDexId({
    required String title,
    int? aniListId,
    int? malId,
  }) async {
    final list = await findMangaDexIds(title: title, aniListId: aniListId, malId: malId);
    return list.isNotEmpty ? list.first : null;
  }

  /// Register mapping from external/hashed ID to MangaDex UUID.
  static void registerMapping(int id, String uuid) {
    _idToUuid[id] = uuid;
    _uuidToId[uuid] = id;
  }

  /// Finds prioritized candidate MangaDex UUIDs matching AniList/MAL details or title.
  Future<List<String>> findMangaDexIds({
    required String title,
    int? aniListId,
    int? malId,
  }) async {
    // 0. Check in-memory hashed ID lookup first
    if (aniListId != null) {
      final cachedUuid = idToUuid(aniListId);
      if (cachedUuid != null) {
        return [cachedUuid];
      }
    }
    if (malId != null) {
      final cachedUuid = idToUuid(malId);
      if (cachedUuid != null) {
        return [cachedUuid];
      }
    }

    final candidates = <String>[];

    // 1. Query by AniList ID if available
    if (aniListId != null) {
      try {
        final path = '/manga?links[al]=${aniListId.toString()}&includes[]=author';
        final response = await _requestWithRetry(path);
        final data = response['data'] as List?;
        if (data != null && data.isNotEmpty) {
          for (final item in data) {
            final id = item['id'] as String?;
            if (id != null && !candidates.contains(id)) {
              candidates.add(id);
            }
          }
        }
      } catch (_) {}
    }

    // 2. Query by MAL ID if available
    if (malId != null) {
      try {
        final path = '/manga?links[mal]=${malId.toString()}&includes[]=author';
        final response = await _requestWithRetry(path);
        final data = response['data'] as List?;
        if (data != null && data.isNotEmpty) {
          for (final item in data) {
            final id = item['id'] as String?;
            if (id != null && !candidates.contains(id)) {
              candidates.add(id);
            }
          }
        }
      } catch (_) {}
    }

    // An AniList/MAL link match is authoritative: it points at the exact series
    // on MangaDex. Returning here avoids the fuzzy title search below, which can
    // surface colored/side-story editions that carry only a subset of chapters
    // and would otherwise shadow the canonical, complete series.
    if (candidates.isNotEmpty) {
      return candidates;
    }

    // 3. Fallback to title search (only when no authoritative link matched)
    try {
      final encodedTitle = Uri.encodeComponent(title);
      final path = '/manga?title=$encodedTitle&limit=100&includes[]=author'
          '&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&contentRating[]=pornographic';
      final response = await _requestWithRetry(path);
      final data = response['data'] as List?;
      if (data != null && data.isNotEmpty) {
        for (final item in data) {
          final id = item['id'] as String?;
          if (id != null && !candidates.contains(id)) {
            candidates.add(id);
          }
        }
      }
    } catch (e) {
      _log('Failed to query title "$title" in findMangaDexIds: $e');
    }

    return candidates;
  }

  /// Internal request sender with Linear Backoff and Retries.
  Future<Map<String, dynamic>> _requestWithRetry(String path) async {
    AppFailure lastFailure = AppFailure.server();

    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      if (attempt > 1) {
        await Future<void>.delayed(_backoffUnit * (attempt - 1));
      }

      try {
        final res = await _throttled(() => _rawGet(path));

        if (res.statusCode == 200) {
          return jsonDecode(res.body) as Map<String, dynamic>;
        }

        if (res.statusCode == 404) {
          throw AppFailure.notFound('Requested MangaDex item could not be found.');
        }

        lastFailure = AppFailure.server('MangaDex API returned status ${res.statusCode}');
        _log('HTTP ${res.statusCode} on $path (attempt $attempt/$_maxAttempts)');
      } on AppFailure catch (e) {
        if (e.type == AppFailureType.notFound) rethrow;
        lastFailure = e;
        _log('${e.type.name} on $path (attempt $attempt/$_maxAttempts)');
      }
    }

    throw lastFailure;
  }

  Future<http.Response> _rawGet(String path) async {
    try {
      final uri = Uri.parse('$_base$path');
      return await _client.get(uri).timeout(_timeout);
    } catch (e) {
      throw AppFailure.from(e);
    }
  }

  void _log(String message) {
    if (kDebugMode) debugPrint('[MangaDexApi] $message');
  }
}

// Global provider for MangaDexApi
final mangaDexApiProvider = Provider<MangaDexApi>((ref) => MangaDexApi());


