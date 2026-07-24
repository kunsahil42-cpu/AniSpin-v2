import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/manga_details/models/chapter_model.dart';
import '../../features/manga_details/models/manga_details_model.dart';
import '../network/mangadot/mangadot_api.dart';
import '../network/mangadex/mangadex_api.dart';

/// Clean utility to preprocess titles for fuzzy search matching.
String _cleanTitle(String title) {
  String cleaned = title.replaceAll(RegExp(r'\([^)]*\)'), '').replaceAll(RegExp(r'\[[^\]]*\]'), '');
  cleaned = cleaned.replaceAll(RegExp(r'[:\-!~\?\.]'), ' ');
  cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
  return cleaned;
}

/// Abstract contract for a manga content source.
abstract class MangaSource {
  String get name;
  Future<List<ChapterModel>> fetchChapters(MangaDetailsModel details);
  Future<List<String>> fetchPages(String chapterId, {required bool useDataSaver});
}

// ─────────────────────────────────────────────────────────────────────────────
// MangaDot Source  (Primary — uses scroper-self.vercel.app)
// ─────────────────────────────────────────────────────────────────────────────

/// MangaDot source implementation.
/// Fetches English-only chapters (deduplicated by chapter number) via the
/// MangaDot Vercel API, then falls back to MangaDex as secondary.
class MangaDotSource implements MangaSource {
  final MangaDotApi _api;

  MangaDotSource(this._api);

  @override
  String get name => 'mangadot';

  @override
  Future<List<ChapterModel>> fetchChapters(MangaDetailsModel details) async {
    // Build a list of query titles (most specific first).
    final queries = <String>{};
    if (details.englishTitle != null && details.englishTitle!.isNotEmpty) {
      queries.add(details.englishTitle!);
      final cleaned = _cleanTitle(details.englishTitle!);
      if (cleaned.isNotEmpty) queries.add(cleaned);
    }
    queries.add(details.romajiTitle);
    final cleanedRomaji = _cleanTitle(details.romajiTitle);
    if (cleanedRomaji.isNotEmpty) queries.add(cleanedRomaji);

    // Try every query until we find a MangaDot ID.
    int? mangaDotId;
    for (final query in queries) {
      try {
        mangaDotId = await _api.findMangaDotId(title: query);
        if (mangaDotId != null) break;
      } catch (_) {}
    }

    if (mangaDotId == null) return const [];

    try {
      // Request English chapters only (API deduplicates by chapter number).
      final chaptersJson = await _api.getChapters(mangaDotId, language: 'en');

      if (chaptersJson.isEmpty) {
        // Fallback: try all languages if no English chapters found.
        final allChapters = await _api.getChapters(mangaDotId, language: 'all');
        if (allChapters.isEmpty) return const [];
        return _mapChapters(allChapters, mangaDotId);
      }

      return _mapChapters(chaptersJson, mangaDotId);
    } catch (e) {
      if (kDebugMode) debugPrint('[MangaDotSource] fetchChapters error: $e');
      return const [];
    }
  }

  List<ChapterModel> _mapChapters(
      List<Map<String, dynamic>> items, int mangaDotId) {
    final mapped = <ChapterModel>[];
    for (final item in items) {
      final id = item['id']?.toString();
      if (id == null || id.isEmpty) continue;

      final number = (item['number'] ?? '0').toString();
      final title = (item['title'] as String? ?? '').trim();
      final releaseDate = (item['release_date'] as String? ?? '').trim();
      final language = ((item['language'] as String?) ?? 'en').toUpperCase();
      final group = (item['group'] as String? ?? '').trim();

      final titleLower = title.toLowerCase();
      final isColored = titleLower.contains('colored') || titleLower.contains('color');
      final isAutoTranslate = titleLower.contains('auto') ||
          titleLower.contains('machine') ||
          titleLower.contains('mtl') ||
          group.toLowerCase().contains('machine') ||
          group.toLowerCase().contains('mtl');

      mapped.add(ChapterModel(
        id: id,
        number: number,
        title: title.isEmpty ? 'Chapter $number' : title,
        scanGroup: group.isEmpty ? 'Unknown' : group,
        date: releaseDate,
        language: language,
        pages: const [],
        isExternal: false,
        externalUrl: null,
        isColored: isColored,
        isAutoTranslate: isAutoTranslate,
        alternatives: const [],
        source: 'mangadot',
        sourceUrl: 'https://mangadot.net/chapter/$id',
        totalPages: 0,
        createdAt: null,
      ));
    }
    return mapped;
  }

