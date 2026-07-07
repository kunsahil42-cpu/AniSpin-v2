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

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository _repository;

  SettingsNotifier(this._repository) : super(AppSettings.defaultSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final saved = _repository.getSettingsSync();
    if (saved != null) {
      state = saved;
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
}
