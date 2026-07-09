import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/manga_details/models/chapter_model.dart';
import '../../features/manga_details/models/manga_details_model.dart';
import '../network/mangadex/mangadex_api.dart';
import '../network/mangafire/mangafire_api.dart';

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

/// MangaDex Source implementation.
class MangaDexSource implements MangaSource {
  final MangaDexApi _api;

  MangaDexSource(this._api);

  @override
  String get name => 'mangadex';

  @override
  Future<List<ChapterModel>> fetchChapters(MangaDetailsModel details) async {
    final allDexIds = <String>{};

    // Try 1: Romaji title
    try {
      final romajiIds = await _api.findMangaDexIds(
        title: details.romajiTitle,
        aniListId: details.id,
        malId: details.idMal,
      );
      allDexIds.addAll(romajiIds);
    } catch (_) {}

    // Try 2: English title fallback
    if (details.englishTitle != null && details.englishTitle!.isNotEmpty) {
      try {
        final englishIds = await _api.findMangaDexIds(
          title: details.englishTitle!,
          aniListId: details.id,
          malId: details.idMal,
        );
        allDexIds.addAll(englishIds);
      } catch (_) {}
    }

    // Try 3: Native title fallback
    if (details.nativeTitle != null && details.nativeTitle!.isNotEmpty) {
      try {
        final nativeIds = await _api.findMangaDexIds(
          title: details.nativeTitle!,
          aniListId: details.id,
          malId: details.idMal,
        );
        allDexIds.addAll(nativeIds);
      } catch (_) {}
    }

    // Try 4: Cleaned Romaji title fallback
    if (allDexIds.isEmpty) {
      final cleanedRomaji = _cleanTitle(details.romajiTitle);
      if (cleanedRomaji != details.romajiTitle && cleanedRomaji.isNotEmpty) {
        try {
          final cleanedIds = await _api.findMangaDexIds(
            title: cleanedRomaji,
            aniListId: details.id,
            malId: details.idMal,
          );
          allDexIds.addAll(cleanedIds);
        } catch (_) {}
      }
    }

    // Try 5: Cleaned English title fallback
    if (allDexIds.isEmpty && details.englishTitle != null && details.englishTitle!.isNotEmpty) {
      final cleanedEnglish = _cleanTitle(details.englishTitle!);
      if (cleanedEnglish != details.englishTitle && cleanedEnglish.isNotEmpty) {
        try {
          final cleanedIds = await _api.findMangaDexIds(
            title: cleanedEnglish,
            aniListId: details.id,
            malId: details.idMal,
          );
          allDexIds.addAll(cleanedIds);
        } catch (_) {}
      }
    }

    // Try 6: Cleaned Native title fallback
    if (allDexIds.isEmpty && details.nativeTitle != null && details.nativeTitle!.isNotEmpty) {
      final cleanedNative = _cleanTitle(details.nativeTitle!);
      if (cleanedNative != details.nativeTitle && cleanedNative.isNotEmpty) {
        try {
          final cleanedIds = await _api.findMangaDexIds(
            title: cleanedNative,
            aniListId: details.id,
            malId: details.idMal,
          );
          allDexIds.addAll(cleanedIds);
        } catch (_) {}
      }
    }

    // Try 7: Registered mapping fallback
    if (allDexIds.isEmpty) {
      final cachedUuid = MangaDexApi.idToUuid(details.id);
      if (cachedUuid != null) {
        allDexIds.add(cachedUuid);
      }
    }

    if (allDexIds.isEmpty) {
      return const [];
    }

    final List<ChapterModel> allChapters = [];

    for (final dexId in allDexIds) {
      try {
        final feed = await _api.getMangaFeed(dexId);
        
        final List<ChapterModel> mapped = feed.map((item) {
          final map = item as Map<String, dynamic>;
          final id = map['id'] as String?;
          final attrs = map['attributes'] as Map<String, dynamic>? ?? {};
          final chStr = attrs['chapter'] as String? ?? '0';
          final number = double.tryParse(chStr)?.toInt() ?? 0;
          final title = attrs['title'] as String? ?? '';
          final language = attrs['translatedLanguage'] as String? ?? 'EN';

          String scanGroup = 'Unknown Group';
          final relationships = map['relationships'] as List? ?? [];
          for (final rel in relationships) {
            if (rel is Map && rel['type'] == 'scanlation_group') {
              final relAttrs = rel['attributes'] as Map?;
              if (relAttrs != null && relAttrs['name'] != null) {
                scanGroup = relAttrs['name'].toString();
                break;
              }
            }
          }

          final publishAtStr = attrs['publishAt'] as String? ?? '';
          String dateStr = '';
          if (publishAtStr.isNotEmpty) {
            try {
              final dateTime = DateTime.parse(publishAtStr);
              final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
              dateStr = '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
            } catch (_) {
              dateStr = publishAtStr;
            }
          }

          final extUrl = attrs['externalUrl'] as String?;
          final isExternal = extUrl != null && extUrl.isNotEmpty;

          // Detect if chapter is colored
          final titleLower = title.toLowerCase();
          final groupLower = scanGroup.toLowerCase();
          final isColored = titleLower.contains('colored') ||
                            titleLower.contains('color') ||
                            groupLower.contains('colored') ||
                            groupLower.contains('color') ||
                            details.romajiTitle.toLowerCase().contains('colored');

          // Detect if chapter is auto-translated
          final isAutoTranslate = titleLower.contains('auto') ||
                                  titleLower.contains('machine') ||
                                  titleLower.contains('mtl') ||
                                  groupLower.contains('mtl') ||
                                  groupLower.contains('machine');

          return ChapterModel(
            id: id,
            number: number,
            title: title.isEmpty ? 'Chapter $number' : title,
            scanGroup: scanGroup,
            date: dateStr,
            language: language.toUpperCase(),
            pages: const [],
            isExternal: isExternal,
            externalUrl: extUrl,
            isColored: isColored,
            isAutoTranslate: isAutoTranslate,
            alternatives: const [],
            source: 'mangadex',
          );
        }).toList();

        allChapters.addAll(mapped);
      } catch (_) {}
    }

    // Filter only English chapters
    final englishChapters = allChapters.where((c) => c.language == 'EN').toList();

    // Group chapters by number to select the best available version
    final Map<int, List<ChapterModel>> grouped = {};
    for (final chapter in englishChapters) {
      grouped.putIfAbsent(chapter.number, () => []).add(chapter);
    }

    final List<ChapterModel> selectedChapters = [];
    for (final entry in grouped.entries) {
      final list = entry.value;

      final versions = List<ChapterModel>.from(list);
      versions.sort((a, b) {
        if (!a.isExternal && b.isExternal) return -1;
        if (a.isExternal && !b.isExternal) return 1;
        return 0;
      });

      final primary = versions.first;
      final otherAlternatives = versions.skip(1).toList();

      selectedChapters.add(
        ChapterModel(
          id: primary.id,
          number: primary.number,
          title: primary.title,
          scanGroup: primary.scanGroup,
          date: primary.date,
          language: primary.language,
          pages: primary.pages,
          isExternal: primary.isExternal,
          externalUrl: primary.externalUrl,
          isColored: primary.isColored,
          isAutoTranslate: primary.isAutoTranslate,
          alternatives: otherAlternatives,
          source: 'mangadex',
        ),
      );
    }

    return selectedChapters;
  }

