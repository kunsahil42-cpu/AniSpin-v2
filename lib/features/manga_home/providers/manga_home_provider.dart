import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/mangadex/mangadex_api.dart';
import '../models/manga_home_model.dart';
import '../repository/manga_home_repository.dart';
import '../../../core/utils/genre_filter.dart';
import '../../settings/providers/settings_provider.dart';

final mangaHomeRepositoryProvider = Provider<MangaHomeRepository>((ref) {
  return MangaHomeRepository(
    mangaDex: ref.watch(mangaDexApiProvider),
  );
});

final mangaHomeSectionProvider = FutureProvider.family<List<MangaHomeModel>, MangaHomeSection>((ref, section) async {
  final repo = ref.watch(mangaHomeRepositoryProvider);
  final blocked = ref.watch(blockedGenresProvider);

  if (blocked.isEmpty) {
    return repo.getMangaList(section);
  }

  bool isBlocked(MangaHomeModel item) =>
      isMediaBlocked(genres: item.genres, isAdult: item.isAdult, blockedGenres: blocked);

  const targetCount = 10;
  const maxPages = 4;

  final accumulated = <MangaHomeModel>[];
  for (int page = 1; page <= maxPages; page++) {
    final raw = await repo.getMangaList(section, page: page);
    for (final item in raw) {
      if (!isBlocked(item)) accumulated.add(item);
    }
    if (accumulated.length >= targetCount || raw.length < 20) break;
  }
  return accumulated;
});
