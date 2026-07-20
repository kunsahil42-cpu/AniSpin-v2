import '../../features/manga_details/models/manga_details_model.dart';
import '../network/mangadex/mangadex_api.dart';
import 'jikan_field_utils.dart';

/// Merges AniList, MangaDex and Jikan manga detail data into one final model.
///
/// AniList is authoritative: [fillMissing] only fills fields AniList left
/// empty/null and never overwrites a valid value. [fromJikan] builds a complete
/// model when AniList is entirely unavailable.
class MangaMergeService {
  const MangaMergeService();

  bool hasGaps(MangaDetailsModel m) {
    return m.bannerImage.isEmpty ||
        m.coverImage.isEmpty ||
        m.description.isEmpty ||
        m.author.isEmpty ||
        m.averageScore == null ||
        m.chapters == null ||
        m.volumes == null ||
        m.genres.isEmpty;
  }

  MangaDetailsModel fillMissing(
    MangaDetailsModel m,
    Map<String, dynamic> j,
  ) {
    return MangaDetailsModel(
      id: m.id,
      idMal: m.idMal ?? JikanFieldUtils.intField(j, 'mal_id'),
      romajiTitle: m.romajiTitle,
      englishTitle: m.englishTitle,
      nativeTitle: m.nativeTitle,
      description: m.description.isEmpty
          ? JikanFieldUtils.string(j['synopsis'])
          : m.description,
      bannerImage: m.bannerImage.isEmpty
          ? JikanFieldUtils.banner(j)
          : m.bannerImage,
      coverImage: m.coverImage.isEmpty
          ? JikanFieldUtils.cover(j)
          : m.coverImage,
      averageScore: m.averageScore ?? JikanFieldUtils.score100(j),
      chapters: m.chapters ?? JikanFieldUtils.intField(j, 'chapters'),
      volumes: m.volumes ?? JikanFieldUtils.intField(j, 'volumes'),
      status: m.status ?? JikanFieldUtils.mediaStatus(j['status']),
      genres: m.genres.isEmpty ? JikanFieldUtils.genres(j) : m.genres,
      format: m.format ?? JikanFieldUtils.upper(j['type']),
      popularity: m.popularity ?? JikanFieldUtils.intField(j, 'members'),
      author: m.author.isEmpty ? JikanFieldUtils.firstAuthor(j) : m.author,
      isAdult: m.isAdult,
    );
  }

  MangaDetailsModel fillMissingFromMangaDex(
    MangaDetailsModel m,
    Map<String, dynamic> d,
    String dexId,
  ) {
    final data = d['data'] as Map<String, dynamic>? ?? {};
    final attrs = data['attributes'] as Map<String, dynamic>? ?? {};
    final titleMap = attrs['title'] as Map<String, dynamic>? ?? {};
    final descMap = attrs['description'] as Map<String, dynamic>? ?? {};

    final romaji = titleMap['ja-ro'] ?? titleMap['en'] ?? titleMap.values.firstOrNull ?? '';
    final english = titleMap['en'] ?? titleMap['en-us'] ?? m.englishTitle;
    
    final altTitles = attrs['altTitles'] as List? ?? [];
    String? nativeTitle;
    for (final alt in altTitles) {
      if (alt is Map) {
        if (nativeTitle == null && (alt.containsKey('ja') || alt.containsKey('jp'))) {
          nativeTitle = alt['ja'] ?? alt['jp'];
        }
      }
    }
    nativeTitle ??= m.nativeTitle;

    final description = descMap['en'] ?? descMap.values.firstOrNull ?? '';

    String? authorName;
    final included = d['included'] as List? ?? [];
    for (final inc in included) {
      if (inc is Map && inc['type'] == 'author') {
        final incAttrs = inc['attributes'] as Map?;
        if (incAttrs != null && incAttrs['name'] != null) {
          authorName = incAttrs['name'].toString();
          break;
        }
      }
    }

    String? coverUrl;
    for (final inc in included) {
      if (inc is Map && inc['type'] == 'cover_art') {
        final incAttrs = inc['attributes'] as Map?;
        if (incAttrs != null && incAttrs['fileName'] != null) {
          final fileName = incAttrs['fileName'].toString();
          coverUrl = 'https://uploads.mangadex.org/covers/$dexId/$fileName';
          break;
        }
      }
    }

    final lastChStr = attrs['lastChapter'] as String?;
    final chaptersCount = lastChStr != null ? double.tryParse(lastChStr)?.toInt() : null;

    final lastVolStr = attrs['lastVolume'] as String?;
    final volumesCount = lastVolStr != null ? double.tryParse(lastVolStr)?.toInt() : null;

    final statusStr = attrs['status'] as String?;
    final resolvedStatus = statusStr != null ? statusStr.toUpperCase() : null;

    final tags = attrs['tags'] as List? ?? [];
    final genresList = <String>[];
    for (final tag in tags) {
      if (tag is Map) {
        final tagAttrs = tag['attributes'] as Map?;
        if (tagAttrs != null) {
          final tagNames = tagAttrs['name'] as Map?;
          if (tagNames != null && tagNames['en'] != null) {
            genresList.add(tagNames['en'].toString());
          }
        }
      }
    }

    return MangaDetailsModel(
      id: m.id,
      idMal: m.idMal,
      romajiTitle: m.romajiTitle.isEmpty ? romaji : m.romajiTitle,
      englishTitle: m.englishTitle == null || m.englishTitle!.isEmpty ? english : m.englishTitle,
      nativeTitle: m.nativeTitle == null || m.nativeTitle!.isEmpty ? nativeTitle : m.nativeTitle,
      description: m.description.isEmpty ? description : m.description,
      bannerImage: m.bannerImage.isEmpty ? (coverUrl ?? '') : m.bannerImage,
      coverImage: m.coverImage.isEmpty ? (coverUrl ?? '') : m.coverImage,
      averageScore: m.averageScore,
      chapters: m.chapters ?? chaptersCount,
      volumes: m.volumes ?? volumesCount,
      status: m.status ?? resolvedStatus,
      genres: m.genres.isEmpty ? genresList : m.genres,
      format: m.format ?? (attrs['publicationDemographic'] ?? 'MANGA').toString().toUpperCase(),
      popularity: m.popularity,
      author: m.author.isEmpty ? (authorName ?? '') : m.author,
      isAdult: m.isAdult,
    );
  }

