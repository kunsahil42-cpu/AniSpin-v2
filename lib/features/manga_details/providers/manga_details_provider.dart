import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/network/mangadex/mangadex_api.dart';
import '../../../core/database/translation_cache.dart';
import '../models/chapter_model.dart';
import '../models/manga_details_model.dart';
import '../repository/manga_details_repository.dart';

final mangaDetailsRepositoryProvider =
    Provider<MangaDetailsRepository>((ref) {
  return MangaDetailsRepository(
    dexApi: ref.watch(mangaDexApiProvider),
  );
});

final mangaDetailsProvider =
    FutureProvider.family<MangaDetailsModel, int>(
  (ref, mangaId) async {
    final repository = ref.read(
      mangaDetailsRepositoryProvider,
    );

    return repository.getMangaDetails(
      mangaId,
    );
  },
);

/// Provider to fetch real chapters list from MangaDex, with a graceful fallback to mock chapters if not found.
final mangaChaptersProvider = FutureProvider.family<List<ChapterModel>, int>(
  (ref, mangaId) async {
    final detailsAsync = ref.watch(mangaDetailsProvider(mangaId));
    final details = detailsAsync.valueOrNull;
    if (details == null) {
      return const [];
    }

    final dexApi = ref.read(mangaDexApiProvider);
    
    // Find all candidate MangaDex IDs using AniList/MAL details
    List<String> dexIds = await dexApi.findMangaDexIds(
      title: details.romajiTitle,
      aniListId: details.id,
      malId: details.idMal,
    );

    if (dexIds.isEmpty && details.englishTitle != null && details.englishTitle!.isNotEmpty) {
      dexIds = await dexApi.findMangaDexIds(
        title: details.englishTitle!,
        aniListId: details.id,
        malId: details.idMal,
      );
    }

    if (dexIds.isEmpty) {
      // Fallback: return mock chapters if not found on MangaDex
      final mockChapters = List.generate(
        details.chapters ?? 24,
        (i) => ChapterModel.mock(mangaId, i + 1),
      );
      mockChapters.sort((a, b) => a.number.compareTo(b.number));
      return mockChapters;
    }

    // Only ever a handful of authoritative (link-matched) candidates; cap the
    // scan so a fuzzy title fallback returning many IDs can't fan out into
    // dozens of full feed downloads. This bounds candidate MANGA, never chapters.
    const int maxCandidates = 6;
    final candidateIds =
        dexIds.length > maxCandidates ? dexIds.sublist(0, maxCandidates) : dexIds;

    final allDexIds = List<String>.from(candidateIds);
    final isColoredMap = <String, bool>{};

    for (final id in candidateIds) {
      try {
        final detailsData = await dexApi.getMangaDetails(id);
        
        final attrs = detailsData['data']?['attributes'] as Map? ?? {};
        final titleMap = attrs['title'] as Map? ?? {};
        final titleStr = (titleMap['en'] ?? titleMap.values.firstOrNull ?? '').toString().toLowerCase();
        final tagsList = attrs['tags'] as List? ?? [];
        final isColored = titleStr.contains('colored') ||
            titleStr.contains('coloured') ||
            tagsList.any((tag) {
              if (tag is! Map) return false;
              final nameMap = tag['attributes']?['name'] as Map? ?? {};
              final enName = (nameMap['en'] ?? '').toString().toLowerCase();
              return enName.contains('colored') || enName.contains('coloured');
            });
        
        isColoredMap[id] = isColored;

        final relationships = detailsData['data']?['relationships'] as List? ?? [];
        for (final rel in relationships) {
          if (rel is Map && rel['type'] == 'manga') {
            final relType = rel['related'] as String?;
            if (relType == 'colored' || relType == 'monochrome') {
              final relatedId = rel['id'] as String?;
              if (relatedId != null && !allDexIds.contains(relatedId)) {
                allDexIds.add(relatedId);
              }
            }
          }
        }
      } catch (_) {}
    }

    for (final id in allDexIds) {
      if (!isColoredMap.containsKey(id)) {
        try {
          final detailsData = await dexApi.getMangaDetails(id);
          final attrs = detailsData['data']?['attributes'] as Map? ?? {};
          final titleMap = attrs['title'] as Map? ?? {};
          final titleStr = (titleMap['en'] ?? titleMap.values.firstOrNull ?? '').toString().toLowerCase();
          final tagsList = attrs['tags'] as List? ?? [];
          final isColored = titleStr.contains('colored') ||
              titleStr.contains('coloured') ||
              tagsList.any((tag) {
                if (tag is! Map) return false;
                final nameMap = tag['attributes']?['name'] as Map? ?? {};
                final enName = (nameMap['en'] ?? '').toString().toLowerCase();
                return enName.contains('colored') || enName.contains('coloured');
              });
          isColoredMap[id] = isColored;
        } catch (_) {
          isColoredMap[id] = false;
        }
      }
    }

    final chaptersMap = <int, ChapterModel>{};
    final externalByNum = <int, bool>{};
    String? selectedDexId;

    for (final dexId in allDexIds) {
      try {
        final feed = await dexApi.getMangaFeed(dexId, const {'translatedLanguage[]': null});
        final isColored = isColoredMap[dexId] ?? false;

        for (final item in feed) {
          final id = item['id'] as String;
          final attrs = item['attributes'] as Map<String, dynamic>? ?? {};
          final chStr = attrs['chapter'] as String? ?? '';
          if (chStr.isEmpty) continue; // Skip chapters without numbers

          final externalUrl = attrs['externalUrl'] as String?;
          final isExternal = externalUrl != null;

          int? parsed = int.tryParse(chStr);
          if (parsed == null) {
            final d = double.tryParse(chStr);
            if (d != null) {
              parsed = d.toInt();
            }
          }
          final chNum = parsed ?? 0;
          final rawTitle = attrs['title'] as String? ?? '';
          final title = rawTitle.isNotEmpty
              ? 'Chapter $chNum — $rawTitle'
              : 'Chapter $chNum';

          final publishAtStr = attrs['publishAt'] as String? ?? '';
          String dateStr = '';
          if (publishAtStr.isNotEmpty) {
            try {
              final dt = DateTime.parse(publishAtStr);
              dateStr = '${dt.day}/${dt.month}/${dt.year}';
            } catch (_) {}
          }

          final lang = (attrs['translatedLanguage'] as String? ?? 'en').toUpperCase();

          String scanGroup = 'MangaDex';
          final relationships = item['relationships'] as List? ?? const [];
          for (final rel in relationships) {
            if (rel is Map && rel['type'] == 'scanlation_group') {
              final relAttrs = rel['attributes'] as Map?;
              final name = relAttrs?['name'];
              if (name is String && name.isNotEmpty) {
                scanGroup = name;
                break;
              }
            }
          }

          final finalColored = isColored ||
              scanGroup.toLowerCase().contains('color') ||
              scanGroup.toLowerCase().contains('coloured');

          final chapterModel = ChapterModel(
            id: id,
            number: chNum,
            title: title,
            scanGroup: scanGroup,
            date: dateStr,
            language: lang,
            pages: const [],
            isAutoTranslate: lang.toUpperCase() != 'EN',
            isColored: finalColored,
          );

          final existing = chaptersMap[chNum];
          final existingExternal = externalByNum[chNum] ?? false;

          if (existing == null ||
              _shouldReplace(existing, existingExternal, chapterModel, isExternal)) {
            chaptersMap[chNum] = chapterModel;
            externalByNum[chNum] = isExternal;
            selectedDexId = dexId;
          }
        }
      } catch (_) {}
    }

    if (chaptersMap.isEmpty) {
      final mockChapters = List.generate(
        details.chapters ?? 24,
        (i) => ChapterModel.mock(mangaId, i + 1),
      );
      mockChapters.sort((a, b) => a.number.compareTo(b.number));
      return mockChapters;
    }

    if (selectedDexId != null) {
      MangaDexApi.uuidToId(selectedDexId);
      MangaDexApi.registerMapping(details.id, selectedDexId);
    }

    final selectedChapters = chaptersMap.values.toList();
    selectedChapters.sort((a, b) => a.number.compareTo(b.number));
    return selectedChapters;
  }
);

