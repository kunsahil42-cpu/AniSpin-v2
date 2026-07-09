import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../repository/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository);
});

/// Derived provider that exposes only the blockedGenres list.
/// All content providers watch this so they re-execute precisely when
/// the blocked-genres list changes, not on every unrelated settings update.
final blockedGenresProvider = Provider<List<String>>((ref) {
  final genres = ref.watch(settingsNotifierProvider).blockedGenres;
  if (kDebugMode) {
    debugPrint('[Settings] blockedGenresProvider evaluated — blockedGenres used during filtering: $genres');
  }
  return genres;
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(AppSettings.defaultSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    if (kDebugMode) {
      debugPrint('[Settings] ▶ _loadSettings() called — initialising from storage');
    }
    final saved = _repository.getSettingsSync();
    if (saved != null) {
      if (kDebugMode) {
        debugPrint('[Settings]   _loadSettings() — applying saved settings');
        debugPrint('[Settings]   blockedGenres loaded from storage: ${saved.blockedGenres}');
      }
      state = saved;
    } else {
      if (kDebugMode) {
        debugPrint('[Settings]   _loadSettings() — no saved settings found, using defaults');
        debugPrint('[Settings]   default blockedGenres: ${state.blockedGenres}');
      }
    }
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    state = newSettings;
    await _repository.saveSettings(newSettings);
  }

  Future<void> setThemeOption(ThemeOption val) => updateSettings(state.copyWith(themeOption: val));
  Future<void> setAmoledTheme(bool val) => updateSettings(state.copyWith(amoledTheme: val));
  Future<void> setMaterialYou(bool val) => updateSettings(state.copyWith(materialYou: val));
  Future<void> setUiDensity(UiDensityOption val) => updateSettings(state.copyWith(uiDensity: val));
  Future<void> setAccentColor(AccentColorOption val) => updateSettings(state.copyWith(accentColor: val));

  Future<void> setDefaultVideoQuality(VideoQualityOption val) => updateSettings(state.copyWith(defaultVideoQuality: val));
  Future<void> setDefaultAudio(AudioOption val) => updateSettings(state.copyWith(defaultAudio: val));
  Future<void> setAutoNextEpisode(bool val) => updateSettings(state.copyWith(autoNextEpisode: val));
  Future<void> setAutoFullscreen(bool val) => updateSettings(state.copyWith(autoFullscreen: val));
  Future<void> setPlaybackSpeed(double val) => updateSettings(state.copyWith(playbackSpeed: val));
  Future<void> setPreferredStreamingServer(String val) => updateSettings(state.copyWith(preferredStreamingServer: val));

  Future<void> setReadingDirection(ReadingDirectionOption val) => updateSettings(state.copyWith(readingDirection: val));
  Future<void> setReadingMode(ReadingModeOption val) => updateSettings(state.copyWith(readingMode: val));
  Future<void> setImageQuality(ImageQualityOption val) => updateSettings(state.copyWith(imageQuality: val));
  Future<void> setPreloadPages(bool val) => updateSettings(state.copyWith(preloadPages: val));
  Future<void> setDoubleTapZoom(bool val) => updateSettings(state.copyWith(doubleTapZoom: val));
  Future<void> setKeepScreenOn(bool val) => updateSettings(state.copyWith(keepScreenOn: val));
  Future<void> setRememberLastPage(bool val) => updateSettings(state.copyWith(rememberLastPage: val));
  Future<void> setLastHomeTab(String val) => updateSettings(state.copyWith(lastHomeTab: val));

  Future<void> setNotifyNewEpisodes(bool val) => updateSettings(state.copyWith(notifyNewEpisodes: val));
  Future<void> setNotifyNewChapters(bool val) => updateSettings(state.copyWith(notifyNewChapters: val));
  Future<void> setNotifyContinueWatching(bool val) => updateSettings(state.copyWith(notifyContinueWatching: val));
  Future<void> setNotifyContinueReading(bool val) => updateSettings(state.copyWith(notifyContinueReading: val));
  Future<void> setNotifyAppUpdates(bool val) => updateSettings(state.copyWith(notifyAppUpdates: val));

  Future<void> setAppLanguage(String val) => updateSettings(state.copyWith(appLanguage: val));
  Future<void> setContentLanguage(String val) => updateSettings(state.copyWith(contentLanguage: val));
  Future<void> setPreferredSubtitleLanguage(String val) => updateSettings(state.copyWith(preferredSubtitleLanguage: val));
  Future<void> setPreferredAudioLanguage(String val) => updateSettings(state.copyWith(preferredAudioLanguage: val));
  Future<void> setRegion(String val) => updateSettings(state.copyWith(region: val));

  /// Updates blocked genres and persists immediately.
  ///
  /// All content providers that watch [blockedGenresProvider] will automatically
  /// re-execute because [blockedGenresProvider] is derived from [settingsNotifierProvider].
  /// No manual invalidation is required — Riverpod's dependency graph handles it.
  Future<void> setBlockedGenres(List<String> val) async {
    if (kDebugMode) {
      debugPrint('[Settings] ▶ setBlockedGenres() called');
      debugPrint('[Settings]   genres before: ${state.blockedGenres}');
      debugPrint('[Settings]   genres after:  $val');
    }

    // Update in-memory state immediately (UI responds instantly) and persist.
    await updateSettings(state.copyWith(blockedGenres: val));

    if (kDebugMode) {
      debugPrint('[Settings] ✔ setBlockedGenres() complete');
      debugPrint('[Settings]   final blockedGenres in state: ${state.blockedGenres}');
    }
  }

  Future<void> updateDiscoverFilters({
    List<String>? discoverGenres,
    String? discoverSeason,
    List<int>? discoverYears,
    List<String>? discoverTypes,
    List<String>? discoverStatuses,
    List<String>? discoverLanguages,
    List<String>? discoverRatings,
    List<String>? discoverSources,
    int? discoverMinRange,
    int? discoverMaxRange,
    String? discoverSortBy,
    bool? discoverIsManga,
    bool clearSeason = false,
    bool clearMinRange = false,
    bool clearMaxRange = false,
  }) {
    return updateSettings(state.copyWith(
      discoverGenres: discoverGenres,
      discoverSeason: discoverSeason,
      discoverYears: discoverYears,
      discoverTypes: discoverTypes,
      discoverStatuses: discoverStatuses,
      discoverLanguages: discoverLanguages,
      discoverRatings: discoverRatings,
      discoverSources: discoverSources,
      discoverMinRange: discoverMinRange,
      discoverMaxRange: discoverMaxRange,
      discoverSortBy: discoverSortBy,
      discoverIsManga: discoverIsManga,
      clearSeason: clearSeason,
      clearMinRange: clearMinRange,
      clearMaxRange: clearMaxRange,
    ));
  }
}