  @override
  Future<List<String>> fetchPages(String chapterId, {required bool useDataSaver}) async {
    return await _api.getChapterPages(chapterId, useDataSaver: useDataSaver);
  }
}

/// MangaFire Source implementation.
class MangaFireSource implements MangaSource {
  final MangaFireApi _api;

  MangaFireSource(this._api);

  @override
  String get name => 'mangafire';

  @override
  Future<List<ChapterModel>> fetchChapters(MangaDetailsModel details) async {
    final hid = await _resolveMangaFireHid(details);
    if (hid == null) return const [];

    try {
      final chaptersJson = await _api.getChapters(hid);

      final List<ChapterModel> mapped = chaptersJson.map((item) {
        final id = item['id']?.toString();
        final numVal = item['number'];
        final number = (numVal is num) ? numVal.toInt() : (double.tryParse(numVal?.toString() ?? '')?.toInt() ?? 0);
        final title = item['name']?.toString() ?? '';
        final language = item['language']?.toString() ?? 'en';

        final createdAt = item['createdAt'] as int?;
        String dateStr = '';
        if (createdAt != null) {
          try {
            final dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000);
            final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            dateStr = '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
          } catch (_) {}
        }

        final titleLower = title.toLowerCase();
        final isColored = titleLower.contains('colored') ||
                          titleLower.contains('color') ||
                          details.romajiTitle.toLowerCase().contains('colored');

        final isAutoTranslate = titleLower.contains('auto') ||
                                titleLower.contains('machine') ||
                                titleLower.contains('mtl');

        return ChapterModel(
          id: id,
          number: number,
          title: title.isEmpty ? 'Chapter $number' : title,
          scanGroup: 'MangaFire',
          date: dateStr,
          language: language.toUpperCase(),
          pages: const [],
          isExternal: false,
          externalUrl: null,
          isColored: isColored,
          isAutoTranslate: isAutoTranslate,
          alternatives: const [],
          source: 'mangafire',
        );
      }).toList();

      // Filter only English chapters
      final englishChapters = mapped.where((c) => c.language == 'EN').toList();

      // Group chapters by number to select the best available version
      final Map<int, List<ChapterModel>> grouped = {};
      for (final chapter in englishChapters) {
        grouped.putIfAbsent(chapter.number, () => []).add(chapter);
      }

      final List<ChapterModel> selectedChapters = [];
      for (final entry in grouped.entries) {
        final list = entry.value;
        final versions = List<ChapterModel>.from(list);

        final primary = versions.first;
        final otherAlternatives = versions.skip(1).toList();

        selectedChapters.add(
          ChapterModel(
            id: primary.id,
            number: primary.number,
            title: primary.title,
            scanGroup: primary.scanGroup,
            date: primary.date,
            language: primary.language,
            pages: primary.pages,
            isExternal: primary.isExternal,
            externalUrl: primary.externalUrl,
            isColored: primary.isColored,
            isAutoTranslate: primary.isAutoTranslate,
            alternatives: otherAlternatives,
            source: 'mangafire',
          ),
        );
      }

      // Sort ascending by chapter number
      selectedChapters.sort((a, b) => a.number.compareTo(b.number));

      return selectedChapters;
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<List<String>> fetchPages(String chapterId, {required bool useDataSaver}) async {
    return await _api.getChapterPages(chapterId);
  }

  Future<String?> _resolveMangaFireHid(MangaDetailsModel details) async {
    final queries = <String>{};
    if (details.englishTitle != null && details.englishTitle!.isNotEmpty) {
      queries.add(details.englishTitle!);
      final cleaned = _cleanTitle(details.englishTitle!);
      if (cleaned.isNotEmpty) queries.add(cleaned);
    }
    queries.add(details.romajiTitle);
    final cleanedRomaji = _cleanTitle(details.romajiTitle);
    if (cleanedRomaji.isNotEmpty) queries.add(cleanedRomaji);

    final seenHids = <String>{};
    final candidates = <Map<String, dynamic>>[];

    for (final query in queries) {
      try {
        final results = await _api.searchManga(query);
        for (final item in results) {
          final hid = item['hid']?.toString();
          if (hid != null && !seenHids.contains(hid)) {
            seenHids.add(hid);
            candidates.add(item);
          }
        }
      } catch (_) {}
    }

    if (candidates.isEmpty) return null;

    final targetRomaji = details.romajiTitle.toLowerCase().trim();
    final targetEnglish = details.englishTitle?.toLowerCase().trim() ?? '';

    for (final c in candidates) {
      final cTitle = (c['title'] ?? '').toString().toLowerCase().trim();
      int score = 0;
      if (cTitle == targetRomaji || (targetEnglish.isNotEmpty && cTitle == targetEnglish)) {
        score = 3;
      } else if (cTitle.contains(targetRomaji) || targetRomaji.contains(cTitle)) {
        score = 1;
      }
      c['matchScore'] = score;
    }

    candidates.sort((a, b) {
      final scoreA = a['matchScore'] as int? ?? 0;
      final scoreB = b['matchScore'] as int? ?? 0;
      if (scoreA != scoreB) return scoreB.compareTo(scoreA);

      final rankA = a['rank'] as int? ?? 999999;
      final rankB = b['rank'] as int? ?? 999999;
      return rankA.compareTo(rankB);
    });

    final limit = candidates.length > 5 ? 5 : candidates.length;
    for (int i = 0; i < limit; i++) {
      final cand = candidates[i];
      final hid = cand['hid'] as String;
      try {
        final detailedInfo = await _api.getMangaDetails(hid);
        final candAniListId = int.tryParse(detailedInfo['anilistId']?.toString() ?? '');
        final candMalId = int.tryParse(detailedInfo['malId']?.toString() ?? '');

        if ((candAniListId != null && candAniListId == details.id) ||
            (candMalId != null && candMalId == details.idMal)) {
          return hid;
        }
      } catch (_) {}
    }

    final bestCand = candidates.first;
    final bestScore = bestCand['matchScore'] as int? ?? 0;
    if (bestScore >= 1) {
      return bestCand['hid'] as String;
    }

    return null;
  }
}

/// Orchestrator of fallback sources.
class SourceFallbackManager {
  final MangaDexSource dexSource;
  final MangaFireSource fireSource;

