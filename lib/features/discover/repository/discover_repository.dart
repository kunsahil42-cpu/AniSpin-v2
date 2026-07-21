import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/error/app_failure.dart';
import '../../../core/network/mock_data_helper.dart';
import '../data/discover_api.dart';
import '../enums/discover_mode.dart';
import '../models/discover_anime_model.dart';
import '../models/discover_manga_model.dart';
import '../models/discover_filters.dart';
import '../models/discover_media_model.dart';

class DiscoverRepository {
  final DiscoverApi _api = DiscoverApi();

  int _dailyPage() {
    final now = DateTime.now();
    final seed =
        now.year * 1000 +
        now.month * 100 +
        now.day;

    return Random(seed).nextInt(500) + 1;
  }

  Future<DiscoverAnimeModel> getAnimeOfTheDay() async {
    try {
      final result = await _api.getAnimeOfTheDay(
        _dailyPage(),
      );

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final media = result.data?['Page']?['media'];

      if (media == null || media.isEmpty) {
        throw AppFailure.notFound('Anime not found');
      }

      return DiscoverAnimeModel.fromJson(
        media.first,
      );
    } catch (e) {
      // Fallback to mock Anime of the Day if API fails
      return MockDataHelper.getDiscoverAnimeList(1).first;
    }
  }

  Future<DiscoverMangaModel> getMangaOfTheDay() async {
    try {
      final result = await _api.getMangaOfTheDay(
        _dailyPage(),
      );

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final media = result.data?['Page']?['media'];

      if (media == null || media.isEmpty) {
        throw AppFailure.notFound('Manga not found');
      }

      return DiscoverMangaModel.fromJson(
        media.first,
      );
    } catch (e) {
      // Fallback to mock Manga of the Day if API fails
      return MockDataHelper.getDiscoverMangaList(1).first;
    }
  }

  int _weeklyPageOffset(DiscoverMode mode) {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final days = now.difference(firstDayOfYear).inDays;
    final week = (days / 7).floor();
    // Unique seed per mode
    final seed = now.year * 1000 + week * 10 + mode.index;
    return Random(seed).nextInt(10);
  }

