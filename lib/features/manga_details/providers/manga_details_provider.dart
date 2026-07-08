import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/chapter_cache.dart';
import '../../../core/network/mangadex/mangadex_api.dart';
import '../models/manga_details_model.dart';
import '../repository/manga_details_repository.dart';

import '../models/chapter_model.dart';

// Repository provider that depends on MangaDexApi
final mangaDetailsRepositoryProvider = Provider<MangaDetailsRepository>((ref) {
  final mangaDexApi = ref.read(mangaDexApiProvider);
  return MangaDetailsRepository(dexApi: mangaDexApi);
});

// Provider for manga details that returns a Future<MangaDetailsModel>
final mangaDetailsProvider =
    FutureProvider.family<MangaDetailsModel, int>((ref, mangaId) {
  final repository = ref.read(mangaDetailsRepositoryProvider);
  return repository.getMangaDetails(mangaId);
});

String _cleanTitle(String title) {
  String cleaned = title.replaceAll(RegExp(r'\([^)]*\)'), '').replaceAll(RegExp(r'\[[^\]]*\]'), '');
  cleaned = cleaned.replaceAll(RegExp(r'[:\-!~\?\.]'), ' ');
  cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
  return cleaned;
}

class MangaChaptersNotifier extends FamilyAsyncNotifier<List<ChapterModel>, int> {
  @override
  FutureOr<List<ChapterModel>> build(int mangaId) async {
    // 1. Try to load cached chapters first
    final cached = await ChapterCache.getChapters(mangaId);
    if (cached != null && cached.isNotEmpty) {
      // Trigger background update asynchronously
      _refreshChaptersInBackground(mangaId);
      return cached;
    }

    // 2. If no cache, fetch from network
    return _fetchAndCacheChapters(mangaId);
  }

  void _refreshChaptersInBackground(int mangaId) {
    _fetchAndCacheChapters(mangaId).catchError((e) {
      print('MangaChaptersNotifier: Background refresh failed: $e');
      return const <ChapterModel>[];
    });
  }

  Future<List<ChapterModel>> _fetchAndCacheChapters(int mangaId) async {
    final chapters = await _fetchFromNetwork(mangaId);
    await ChapterCache.saveChapters(mangaId, chapters);
    state = AsyncValue.data(chapters);
    return chapters;
  }

  Future<List<ChapterModel>> _fetchFromNetwork(int mangaId) async {
    final mangaDex = ref.read(mangaDexApiProvider);
    
    // Resolve MangaDetails first to obtain lookup metadata
    final details = await ref.read(mangaDetailsProvider(mangaId).future);
    
    final Set<String> allDexIds = {};

    // Try 1: Romaji title
    final romajiIds = await mangaDex.findMangaDexIds(
      title: details.romajiTitle,
      aniListId: details.id,
      malId: details.idMal,
    );
    allDexIds.addAll(romajiIds);

    // Try 2: English title fallback
    if (details.englishTitle != null && details.englishTitle!.isNotEmpty) {
      final englishIds = await mangaDex.findMangaDexIds(
        title: details.englishTitle!,
        aniListId: details.id,
        malId: details.idMal,
      );
      allDexIds.addAll(englishIds);
    }

    // Try 3: Native title fallback (Korean/Japanese/Chinese)
    if (details.nativeTitle != null && details.nativeTitle!.isNotEmpty) {
      final nativeIds = await mangaDex.findMangaDexIds(
        title: details.nativeTitle!,
        aniListId: details.id,
        malId: details.idMal,
      );
      allDexIds.addAll(nativeIds);
    }

    // Try 4: Cleaned Romaji title fallback
    if (allDexIds.isEmpty) {
      final cleanedRomaji = _cleanTitle(details.romajiTitle);
      if (cleanedRomaji != details.romajiTitle && cleanedRomaji.isNotEmpty) {
        final cleanedIds = await mangaDex.findMangaDexIds(
          title: cleanedRomaji,
          aniListId: details.id,
          malId: details.idMal,
        );
        allDexIds.addAll(cleanedIds);
      }
    }

    // Try 5: Cleaned English title fallback
    if (details.englishTitle != null && details.englishTitle!.isNotEmpty) {
      final cleanedEnglish = _cleanTitle(details.englishTitle!);
      if (cleanedEnglish != details.englishTitle && cleanedEnglish.isNotEmpty) {
        final cleanedIds = await mangaDex.findMangaDexIds(
          title: cleanedEnglish,
          aniListId: details.id,
          malId: details.idMal,
        );
        allDexIds.addAll(cleanedIds);
      }
    }

    // Try 6: Cleaned Native title fallback
    if (details.nativeTitle != null && details.nativeTitle!.isNotEmpty) {
      final cleanedNative = _cleanTitle(details.nativeTitle!);
      if (cleanedNative != details.nativeTitle && cleanedNative.isNotEmpty) {
        final cleanedIds = await mangaDex.findMangaDexIds(
          title: cleanedNative,
          aniListId: details.id,
          malId: details.idMal,
        );
        allDexIds.addAll(cleanedIds);
      }
    }
    
    // In-memory registered mapping fallback
    if (allDexIds.isEmpty) {
      final cachedUuid = MangaDexApi.idToUuid(mangaId);
      if (cachedUuid != null) {
        allDexIds.add(cachedUuid);
      }
    }

    if (allDexIds.isEmpty) {
      print('mangaChaptersProvider: Failed to resolve any MangaDex IDs for mangaId: $mangaId');
      return const [];
    }

    print('mangaChaptersProvider: Resolved MangaDex IDs: $allDexIds for mangaId: $mangaId');

    final List<ChapterModel> allChapters = [];

    for (final dexId in allDexIds) {
      try {
        final feed = await mangaDex.getMangaFeed(dexId, {
          'translatedLanguage[]': null,
        });
        
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
          );
        }).toList();

        allChapters.addAll(mapped);
      } catch (e) {
        print('mangaChaptersProvider: Failed to fetch feed for dexId: $dexId. Error: $e');
      }
    }

    // Group chapters by number to select the best available version
    final Map<int, List<ChapterModel>> grouped = {};
    for (final chapter in allChapters) {
      grouped.putIfAbsent(chapter.number, () => []).add(chapter);
    }

    final List<ChapterModel> selectedChapters = [];
    final languagePriority = ['PT', 'ES', 'JA', 'FR', 'DE', 'ZH', 'KO', 'RU', 'IT'];

    for (final entry in grouped.entries) {
      final list = entry.value;

      final versions = List<ChapterModel>.from(list);
      versions.sort((a, b) {
        // 1. Prefer internal versions with actual pages
        if (!a.isExternal && b.isExternal) return -1;
        if (a.isExternal && !b.isExternal) return 1;

        // 2. Prefer English
        final aIsEn = a.language == 'EN';
        final bIsEn = b.language == 'EN';
        if (aIsEn && !bIsEn) return -1;
        if (!aIsEn && bIsEn) return 1;

        // 3. Language priority
        final aIndex = languagePriority.indexOf(a.language);
        final bIndex = languagePriority.indexOf(b.language);
        if (aIndex != -1 && bIndex != -1) return aIndex.compareTo(bIndex);
        if (aIndex != -1) return -1;
        if (bIndex != -1) return 1;

        return a.language.compareTo(b.language);
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
        ),
      );
    }

    return selectedChapters;
  }
}

final mangaChaptersProvider =
    AsyncNotifierProvider.family<MangaChaptersNotifier, List<ChapterModel>, int>(() {
  return MangaChaptersNotifier();
});