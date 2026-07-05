import '../../../core/error/app_failure.dart';
import '../data/manga_details_api.dart';
import '../models/manga_details_model.dart';

class MangaDetailsRepository {
  final MangaDetailsApi _api = MangaDetailsApi();

  Future<MangaDetailsModel> getMangaDetails(
    int id,
  ) async {
    try {
      final result = await _api.getMangaDetails(id);

      if (result.hasException) {
        throw AppFailure.fromOperation(result.exception);
      }

      final data = result.data?['Media'];

      if (data == null) {
        throw AppFailure.notFound("This manga couldn't be found.");
      }

      return MangaDetailsModel.fromJson(data);
    } catch (e) {
      throw AppFailure.from(e);
    }
  }
}