  int _weeklySurprisePage() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final days = now.difference(firstDayOfYear).inDays;
    final week = (days / 7).floor();
    final seed = now.year * 1000 + week * 10 + 99;
    return Random(seed).nextInt(50) + 1;
  }

  List<DiscoverAnimeModel> _filterUnderratedAnime(List<DiscoverAnimeModel> rawList) {
    final filtered = rawList.where((item) {
      final score = item.averageScore ?? 0;
      final pop = item.popularity ?? 0;
      return score >= 80 && pop >= 2000 && pop <= 80000;
    }).toList();

    if (filtered.length < 20) {
      final loose = rawList.where((item) {
        final score = item.averageScore ?? 0;
        final pop = item.popularity ?? 0;
        return score >= 80 && pop >= 1000 && pop <= 150000;
      }).toList();

      final combined = <int, DiscoverAnimeModel>{};
      for (final item in filtered) combined[item.id] = item;
      for (final item in loose) combined[item.id] = item;

      final resultList = combined.values.toList();
      if (resultList.length < 20) {
        final mockUnderrated = _getMockUnderratedAnime();
        final dedup = <int, DiscoverAnimeModel>{};
        for (final item in resultList) dedup[item.id] = item;
        for (final item in mockUnderrated) dedup[item.id] = item;
        return dedup.values.take(20).toList();
      }
      return resultList;
    }
    return filtered;
  }

  List<DiscoverAnimeModel> _getMockUnderratedAnime() {
    final raw = MockDataHelper.getDiscoverAnimeList(100);
    return raw.where((item) {
      final score = item.averageScore ?? 0;
      final pop = item.popularity ?? 0;
      return score >= 80 && pop >= 2000 && pop <= 80000;
    }).toList();
  }

  List<DiscoverMangaModel> _filterUnderratedManga(List<DiscoverMangaModel> rawList) {
    final filtered = rawList.where((item) {
      final score = item.averageScore ?? 0;
      final pop = item.popularity ?? 0;
      return score >= 80 && pop >= 2000 && pop <= 80000;
    }).toList();

    if (filtered.length < 20) {
      final loose = rawList.where((item) {
        final score = item.averageScore ?? 0;
        final pop = item.popularity ?? 0;
        return score >= 80 && pop >= 1000 && pop <= 150000;
      }).toList();

      final combined = <int, DiscoverMangaModel>{};
      for (final item in filtered) combined[item.id] = item;
      for (final item in loose) combined[item.id] = item;

      final resultList = combined.values.toList();
      if (resultList.length < 20) {
        final mockUnderrated = _getMockUnderratedManga();
        final dedup = <int, DiscoverMangaModel>{};
        for (final item in resultList) dedup[item.id] = item;
        for (final item in mockUnderrated) dedup[item.id] = item;
        return dedup.values.take(20).toList();
      }
      return resultList;
    }
    return filtered;
  }

  List<DiscoverMangaModel> _getMockUnderratedManga() {
    final raw = MockDataHelper.getDiscoverMangaList(100);
    return raw.where((item) {
      final score = item.averageScore ?? 0;
      final pop = item.popularity ?? 0;
      return score >= 80 && pop >= 2000 && pop <= 80000;
    }).toList();
  }

  Future<List<DiscoverAnimeModel>> getAnimeList(
    DiscoverMode mode, {
    int page = 1,
  }) async {
    try {
      late final QueryResult result;
      final queryPage = (mode == DiscoverMode.airing)
          ? page
          : (mode == DiscoverMode.surpriseMe
              ? _weeklySurprisePage()
              : page + _weeklyPageOffset(mode));

      switch (mode) {
        case DiscoverMode.trending:
          result = await _api.getTrendingAnime(queryPage);
          break;

        case DiscoverMode.hiddenGems:
          result = await _api.getHiddenGems(queryPage);
          break;

        case DiscoverMode.airing:
          result = await _api.getAiringAnime(queryPage);
          break;

        case DiscoverMode.topRated:
          result = await _api.getTopRatedAnime(queryPage);
          break;

        case DiscoverMode.surpriseMe:
          result = await _api.getTrendingAnime(queryPage);
          break;
      }

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final List<dynamic> media =
          result.data?['Page']?['media'] ?? [];

      final list = media
          .map(
            (item) => DiscoverAnimeModel.fromJson(
              item,
            ),
          )
          .toList();

      if (mode == DiscoverMode.hiddenGems) {
        return _filterUnderratedAnime(list);
      }
      return list;
    } catch (e) {
      if (mode == DiscoverMode.hiddenGems) {
        return _getMockUnderratedAnime();
      }
      // Fallback to mock Anime Discover list if API fails
      return _getMockAnimeList(mode);
    }
  }

  List<DiscoverAnimeModel> _getMockAnimeList(DiscoverMode mode) {
    if (mode == DiscoverMode.trending) {
      return MockDataHelper.getDiscoverAnimeList(5);
    } else if (mode == DiscoverMode.hiddenGems) {
      return _getMockUnderratedAnime();
    } else if (mode == DiscoverMode.airing) {
      return MockDataHelper.getDiscoverAnimeList(10).skip(4).toList();
    } else {
      return MockDataHelper.getDiscoverAnimeList(10).reversed.toList();
    }
  }

  Future<List<DiscoverMangaModel>> getMangaList(
    DiscoverMode mode, {
    int page = 1,
  }) async {
    try {
      late final QueryResult result;
      final queryPage = (mode == DiscoverMode.airing)
          ? page
          : (mode == DiscoverMode.surpriseMe
              ? _weeklySurprisePage()
              : page + _weeklyPageOffset(mode));

      switch (mode) {
        case DiscoverMode.trending:
          result = await _api.getTrendingManga(queryPage);
          break;

        case DiscoverMode.hiddenGems:
          result = await _api.getHiddenGemsManga(queryPage);
          break;

        case DiscoverMode.airing:
          result = await _api.getAiringManga(queryPage);
          break;

        case DiscoverMode.topRated:
          result = await _api.getTopRatedManga(queryPage);
          break;

        case DiscoverMode.surpriseMe:
          result = await _api.getTrendingManga(queryPage);
          break;
      }

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final List<dynamic> media =
          result.data?['Page']?['media'] ?? [];

      final list = media
          .map(
            (item) => DiscoverMangaModel.fromJson(
              item,
            ),
          )
          .toList();

      if (mode == DiscoverMode.hiddenGems) {
        return _filterUnderratedManga(list);
      }
      return list;
    } catch (e) {
      if (mode == DiscoverMode.hiddenGems) {
        return _getMockUnderratedManga();
      }
      return _getMockMangaList(mode);
    }
  }

  List<DiscoverMangaModel> _getMockMangaList(DiscoverMode mode) {
    if (mode == DiscoverMode.trending) {
      return MockDataHelper.getDiscoverMangaList(5);
    } else if (mode == DiscoverMode.hiddenGems) {
      return _getMockUnderratedManga();
    } else if (mode == DiscoverMode.airing) {
      return MockDataHelper.getDiscoverMangaList(10).skip(4).toList();
    } else {
      return MockDataHelper.getDiscoverMangaList(10).reversed.toList();
    }
  }

  Future<List<DiscoverMediaModel>> fetchFilteredMedia(
    int page,
    DiscoverFilters filters,
  ) async {
    try {
      final variables = filters.toVariables(page);
      final result = await _api.getFilteredContent(variables);

      if (result.hasException) {
        if (kDebugMode) {
          debugPrint('[DiscoverRepository] GraphQL Exception: ${result.exception}');
        }
        throw AppFailure.fromOperation(result.exception);
      }

      final List<dynamic> media =
          result.data?['Page']?['media'] ?? [];

      if (media.isEmpty && kDebugMode) {
        debugPrint('[DiscoverRepository] API returns empty media list for params: $variables');
      }

      return media
          .map((item) => DiscoverMediaModel.fromJson(item))
          .toList();
    } catch (e) {
      return [];
    }
  }
}