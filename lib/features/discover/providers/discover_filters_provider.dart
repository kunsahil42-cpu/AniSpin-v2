import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/models/app_settings.dart';
import '../../settings/providers/settings_provider.dart';
import '../models/discover_filters.dart';
import '../models/discover_media_model.dart';
import '../repository/discover_repository.dart';
import 'discover_provider.dart';

final discoverFiltersProvider = StateNotifierProvider<DiscoverFiltersNotifier, DiscoverFilters>((ref) {
  final settings = ref.watch(settingsNotifierProvider);
  final settingsNotifier = ref.watch(settingsNotifierProvider.notifier);
  return DiscoverFiltersNotifier(settings, settingsNotifier);
});

class DiscoverFiltersNotifier extends StateNotifier<DiscoverFilters> {
  final SettingsNotifier _settingsNotifier;

  DiscoverFiltersNotifier(AppSettings settings, this._settingsNotifier)
      : super(DiscoverFilters(
          isManga: settings.discoverIsManga,
          genres: settings.discoverGenres,
          season: settings.discoverSeason,
          years: settings.discoverYears,
          types: settings.discoverTypes,
          statuses: settings.discoverStatuses,
          languages: settings.discoverLanguages,
          ratings: settings.discoverRatings,
          sources: settings.discoverSources,
          minRange: settings.discoverMinRange,
          maxRange: settings.discoverMaxRange,
          sortBy: settings.discoverSortBy,
        ));

  void updateGenres(List<String> val) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: val,
      season: state.season,
      years: state.years,
      types: state.types,
      statuses: state.statuses,
      languages: state.languages,
      ratings: state.ratings,
      sources: state.sources,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(discoverGenres: val);
  }

  void updateSeason(String? val) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: state.genres,
      season: val,
      years: state.years,
      types: state.types,
      statuses: state.statuses,
      languages: state.languages,
      ratings: state.ratings,
      sources: state.sources,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(
      discoverSeason: val,
      clearSeason: val == null,
    );
  }

  void updateYears(List<int> val) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: state.genres,
      season: state.season,
      years: val,
      types: state.types,
      statuses: state.statuses,
      languages: state.languages,
      ratings: state.ratings,
      sources: state.sources,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(discoverYears: val);
  }

  void updateTypes(List<String> val) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: state.genres,
      season: state.season,
      years: state.years,
      types: val,
      statuses: state.statuses,
      languages: state.languages,
      ratings: state.ratings,
      sources: state.sources,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(discoverTypes: val);
  }

  void updateStatuses(List<String> val) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: state.genres,
      season: state.season,
      years: state.years,
      types: state.types,
      statuses: val,
      languages: state.languages,
      ratings: state.ratings,
      sources: state.sources,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(discoverStatuses: val);
  }

  void updateLanguages(List<String> val) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: state.genres,
      season: state.season,
      years: state.years,
      types: state.types,
      statuses: state.statuses,
      languages: val,
      ratings: state.ratings,
      sources: state.sources,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(discoverLanguages: val);
  }

  void updateRatings(List<String> val) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: state.genres,
      season: state.season,
      years: state.years,
      types: state.types,
      statuses: state.statuses,
      languages: state.languages,
      ratings: val,
      sources: state.sources,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(discoverRatings: val);
  }

  void updateSources(List<String> val) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: state.genres,
      season: state.season,
      years: state.years,
      types: state.types,
      statuses: state.statuses,
      languages: state.languages,
      ratings: state.ratings,
      sources: val,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(discoverSources: val);
  }

  void updateRanges(int? min, int? max) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: state.genres,
      season: state.season,
      years: state.years,
      types: state.types,
      statuses: state.statuses,
      languages: state.languages,
      ratings: state.ratings,
      sources: state.sources,
      minRange: min,
      maxRange: max,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(
      discoverMinRange: min,
      discoverMaxRange: max,
      clearMinRange: min == null,
      clearMaxRange: max == null,
    );
  }

  void updateSortBy(String val) {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: state.genres,
      season: state.season,
      years: state.years,
      types: state.types,
      statuses: state.statuses,
      languages: state.languages,
      ratings: state.ratings,
      sources: state.sources,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: val,
    );
    _settingsNotifier.updateDiscoverFilters(discoverSortBy: val);
  }

  void updateIsManga(bool val) {
    state = DiscoverFilters(
      isManga: val,
      genres: state.genres,
      season: state.season,
      years: state.years,
      types: state.types,
      statuses: state.statuses,
      languages: state.languages,
      ratings: state.ratings,
      sources: state.sources,
      minRange: state.minRange,
      maxRange: state.maxRange,
      sortBy: state.sortBy,
    );
    _settingsNotifier.updateDiscoverFilters(discoverIsManga: val);
  }

  void resetAll() {
    state = DiscoverFilters(
      isManga: state.isManga,
      genres: const [],
      season: null,
      years: const [],
      types: const [],
      statuses: const [],
      languages: const [],
      ratings: const [],
      sources: const [],
      minRange: null,
      maxRange: null,
      sortBy: "Default",
    );
    _settingsNotifier.updateDiscoverFilters(
      discoverGenres: const [],
      discoverSeason: null,
      discoverYears: const [],
      discoverTypes: const [],
      discoverStatuses: const [],
      discoverLanguages: const [],
      discoverRatings: const [],
      discoverSources: const [],
      discoverMinRange: null,
      discoverMaxRange: null,
      discoverSortBy: "Default",
      clearSeason: true,
      clearMinRange: true,
      clearMaxRange: true,
    );
  }

  void applyAll(DiscoverFilters newFilters) {
    state = newFilters;
    _settingsNotifier.updateDiscoverFilters(
      discoverGenres: newFilters.genres,
      discoverSeason: newFilters.season,
      discoverYears: newFilters.years,
      discoverTypes: newFilters.types,
      discoverStatuses: newFilters.statuses,
      discoverLanguages: newFilters.languages,
      discoverRatings: newFilters.ratings,
      discoverSources: newFilters.sources,
      discoverMinRange: newFilters.minRange,
      discoverMaxRange: newFilters.maxRange,
      discoverSortBy: newFilters.sortBy,
      discoverIsManga: newFilters.isManga,
      clearSeason: newFilters.season == null,
      clearMinRange: newFilters.minRange == null,
      clearMaxRange: newFilters.maxRange == null,
    );
  }
}

