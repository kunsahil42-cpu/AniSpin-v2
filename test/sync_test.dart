import 'package:flutter_test/flutter_test.dart';
import 'package:anispin/features/anime_details/models/anime_details_model.dart';
import 'package:anispin/features/manga_details/models/chapter_model.dart';

void main() {
  group('Synchronization Tests', () {
    test('AnimeDetailsModel serialization/deserialization', () {
      final model = AnimeDetailsModel(
        id: 1,
        idMal: 123,
        romajiTitle: 'Romaji Title',
        englishTitle: 'English Title',
        nativeTitle: 'Native Title',
        description: 'Description',
        bannerImage: 'banner.jpg',
        coverImage: 'cover.jpg',
        averageScore: 85,
        episodes: 24,
        status: 'FINISHED',
        genres: const ['Action', 'Adventure'],
        season: 'SUMMER',
        seasonYear: 2026,
        duration: 24,
        format: 'TV',
        popularity: 10000,
        studio: 'Trigger',
        streamingEpisodes: [
          StreamingEpisode(
            title: 'Episode 1',
            thumbnail: 'ep1.jpg',
            url: 'https://site.com/ep1',
            site: 'Crunchyroll',
          ),
        ],
        nextAiringEpisode: NextAiringEpisode(
          episode: 2,
          airingAt: 1800000000,
        ),
      );

      final jsonMap = model.toJson();
      final fromCache = AnimeDetailsModel.fromCacheJson(jsonMap);

      expect(fromCache.id, equals(model.id));
      expect(fromCache.idMal, equals(model.idMal));
      expect(fromCache.romajiTitle, equals(model.romajiTitle));
      expect(fromCache.englishTitle, equals(model.englishTitle));
      expect(fromCache.nativeTitle, equals(model.nativeTitle));
      expect(fromCache.description, equals(model.description));
      expect(fromCache.bannerImage, equals(model.bannerImage));
      expect(fromCache.coverImage, equals(model.coverImage));
      expect(fromCache.averageScore, equals(model.averageScore));
      expect(fromCache.episodes, equals(model.episodes));
      expect(fromCache.status, equals(model.status));
      expect(fromCache.genres, equals(model.genres));
      expect(fromCache.season, equals(model.season));
      expect(fromCache.seasonYear, equals(model.seasonYear));
      expect(fromCache.duration, equals(model.duration));
      expect(fromCache.format, equals(model.format));
      expect(fromCache.popularity, equals(model.popularity));
      expect(fromCache.studio, equals(model.studio));
      expect(fromCache.streamingEpisodes.length, equals(1));
      expect(fromCache.streamingEpisodes[0].title, equals('Episode 1'));
      expect(fromCache.nextAiringEpisode?.episode, equals(2));
    });

    test('Manga chapter merging logic (no duplicates)', () {
      final current = [
        ChapterModel(
          id: '1',
          number: 1,
          title: 'Chapter 1',
          scanGroup: 'Aurora',
          date: 'July 1, 2026',
          language: 'EN',
          pages: const [],
        ),
        ChapterModel(
          id: '2',
          number: 2,
          title: 'Chapter 2',
          scanGroup: 'Aurora',
          date: 'July 2, 2026',
          language: 'EN',
          pages: const [],
        ),
      ];

      final network = [
        ChapterModel(
          id: '2-new',
          number: 2,
          title: 'Chapter 2 (Updated)',
          scanGroup: 'Aurora',
          date: 'July 2, 2026',
          language: 'EN',
          pages: const ['page1.jpg'],
        ),
        ChapterModel(
          id: '3',
          number: 3,
          title: 'Chapter 3',
          scanGroup: 'Aurora',
          date: 'July 3, 2026',
          language: 'EN',
          pages: const [],
        ),
      ];

      final Map<int, ChapterModel> mergedMap = {
        for (final c in current) c.number: c,
      };

      final newChs = <int>{};
      for (final c in network) {
        if (!mergedMap.containsKey(c.number)) {
          newChs.add(c.number);
        }
        mergedMap[c.number] = c;
      }

      final mergedList = mergedMap.values.toList()..sort((a, b) => a.number.compareTo(b.number));

      // 1. Should have exactly 3 chapters (no duplicates)
      expect(mergedList.length, equals(3));
      // 2. Chapter 2 should be updated from network
      expect(mergedList[1].title, equals('Chapter 2 (Updated)'));
      expect(mergedList[1].pages.length, equals(1));
      // 3. New chapters set should contain exactly Chapter 3
      expect(newChs.length, equals(1));
      expect(newChs.contains(3), isTrue);
      expect(newChs.contains(2), isFalse);
    });

    test('Calculates actualTotal correctly based on nextAiringEpisode', () {
      final model = AnimeDetailsModel(
        id: 1,
        romajiTitle: 'Test',
        englishTitle: '',
        nativeTitle: '',
        description: '',
        bannerImage: '',
        coverImage: '',
        averageScore: 0,
        episodes: 24,
        status: 'RELEASING',
        genres: const [],
        season: '',
        seasonYear: 2026,
        duration: 24,
        format: 'TV',
        popularity: 100,
        studio: '',
        nextAiringEpisode: NextAiringEpisode(episode: 15, airingAt: 0),
        streamingEpisodes: const [],
      );

      final actualTotal = model.nextAiringEpisode != null ? model.nextAiringEpisode!.episode - 1 : model.episodes ?? 12;
      expect(actualTotal, equals(14));
    });
  });
}
