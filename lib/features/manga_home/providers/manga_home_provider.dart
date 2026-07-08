import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/mangadex/mangadex_api.dart';
import '../models/manga_home_model.dart';
import '../repository/manga_home_repository.dart';
import '../../settings/providers/settings_provider.dart';

final mangaHomeRepositoryProvider = Provider<MangaHomeRepository>((ref) {
  return MangaHomeRepository(
    mangaDex: ref.watch(mangaDexApiProvider),
  );
});

final mangaHomeSectionProvider = FutureProvider.family<List<MangaHomeModel>, MangaHomeSection>((ref, section) async {
  final repo = ref.watch(mangaHomeRepositoryProvider);
  final list = await repo.getMangaList(section);

  final settings = ref.watch(settingsNotifierProvider);
  final blocked = settings.blockedGenres;
  if (blocked.isEmpty) return list;

  final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
  return list.where((item) {
    return !item.genres.any((g) => blockedLower.contains(g.toLowerCase()));
  }).toList();
});