class FilteredMediaState {
  final List<DiscoverMediaModel> items;
  final int page;
  final bool isLoading;
  final bool hasNextPage;
  final bool hasError;

  const FilteredMediaState({
    required this.items,
    required this.page,
    required this.isLoading,
    required this.hasNextPage,
    required this.hasError,
  });

  FilteredMediaState copyWith({
    List<DiscoverMediaModel>? items,
    int? page,
    bool? isLoading,
    bool? hasNextPage,
    bool? hasError,
  }) {
    return FilteredMediaState(
      items: items ?? this.items,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasError: hasError ?? this.hasError,
    );
  }
}

class FilteredMediaNotifier extends StateNotifier<FilteredMediaState> {
  final DiscoverRepository _repository;
  final DiscoverFilters _filters;
  final Set<String> _blockedLower;

  static const int _targetPageSize = 20;
  static const int _maxFetchesPerCall = 5;

  FilteredMediaNotifier(this._repository, this._filters, List<String> blockedGenres)
      : _blockedLower = blockedGenres.map((b) => b.toLowerCase()).toSet(),
        super(const FilteredMediaState(
          items: [],
          page: 1,
          isLoading: false,
          hasNextPage: true,
          hasError: false,
        )) {
    fetchNextPage();
  }

  bool _isBlocked(DiscoverMediaModel item) {
    if (_blockedLower.isEmpty) return false;
    return item.genres.any((g) => _blockedLower.contains(g.toLowerCase()));
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || !state.hasNextPage) return;

    state = state.copyWith(isLoading: true, hasError: false);

    try {
      final accumulated = <DiscoverMediaModel>[];
      int currentPage = state.page;
      bool hasNextPage = true;
      int fetchCount = 0;

      // Keep fetching pages until we have enough unblocked items
      while (accumulated.length < _targetPageSize &&
          hasNextPage &&
          fetchCount < _maxFetchesPerCall) {
        final raw = await _repository.fetchFilteredMedia(currentPage, _filters);
        fetchCount++;
        currentPage++;
        hasNextPage = raw.length >= _targetPageSize;

        for (final item in raw) {
          if (!_isBlocked(item)) {
            accumulated.add(item);
          }
        }

        // If the raw page was empty or smaller than a full page, no more data
        if (raw.isEmpty) break;
      }

      state = state.copyWith(
        items: [...state.items, ...accumulated],
        page: currentPage,
        isLoading: false,
        hasNextPage: hasNextPage,
        hasError: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, hasError: true);
    }
  }
}

final filteredMediaProvider = StateNotifierProvider.family<FilteredMediaNotifier, FilteredMediaState, DiscoverFilters>((ref, filters) {
  final repository = ref.read(discoverRepositoryProvider);
  final settings = ref.watch(settingsNotifierProvider);
  return FilteredMediaNotifier(repository, filters, settings.blockedGenres);
});
