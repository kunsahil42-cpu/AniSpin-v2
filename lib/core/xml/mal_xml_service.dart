import 'dart:convert';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import '../../features/tracker/models/watch_progress.dart';
import '../../features/tracker/models/reading_progress.dart';

class MalXmlService {
  static String exportToXml({
    required List<WatchProgress> animeList,
    required List<ReadingProgress> mangaList,
  }) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('myanimelist', nest: () {
      builder.element('myinfo', nest: () {
        builder.element('user_name', nest: 'AniSpin User');
        builder.element('user_export_type', nest: '1');
      });

      // Write anime entries
      for (final anime in animeList) {
        builder.element('anime', nest: () {
          builder.element('series_animedb_id', nest: (anime.malId ?? 0).toString());
          builder.element('series_title', nest: () {
            builder.text(anime.romajiTitle);
          });
          builder.element('my_watched_episodes', nest: anime.lastWatchedEpisode.toString());
          builder.element('my_score', nest: (anime.score ?? 0).toString());
          builder.element('my_status', nest: _mapStatusToMal(anime.status, isManga: false));
          if (anime.dateStarted != null) {
            builder.element('my_start_date', nest: anime.dateStarted!.toIso8601String().substring(0, 10));
          }
          if (anime.dateFinished != null) {
            builder.element('my_finish_date', nest: anime.dateFinished!.toIso8601String().substring(0, 10));
          }
          builder.element('my_comments', nest: () {
            builder.text(anime.notes ?? '');
          });
        });
      }

      // Write manga entries
      for (final manga in mangaList) {
        builder.element('manga', nest: () {
          builder.element('series_mangadb_id', nest: manga.mangaId.toString()); // mangaId functions as MAL ID locally
          builder.element('series_title', nest: () {
            builder.text(manga.romajiTitle);
          });
          builder.element('my_read_chapters', nest: manga.lastReadChapter.toString());
          builder.element('my_read_volumes', nest: manga.lastReadVolume.toString());
          builder.element('my_score', nest: (manga.score ?? 0).toString());
          builder.element('my_status', nest: _mapStatusToMal(manga.status, isManga: true));
          if (manga.dateStarted != null) {
            builder.element('my_start_date', nest: manga.dateStarted!.toIso8601String().substring(0, 10));
          }
          if (manga.dateFinished != null) {
            builder.element('my_finish_date', nest: manga.dateFinished!.toIso8601String().substring(0, 10));
          }
          builder.element('my_comments', nest: () {
            builder.text(manga.notes ?? '');
          });
        });
      }
    });

