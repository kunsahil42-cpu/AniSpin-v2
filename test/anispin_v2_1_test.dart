import 'package:flutter_test/flutter_test.dart';
import 'package:anispin/core/update/update_checker.dart';
import 'package:anispin/core/xml/mal_xml_service.dart';
import 'package:anispin/features/tracker/models/watch_progress.dart';
import 'package:anispin/features/tracker/models/reading_progress.dart';

void main() {
  group('Version Comparison Tests', () {
    test('Version checker matches version cases correctly', () {
      // Hotfix update
      expect(UpdateChecker.isNewerVersion("v2.1.0", "v2.1.1"), isTrue);
      expect(UpdateChecker.isNewerVersion("v2.1.1", "v2.1.0"), isFalse);

      // Minor update
      expect(UpdateChecker.isNewerVersion("v2.1.0", "v2.2.0"), isTrue);
      expect(UpdateChecker.isNewerVersion("v2.2.0", "v2.1.0"), isFalse);

      // Major update
      expect(UpdateChecker.isNewerVersion("v2.1.0", "v3.0.0"), isTrue);
      expect(UpdateChecker.isNewerVersion("v3.0.0", "v2.1.0"), isFalse);

      // Same versions
      expect(UpdateChecker.isNewerVersion("v2.1.0", "v2.1.0"), isFalse);
      expect(UpdateChecker.isNewerVersion("2.1.0", "v2.1.0"), isFalse);
    });
  });

  group('MAL XML Import/Export Tests', () {
    test('XML Export formats and XML Import parses correctly', () {
      final animeList = [
        WatchProgress()
          ..animeId = 1
          ..malId = 123
          ..romajiTitle = "Anime Title"
          ..lastWatchedEpisode = 12
          ..score = 8
          ..status = "Watching"
          ..notes = "Great anime"
      ];

      final mangaList = [
        ReadingProgress()
          ..mangaId = 456
          ..romajiTitle = "Manga Title"
          ..lastReadChapter = 5
          ..lastReadVolume = 1
          ..score = 9
          ..status = "Reading"
          ..notes = "Engaging plot"
      ];

      final exportedXml = MalXmlService.exportToXml(
        animeList: animeList,
        mangaList: mangaList,
      );

      // Verify structure contains key XML elements
      expect(exportedXml.contains('<myanimelist>'), isTrue);
      expect(exportedXml.contains('<anime>'), isTrue);
      expect(exportedXml.contains('<manga>'), isTrue);
      expect(exportedXml.contains('Anime Title'), isTrue);
      expect(exportedXml.contains('Manga Title'), isTrue);
      expect(exportedXml.contains('<my_watched_episodes>12</my_watched_episodes>'), isTrue);
      expect(exportedXml.contains('<my_read_chapters>5</my_read_chapters>'), isTrue);

      final parsed = MalXmlService.parseXml(exportedXml);
      final parsedAnime = parsed['anime'] as List<WatchProgress>;
      final parsedManga = parsed['manga'] as List<ReadingProgress>;

      expect(parsedAnime.length, equals(1));
      expect(parsedAnime[0].malId, equals(123));
      expect(parsedAnime[0].romajiTitle, equals("Anime Title"));
      expect(parsedAnime[0].lastWatchedEpisode, equals(12));
      expect(parsedAnime[0].score, equals(8));
      expect(parsedAnime[0].status, equals("Watching"));
      expect(parsedAnime[0].notes, equals("Great anime"));

      expect(parsedManga.length, equals(1));
      expect(parsedManga[0].mangaId, equals(456));
      expect(parsedManga[0].romajiTitle, equals("Manga Title"));
      expect(parsedManga[0].lastReadChapter, equals(5));
      expect(parsedManga[0].lastReadVolume, equals(1));
      expect(parsedManga[0].score, equals(9));
      expect(parsedManga[0].status, equals("Reading"));
      expect(parsedManga[0].notes, equals("Engaging plot"));
    });
  });
}