  MangaDetailsModel fromMangaDex(Map<String, dynamic> d, String dexId) {
    final data = d['data'] as Map<String, dynamic>? ?? {};
    final attrs = data['attributes'] as Map<String, dynamic>? ?? {};
    final titleMap = attrs['title'] as Map<String, dynamic>? ?? {};
    final descMap = attrs['description'] as Map<String, dynamic>? ?? {};

    final romaji = titleMap['ja-ro'] ?? titleMap['en'] ?? titleMap.values.firstOrNull ?? '';
    final english = titleMap['en'] ?? titleMap['en-us'];

    final altTitles = attrs['altTitles'] as List? ?? [];
    String? nativeTitle;
    for (final alt in altTitles) {
      if (alt is Map) {
        if (nativeTitle == null && (alt.containsKey('ja') || alt.containsKey('jp'))) {
          nativeTitle = alt['ja'] ?? alt['jp'];
        }
      }
    }

    final description = descMap['en'] ?? descMap.values.firstOrNull ?? '';

    String authorName = '';
    final included = d['included'] as List? ?? [];
    for (final inc in included) {
      if (inc is Map && inc['type'] == 'author') {
        final incAttrs = inc['attributes'] as Map?;
        if (incAttrs != null && incAttrs['name'] != null) {
          authorName = incAttrs['name'].toString();
          break;
        }
      }
    }

    String coverUrl = '';
    for (final inc in included) {
      if (inc is Map && inc['type'] == 'cover_art') {
        final incAttrs = inc['attributes'] as Map?;
        if (incAttrs != null && incAttrs['fileName'] != null) {
          final fileName = incAttrs['fileName'].toString();
          coverUrl = 'https://uploads.mangadex.org/covers/$dexId/$fileName';
          break;
        }
      }
    }

    final lastChStr = attrs['lastChapter'] as String?;
    final chaptersCount = lastChStr != null ? double.tryParse(lastChStr)?.toInt() : null;

    final lastVolStr = attrs['lastVolume'] as String?;
    final volumesCount = lastVolStr != null ? double.tryParse(lastVolStr)?.toInt() : null;

    final statusStr = attrs['status'] as String?;
    final resolvedStatus = statusStr != null ? statusStr.toUpperCase() : null;

    final tags = attrs['tags'] as List? ?? [];
    final genresList = <String>[];
    for (final tag in tags) {
      if (tag is Map) {
        final tagAttrs = tag['attributes'] as Map?;
        if (tagAttrs != null) {
          final tagNames = tagAttrs['name'] as Map?;
          if (tagNames != null && tagNames['en'] != null) {
            genresList.add(tagNames['en'].toString());
          }
        }
      }
    }

    final contentRating = attrs['contentRating'] as String?;
    final isAdult = contentRating == 'erotica' || contentRating == 'pornographic';

    return MangaDetailsModel(
      id: MangaDexApi.uuidToId(dexId),
      idMal: null,
      romajiTitle: romaji,
      englishTitle: english,
      nativeTitle: nativeTitle,
      description: description,
      bannerImage: coverUrl,
      coverImage: coverUrl,
      averageScore: null,
      chapters: chaptersCount,
      volumes: volumesCount,
      status: resolvedStatus,
      genres: genresList,
      format: (attrs['publicationDemographic'] ?? 'MANGA').toString().toUpperCase(),
      popularity: null,
      author: authorName,
      isAdult: isAdult,
    );
  }

  MangaDetailsModel fromJikan(Map<String, dynamic> j) {
    return MangaDetailsModel(
      id: JikanFieldUtils.intField(j, 'mal_id') ?? 0,
      idMal: JikanFieldUtils.intField(j, 'mal_id'),
      romajiTitle: JikanFieldUtils.string(j['title']),
      englishTitle: j['title_english'] as String?,
      nativeTitle: j['title_japanese'] as String?,
      description: JikanFieldUtils.string(j['synopsis']),
      bannerImage: JikanFieldUtils.banner(j),
      coverImage: JikanFieldUtils.cover(j),
      averageScore: JikanFieldUtils.score100(j),
      chapters: JikanFieldUtils.intField(j, 'chapters'),
      volumes: JikanFieldUtils.intField(j, 'volumes'),
      status: JikanFieldUtils.mediaStatus(j['status']),
      genres: JikanFieldUtils.genres(j),
      format: JikanFieldUtils.upper(j['type']),
      popularity: JikanFieldUtils.intField(j, 'members'),
      author: JikanFieldUtils.firstAuthor(j),
      isAdult: false,
    );
  }
}
