import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/manga_details_model.dart';
import '../repository/manga_details_repository.dart';

final mangaDetailsRepositoryProvider =
    Provider<MangaDetailsRepository>((ref) {
  return MangaDetailsRepository();
});

final mangaDetailsProvider =
    FutureProvider.family<MangaDetailsModel, int>(
  (ref, mangaId) async {
    final repository = ref.read(
      mangaDetailsRepositoryProvider,
    );

    return repository.getMangaDetails(
      mangaId,
    );
  },
);