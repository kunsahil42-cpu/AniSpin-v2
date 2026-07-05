import '../../../core/error/app_failure.dart';
import '../data/anime_details_api.dart';
import '../models/anime_details_model.dart';

class AnimeDetailsRepository {
  final AnimeDetailsApi _api = AnimeDetailsApi();

  Future<AnimeDetailsModel> getAnimeDetails(int id) async {
    try {
      final result = await _api.getAnimeDetails(id);

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final data = result.data?['Media'];

      if (data == null) {
        throw AppFailure.notFound("This anime couldn't be found.");
      }

      return AnimeDetailsModel.fromJson(data);
    } catch (e) {
      throw AppFailure.from(e);
    }
  }
}