  SourceFallbackManager({
    required this.dexSource,
    required this.fireSource,
  });

  /// Fetches chapters in Priority Order.
  /// 1. MangaFire
  /// 2. MangaDex
  Future<List<ChapterModel>> getChapters(MangaDetailsModel details) async {
    try {
      final fireChapters = await fireSource.fetchChapters(details);
      if (fireChapters.isNotEmpty) {
        return fireChapters;
      }
    } catch (_) {}

    // Fallback to MangaDex
    try {
      final dexChapters = await dexSource.fetchChapters(details);
      return dexChapters;
    } catch (_) {}

    return const [];
  }

  /// Fetches page urls for the specific chapter from the active source.
  Future<List<String>> getChapterPages({
    required String chapterId,
    required String source,
    required bool useDataSaver,
  }) async {
    if (source == 'mangafire') {
      return await fireSource.fetchPages(chapterId, useDataSaver: useDataSaver);
    } else {
      return await dexSource.fetchPages(chapterId, useDataSaver: useDataSaver);
    }
  }
}

// Global provider for SourceFallbackManager
final sourceFallbackManagerProvider = Provider<SourceFallbackManager>((ref) {
  final dexApi = ref.watch(mangaDexApiProvider);
  final fireApi = ref.watch(mangaFireApiProvider);
  return SourceFallbackManager(
    dexSource: MangaDexSource(dexApi),
    fireSource: MangaFireSource(fireApi),
  );
});
