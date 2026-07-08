import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../enums/home_section.dart';
import '../models/home_anime_model.dart';
import '../repository/home_repository.dart';
import '../../settings/providers/settings_provider.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepository(),
);

final homeSectionProvider =
    FutureProvider.family<
        List<HomeAnimeModel>,
        HomeSection>(
  (ref, section) async {
    final list = await ref
        .read(homeRepositoryProvider)
        .getAnime(section);

    final settings = ref.watch(settingsNotifierProvider);
    final blocked = settings.blockedGenres;
    if (blocked.isEmpty) return list;

    final blockedLower = blocked.map((b) => b.toLowerCase()).toSet();
    return list.where((item) {
      return !item.genres.any((g) => blockedLower.contains(g.toLowerCase()));
    }).toList();
  },
);

enum HomeType { anime, manga }

class HomeTypeNotifier extends StateNotifier<HomeType> {
  final SettingsNotifier _settingsNotifier;

  HomeTypeNotifier(HomeType state, this._settingsNotifier) : super(state);

  void setType(HomeType type) {
    state = type;
    _settingsNotifier.setLastHomeTab(type == HomeType.manga ? "manga" : "anime");
  }
}

final homeTypeProvider = StateNotifierProvider<HomeTypeNotifier, HomeType>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  final initial = settings.lastHomeTab == "manga" ? HomeType.manga : HomeType.anime;
  return HomeTypeNotifier(initial, ref.read(settingsNotifierProvider.notifier));
});