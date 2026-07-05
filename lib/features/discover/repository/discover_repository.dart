import 'dart:math';

import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/error/app_failure.dart';
import '../data/discover_api.dart';
import '../enums/discover_mode.dart';
import '../models/discover_anime_model.dart';
import '../models/discover_manga_model.dart';

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
      throw AppFailure.from(e);
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
      throw AppFailure.from(e);
    }
  }

  Future<List<DiscoverAnimeModel>> getAnimeList(
    DiscoverMode mode, {
    int page = 1,
  }) async {
    try {
      late final QueryResult result;

      switch (mode) {
        case DiscoverMode.trending:
          result = await _api.getTrendingAnime(
            page,
          );
          break;

        case DiscoverMode.hiddenGems:
          result = await _api.getHiddenGems(
            page,
          );
          break;

        case DiscoverMode.airing:
          result = await _api.getAiringAnime(
            page,
          );
          break;

        case DiscoverMode.topRated:
          result = await _api.getTopRatedAnime(
            page,
          );
          break;

        case DiscoverMode.surpriseMe:
          result = await _api.getTrendingAnime(
            page,
          );
          break;
      }

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final List<dynamic> media =
          result.data?['Page']?['media'] ?? [];

      return media
          .map(
            (item) => DiscoverAnimeModel.fromJson(
              item,
            ),
          )
          .toList();
    } catch (e) {
      throw AppFailure.from(e);
    }
  }
}