double _getChapterScore(ChapterModel ch, bool isExternal) {
  final double hostPenalty = isExternal ? 100.0 : 0.0;
  final bool isEnglish = ch.language.toUpperCase() == 'EN';
  
  int typePriority;
  if (ch.isColored && isEnglish) {
    typePriority = 1;
  } else if (ch.isColored && !isEnglish) {
    typePriority = 2;
  } else if (!ch.isColored && isEnglish) {
    typePriority = 3;
  } else {
    typePriority = 4;
  }

  int langPriority;
  final l = ch.language.toUpperCase();
  if (l == 'EN') {
    langPriority = 0;
  } else if (l == 'JA') {
    langPriority = 1;
  } else if (l == 'KO') {
    langPriority = 2;
  } else if (l == 'ZH' || l.startsWith('ZH-')) {
    langPriority = 3;
  } else {
    langPriority = 4;
  }

  return hostPenalty + (typePriority * 10) + langPriority;
}

bool _shouldReplace(ChapterModel existing, bool existingExternal, ChapterModel candidate, bool candidateExternal) {
  final existingScore = _getChapterScore(existing, existingExternal);
  final candidateScore = _getChapterScore(candidate, candidateExternal);
  return candidateScore < existingScore;
}

/// Argument helper for chapter pages provider
class ChapterPagesArg {
  final int mangaId;
  final int chapterNumber;

  ChapterPagesArg({
    required this.mangaId,
    required this.chapterNumber,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterPagesArg &&
          runtimeType == other.runtimeType &&
          mangaId == other.mangaId &&
          chapterNumber == other.chapterNumber;

  @override
  int get hashCode => mangaId.hashCode ^ chapterNumber.hashCode;
}

/// Provider to fetch pages list for a specific chapter
final mangaChapterPagesProvider = FutureProvider.autoDispose.family<List<String>, ChapterPagesArg>(
  (ref, arg) async {
    final chaptersAsync = await ref.watch(mangaChaptersProvider(arg.mangaId).future);
    
    // Find the chapter with the matching number
    final chapterIndex = chaptersAsync.indexWhere((c) => c.number == arg.chapterNumber);
    if (chapterIndex == -1) {
      throw AppFailure.notFound('Chapter ${arg.chapterNumber} not found.');
    }
    
    final chapter = chaptersAsync[chapterIndex];

    if (chapter.id != null) {
      if (chapter.isAutoTranslate) {
        final cached = await TranslationCache().get(chapter.id!);
        if (cached != null) {
          return cached;
        }
      }
      final dexApi = ref.read(mangaDexApiProvider);
      return await dexApi.getChapterPages(chapter.id!);
    }

    // Fallback to mock pages ONLY if the chapter has no MangaDex ID (e.g. mock manga)
    final mockChapter = ChapterModel.mock(arg.mangaId, arg.chapterNumber);
    return mockChapter.pages;
  }
);