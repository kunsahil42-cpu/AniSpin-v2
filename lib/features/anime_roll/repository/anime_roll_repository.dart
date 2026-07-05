import 'dart:math';

import '../../../core/error/app_failure.dart';
import '../data/anime_roll_api.dart';
import '../models/anime_roll_model.dart';

class AnimeRollRepository {
  final AnimeRollApi _api = AnimeRollApi();
  final Random _random = Random();

  Future<AnimeRollModel> getRandomAnime() async {
    try {
      // Random page between 1 and 500
      final randomPage = _random.nextInt(500) + 1;

      final result = await _api.getRandomAnime(randomPage);

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final mediaList = result.data?['Page']?['media'];

      if (mediaList == null || mediaList.isEmpty) {
        throw AppFailure.notFound('No anime found.');
      }

      return AnimeRollModel.fromJson(mediaList.first);
    } catch (e) {
      throw AppFailure.from(e);
    }
  }
}