    return builder.buildDocument().toXmlString(pretty: true);
  }

  static Map<String, List<dynamic>> parseXml(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final animeList = <WatchProgress>[];
    final mangaList = <ReadingProgress>[];

    // Parse anime
    final animeNodes = document.findAllElements('anime');
    for (final node in animeNodes) {
      final malIdStr = node.findElements('series_animedb_id').firstOrNull?.innerText ?? '0';
      final malId = int.tryParse(malIdStr) ?? 0;
      final title = node.findElements('series_title').firstOrNull?.innerText ?? 'Unknown Anime';
      final watchedEp = int.tryParse(node.findElements('my_watched_episodes').firstOrNull?.innerText ?? '0') ?? 0;
      final score = int.tryParse(node.findElements('my_score').firstOrNull?.innerText ?? '0') ?? 0;
      final status = node.findElements('my_status').firstOrNull?.innerText ?? 'Plan to Watch';
      final notes = node.findElements('my_comments').firstOrNull?.innerText;
      
      final startDateStr = node.findElements('my_start_date').firstOrNull?.innerText;
      final endDateStr = node.findElements('my_finish_date').firstOrNull?.innerText;

      final progress = WatchProgress()
        ..animeId = -malId // Temporary placeholder until mapped online
        ..malId = malId
        ..romajiTitle = title
        ..coverImage = ""
        ..lastWatchedEpisode = watchedEp
        ..lastWatchedPosition = 0
        ..lastWatchedDuration = 0
        ..watchPercentage = 100.0
        ..lastWatchedSource = "MAL Import"
        ..lastWatchedAudio = "sub"
        ..lastWatchedAt = DateTime.now()
        ..status = _mapStatusFromMal(status, isManga: false)
        ..score = score
        ..notes = notes
        ..dateStarted = startDateStr != null && startDateStr != "0000-00-00" ? DateTime.tryParse(startDateStr) : null
        ..dateFinished = endDateStr != null && endDateStr != "0000-00-00" ? DateTime.tryParse(endDateStr) : null;

      // Fill completed episodes list
      progress.completedEpisodes = List<int>.generate(watchedEp, (i) => i + 1);

      animeList.add(progress);
    }

    // Parse manga
    final mangaNodes = document.findAllElements('manga');
    for (final node in mangaNodes) {
      final malIdStr = node.findElements('series_mangadb_id').firstOrNull?.innerText ?? '0';
      final malId = int.tryParse(malIdStr) ?? 0;
      final title = node.findElements('series_title').firstOrNull?.innerText ?? 'Unknown Manga';
      final readCh = int.tryParse(node.findElements('my_read_chapters').firstOrNull?.innerText ?? '0') ?? 0;
      final readVol = int.tryParse(node.findElements('my_read_volumes').firstOrNull?.innerText ?? '0') ?? 0;
      final score = int.tryParse(node.findElements('my_score').firstOrNull?.innerText ?? '0') ?? 0;
      final status = node.findElements('my_status').firstOrNull?.innerText ?? 'Plan to Read';
      final notes = node.findElements('my_comments').firstOrNull?.innerText;

      final startDateStr = node.findElements('my_start_date').firstOrNull?.innerText;
      final endDateStr = node.findElements('my_finish_date').firstOrNull?.innerText;

      final progress = ReadingProgress()
        ..mangaId = malId // Manga local ID acts as MAL ID
        ..romajiTitle = title
        ..coverImage = ""
        ..lastReadChapter = readCh
        ..lastReadPage = 0
        ..readingPercentage = 100.0
        ..lastReadAt = DateTime.now()
        ..status = _mapStatusFromMal(status, isManga: true)
        ..score = score
        ..notes = notes
        ..lastReadVolume = readVol
        ..dateStarted = startDateStr != null && startDateStr != "0000-00-00" ? DateTime.tryParse(startDateStr) : null
        ..dateFinished = endDateStr != null && endDateStr != "0000-00-00" ? DateTime.tryParse(endDateStr) : null;

      progress.completedChapters = List<int>.generate(readCh, (i) => i + 1);

      mangaList.add(progress);
    }

    return {
      'anime': animeList,
      'manga': mangaList,
    };
  }

  static Future<Map<String, dynamic>?> resolveAniListMetadata(int malId, {required bool isManga}) async {
    final type = isManga ? "MANGA" : "ANIME";
    final query = '''
      query (\$idMal: Int) {
        Media (idMal: \$idMal, type: $type) {
          id
          title {
            romaji
            english
          }
          coverImage {
            large
          }
          bannerImage
          episodes
          chapters
          volumes
          status
          genres
          studios {
            nodes {
              name
            }
          }
          staff {
            nodes {
              name {
                full
              }
            }
          }
          season
          seasonYear
        }
      }
    ''';

    try {
      final response = await http.post(
        Uri.parse('https://graphql.anilist.co'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'query': query,
          'variables': {'idMal': malId},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['Media'];
      }
    } catch (_) {}
    return null;
  }

  // ==========================================
  // STATUS MAPPINGS
  // ==========================================

  static String _mapStatusToMal(String? status, {required bool isManga}) {
    if (status == null) return isManga ? 'Plan to Read' : 'Plan to Watch';
    final s = status.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
    if (s == 'watching' || s == 'reading') return isManga ? 'Reading' : 'Watching';
    if (s == 'completed') return 'Completed';
    if (s == 'onhold' || s == 'paused') return 'On-Hold';
    if (s == 'dropped') return 'Dropped';
    return isManga ? 'Plan to Read' : 'Plan to Watch';
  }

  static String _mapStatusFromMal(String malStatus, {required bool isManga}) {
    final s = malStatus.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
    if (s == 'watching' || s == 'reading') return isManga ? 'Reading' : 'Watching';
    if (s == 'completed') return 'Completed';
    if (s == 'onhold') return 'On Hold';
    if (s == 'dropped') return 'Dropped';
    return isManga ? 'Plan To Read' : 'Plan To Watch';
  }
}
