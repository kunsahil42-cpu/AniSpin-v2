import '../../features/anime_details/models/anime_details_model.dart';
import 'jikan_field_utils.dart';

/// Merges AniList and Jikan anime detail data into one final model.
///
/// The UI never knows which API supplied a field. AniList is authoritative:
/// [fillMissing] only fills fields that AniList left empty/null, and never
/// overwrites a valid AniList value. [fromJikan] builds a complete model when
/// AniList is entirely unavailable.
class AnimeMergeService {
  const AnimeMergeService();

  /// True when at least one displayed field is missing and worth back-filling
  /// from Jikan (keeps us from making an unnecessary network call).
  bool hasGaps(AnimeDetailsModel a) {
    return a.bannerImage.isEmpty ||
        a.coverImage.isEmpty ||
        a.description.isEmpty ||
        a.studio.isEmpty ||
        a.averageScore == null ||
        a.episodes == null ||
        a.genres.isEmpty;
  }

  AnimeDetailsModel fillMissing(
    AnimeDetailsModel a,
    Map<String, dynamic> j,
  ) {
    return AnimeDetailsModel(
      id: a.id,
      idMal: a.idMal ?? JikanFieldUtils.intField(j, 'mal_id'),
      romajiTitle: a.romajiTitle,
      englishTitle: a.englishTitle,
      nativeTitle: a.nativeTitle,
      description: a.description.isEmpty
          ? JikanFieldUtils.string(j['synopsis'])
          : a.description,
      bannerImage: a.bannerImage.isEmpty
          ? JikanFieldUtils.banner(j)
          : a.bannerImage,
      coverImage: a.coverImage.isEmpty
          ? JikanFieldUtils.cover(j)
          : a.coverImage,
      averageScore: a.averageScore ?? JikanFieldUtils.score100(j),
      episodes: a.episodes ?? JikanFieldUtils.intField(j, 'episodes'),
      status: a.status ?? JikanFieldUtils.mediaStatus(j['status']),
      genres: a.genres.isEmpty ? JikanFieldUtils.genres(j) : a.genres,
      season: a.season ?? JikanFieldUtils.upper(j['season']),
      seasonYear: a.seasonYear ?? JikanFieldUtils.intField(j, 'year'),
      duration: a.duration ?? JikanFieldUtils.durationMinutes(j),
      format: a.format ?? JikanFieldUtils.upper(j['type']),
      popularity: a.popularity ?? JikanFieldUtils.intField(j, 'members'),
      studio: a.studio.isEmpty ? JikanFieldUtils.firstStudio(j) : a.studio,
      streamingEpisodes: a.streamingEpisodes,
      nextAiringEpisode: a.nextAiringEpisode,
      isAdult: a.isAdult,
    );
  }

  AnimeDetailsModel fromJikan(Map<String, dynamic> j) {
    final rating = j['rating'] as String?;
    final isAdult = rating != null &&
        (rating.toLowerCase().contains('rx') || rating.toLowerCase().contains('hentai'));

    return AnimeDetailsModel(
      id: JikanFieldUtils.intField(j, 'mal_id') ?? 0,
      idMal: JikanFieldUtils.intField(j, 'mal_id'),
      romajiTitle: JikanFieldUtils.string(j['title']),
      englishTitle: j['title_english'] as String?,
      nativeTitle: j['title_japanese'] as String?,
      description: JikanFieldUtils.string(j['synopsis']),
      bannerImage: JikanFieldUtils.banner(j),
      coverImage: JikanFieldUtils.cover(j),
      averageScore: JikanFieldUtils.score100(j),
      episodes: JikanFieldUtils.intField(j, 'episodes'),
      status: JikanFieldUtils.mediaStatus(j['status']),
      genres: JikanFieldUtils.genres(j),
      season: JikanFieldUtils.upper(j['season']),
      seasonYear: JikanFieldUtils.intField(j, 'year'),
      duration: JikanFieldUtils.durationMinutes(j),
      format: JikanFieldUtils.upper(j['type']),
      popularity: JikanFieldUtils.intField(j, 'members'),
      studio: JikanFieldUtils.firstStudio(j),
      streamingEpisodes: const [],
      nextAiringEpisode: null,
      isAdult: isAdult,
    );
  }
}
