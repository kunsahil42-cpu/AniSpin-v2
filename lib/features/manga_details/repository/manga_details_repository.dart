import '../data/manga_details_api.dart';
import '../models/manga_details_model.dart';

class MangaDetailsRepository {
  final MangaDetailsApi _api = MangaDetailsApi();

  Future<MangaDetailsModel> getMangaDetails(
    int id,
  ) async {
    final result = await _api.getMangaDetails(id);

    if (result.hasException) {
      throw Exception(
        result.exception.toString(),
      );
    }

    final data = result.data?['Media'];

    if (data == null) {
      throw Exception(
        'Manga not found',
      );
    }

    return MangaDetailsModel.fromJson(data);
  }
}