  @override
  Future<List<String>> fetchPages(String chapterId, {required bool useDataSaver}) async {
    final id = int.tryParse(chapterId);
    if (id == null) return const [];
    return await _api.getChapterPages(id);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MangaDex Source  (Secondary fallback)
// ─────────────────────────────────────────────────────────────────────────────

/// MangaDex source implementation (fallback).
class MangaDexSource implements MangaSource {
  final MangaDexApi _api;

  MangaDexSource(this._api);

  @override
  String get name => 'mangadex';

  @override
  Future<List<ChapterModel>> fetchChapters(MangaDetailsModel details) async {
    final searchTitle = (details.englishTitle != null && details.englishTitle!.isNotEmpty)
        ? details.englishTitle!
        : details.romajiTitle;

    final uuid = await _api.findMangaDexId(
      title: searchTitle,
      aniListId: details.id,
      malId: details.idMal,
    );
    if (uuid == null) return const [];

    try {
      // Fetch English-only chapters from MangaDex.
      final feedJson = await _api.getMangaFeed(uuid, {
        'translatedLanguage[]': ['en'],
      });

      final List<ChapterModel> mapped = feedJson.map((item) {
        final id = item['id']?.toString() ?? '';
        final attrs = item['attributes'] as Map<String, dynamic>? ?? {};
        final number = (attrs['chapter'] ?? '0').toString();
        final title = attrs['title']?.toString() ?? '';

        String scanGroup = 'Unknown';
        final relationships = item['relationships'] as List?;
        if (relationships != null) {
          for (final rel in relationships) {
            if (rel is Map && rel['type'] == 'scanlation_group') {
              final relAttrs = rel['attributes'] as Map?;
              if (relAttrs != null && relAttrs['name'] != null) {
                scanGroup = relAttrs['name'].toString();
                break;
              }
            }
          }
        }

        final publishAtStr = attrs['publishAt'] as String?;
        String dateStr = '';
        int? createdAtMs;
        if (publishAtStr != null) {
          try {
            final dateTime = DateTime.parse(publishAtStr);
            createdAtMs = dateTime.millisecondsSinceEpoch ~/ 1000;
            final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            dateStr = '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
          } catch (_) {}
        }

        final isAutoTranslate = title.toLowerCase().contains('auto') ||
            title.toLowerCase().contains('machine') ||
            title.toLowerCase().contains('mtl') ||
            scanGroup.toLowerCase().contains('machine') ||
            scanGroup.toLowerCase().contains('mtl');

        final isColored = title.toLowerCase().contains('colored') ||
            title.toLowerCase().contains('color');

        final externalUrl = attrs['externalUrl'] as String?;
        final isExternal = externalUrl != null && externalUrl.isNotEmpty;
        final totalPages = attrs['pages'] as int? ?? 0;

        return ChapterModel(
          id: id,
          number: number,
          title: title.isEmpty ? 'Chapter $number' : title,
          scanGroup: scanGroup,
          date: dateStr,
          language: (attrs['translatedLanguage'] as String?)?.toUpperCase() ?? 'EN',
          pages: const [],
          isExternal: isExternal,
          externalUrl: externalUrl,
          isColored: isColored,
          isAutoTranslate: isAutoTranslate,
          alternatives: const [],
          source: 'mangadex',
          sourceUrl: 'https://mangadex.org/chapter/$id',
          totalPages: totalPages,
          createdAt: createdAtMs,
        );
      }).toList();

      return mapped;
    } catch (e) {
      if (kDebugMode) debugPrint('[MangaDexSource] fetchChapters error: $e');
      return const [];
    }
  }

  @override
  Future<List<String>> fetchPages(String chapterId, {required bool useDataSaver}) async {
    return await _api.getChapterPages(chapterId, useDataSaver: useDataSaver);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Orchestrator
// ─────────────────────────────────────────────────────────────────────────────

/// Orchestrator: tries MangaDot first (fast, English, deduplicated),
/// falls back to MangaDex if MangaDot returns nothing.
class SourceFallbackManager {
  final MangaDotSource dotSource;
  final MangaDexSource dexSource;

  SourceFallbackManager({
    required this.dotSource,
    required this.dexSource,
  });

  Future<List<ChapterModel>> getChapters(MangaDetailsModel details) async {
    // 1. Try MangaDot (primary)
    try {
      final chapters = await dotSource.fetchChapters(details);
      if (chapters.isNotEmpty) {
        if (kDebugMode) debugPrint('[SourceFallbackManager] MangaDot returned ${chapters.length} chapters.');
        return chapters;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('[SourceFallbackManager] MangaDot failed: $e');
    }

    // 2. Fallback to MangaDex
    try {
      if (kDebugMode) debugPrint('[SourceFallbackManager] Falling back to MangaDex...');
      final chapters = await dexSource.fetchChapters(details);
      return chapters;
    } catch (e) {
      if (kDebugMode) debugPrint('[SourceFallbackManager] MangaDex also failed: $e');
      return const [];
    }
  }

  /// Fetches page URLs for the given chapter from the correct source.
  Future<List<String>> getChapterPages({
    required String chapterId,
    required String source,
    required bool useDataSaver,
  }) async {
    if (source == 'mangadex') {
      return await dexSource.fetchPages(chapterId, useDataSaver: useDataSaver);
    }
    // 'mangadot' or any unrecognised source
    return await dotSource.fetchPages(chapterId, useDataSaver: useDataSaver);
  }
}

// Global provider for SourceFallbackManager
final sourceFallbackManagerProvider = Provider<SourceFallbackManager>((ref) {
  final dotApi = ref.watch(mangaDotApiProvider);
  final dexApi = ref.watch(mangaDexApiProvider);
  return SourceFallbackManager(
    dotSource: MangaDotSource(dotApi),
    dexSource: MangaDexSource(dexApi),
  );
});
