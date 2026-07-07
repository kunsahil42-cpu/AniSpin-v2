enum ThemeOption { system, light, dark }

enum UiDensityOption { comfortable, compact, spacious }

enum AccentColorOption {
  blue,
  purple,
  green,
  orange,
  red,
  pink,
  cyan,
  dynamicColor,
}

enum VideoQualityOption {
  auto,
  p360,
  p480,
  p720,
  p1080,
}

enum AudioOption { sub, dub }

enum ReadingDirectionOption { vertical, horizontal }

enum ReadingModeOption { continuous, pageByPage }

enum ImageQualityOption { dataSaver, standard, high }

class AppSettings {
  // Appearance
  final ThemeOption themeOption;
  final bool amoledTheme;
  final bool materialYou;
  final UiDensityOption uiDensity;

  // Accent Colors
  final AccentColorOption accentColor;

  // Anime Playback
  final VideoQualityOption defaultVideoQuality;
  final AudioOption defaultAudio;
  final bool autoNextEpisode;
  final bool autoFullscreen;
  final double playbackSpeed;
  final String preferredStreamingServer;

  // Manga Reader
  final ReadingDirectionOption readingDirection;
  final ReadingModeOption readingMode;
  final ImageQualityOption imageQuality;
  final bool preloadPages;
  final bool doubleTapZoom;
  final bool keepScreenOn;
  final bool rememberLastPage;

  // Notifications
  final bool notifyNewEpisodes;
  final bool notifyNewChapters;
  final bool notifyContinueWatching;
  final bool notifyContinueReading;
  final bool notifyAppUpdates;

  // Language & Region
  final String appLanguage;
  final String contentLanguage;
  final String preferredSubtitleLanguage;
  final String preferredAudioLanguage;
  final String region;

  const AppSettings({
    required this.themeOption,
    required this.amoledTheme,
    required this.materialYou,
    required this.uiDensity,
    required this.accentColor,
    required this.defaultVideoQuality,
    required this.defaultAudio,
    required this.autoNextEpisode,
    required this.autoFullscreen,
    required this.playbackSpeed,
    required this.preferredStreamingServer,
    required this.readingDirection,
    required this.readingMode,
    required this.imageQuality,
    required this.preloadPages,
    required this.doubleTapZoom,
    required this.keepScreenOn,
    required this.rememberLastPage,
    required this.notifyNewEpisodes,
    required this.notifyNewChapters,
    required this.notifyContinueWatching,
    required this.notifyContinueReading,
    required this.notifyAppUpdates,
    required this.appLanguage,
    required this.contentLanguage,
    required this.preferredSubtitleLanguage,
    required this.preferredAudioLanguage,
    required this.region,
  });

  factory AppSettings.defaultSettings() {
    return const AppSettings(
      themeOption: ThemeOption.system,
      amoledTheme: false,
      materialYou: false,
      uiDensity: UiDensityOption.comfortable,
      accentColor: AccentColorOption.purple,
      defaultVideoQuality: VideoQualityOption.auto,
      defaultAudio: AudioOption.sub,
      autoNextEpisode: true,
      autoFullscreen: true,
      playbackSpeed: 1.0,
      preferredStreamingServer: "Anikoto",
      readingDirection: ReadingDirectionOption.horizontal,
      readingMode: ReadingModeOption.pageByPage,
      imageQuality: ImageQualityOption.standard,
      preloadPages: true,
      doubleTapZoom: true,
      keepScreenOn: false,
      rememberLastPage: true,
      notifyNewEpisodes: true,
      notifyNewChapters: true,
      notifyContinueWatching: true,
      notifyContinueReading: true,
      notifyAppUpdates: true,
      appLanguage: "en",
      contentLanguage: "en",
      preferredSubtitleLanguage: "en",
      preferredAudioLanguage: "en",
      region: "US",
    );
  }

  AppSettings copyWith({
    ThemeOption? themeOption,
    bool? amoledTheme,
    bool? materialYou,
    UiDensityOption? uiDensity,
    AccentColorOption? accentColor,
    VideoQualityOption? defaultVideoQuality,
    AudioOption? defaultAudio,
    bool? autoNextEpisode,
    bool? autoFullscreen,
    double? playbackSpeed,
    String? preferredStreamingServer,
    ReadingDirectionOption? readingDirection,
    ReadingModeOption? readingMode,
    ImageQualityOption? imageQuality,
    bool? preloadPages,
    bool? doubleTapZoom,
    bool? keepScreenOn,
    bool? rememberLastPage,
    bool? notifyNewEpisodes,
    bool? notifyNewChapters,
    bool? notifyContinueWatching,
    bool? notifyContinueReading,
    bool? notifyAppUpdates,
    String? appLanguage,
    String? contentLanguage,
    String? preferredSubtitleLanguage,
    String? preferredAudioLanguage,
    String? region,
  }) {
    return AppSettings(
      themeOption: themeOption ?? this.themeOption,
      amoledTheme: amoledTheme ?? this.amoledTheme,
      materialYou: materialYou ?? this.materialYou,
      uiDensity: uiDensity ?? this.uiDensity,
      accentColor: accentColor ?? this.accentColor,
      defaultVideoQuality: defaultVideoQuality ?? this.defaultVideoQuality,
      defaultAudio: defaultAudio ?? this.defaultAudio,
      autoNextEpisode: autoNextEpisode ?? this.autoNextEpisode,
      autoFullscreen: autoFullscreen ?? this.autoFullscreen,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      preferredStreamingServer: preferredStreamingServer ?? this.preferredStreamingServer,
      readingDirection: readingDirection ?? this.readingDirection,
      readingMode: readingMode ?? this.readingMode,
      imageQuality: imageQuality ?? this.imageQuality,
      preloadPages: preloadPages ?? this.preloadPages,
      doubleTapZoom: doubleTapZoom ?? this.doubleTapZoom,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      rememberLastPage: rememberLastPage ?? this.rememberLastPage,
      notifyNewEpisodes: notifyNewEpisodes ?? this.notifyNewEpisodes,
      notifyNewChapters: notifyNewChapters ?? this.notifyNewChapters,
      notifyContinueWatching: notifyContinueWatching ?? this.notifyContinueWatching,
      notifyContinueReading: notifyContinueReading ?? this.notifyContinueReading,
      notifyAppUpdates: notifyAppUpdates ?? this.notifyAppUpdates,
      appLanguage: appLanguage ?? this.appLanguage,
      contentLanguage: contentLanguage ?? this.contentLanguage,
      preferredSubtitleLanguage: preferredSubtitleLanguage ?? this.preferredSubtitleLanguage,
      preferredAudioLanguage: preferredAudioLanguage ?? this.preferredAudioLanguage,
      region: region ?? this.region,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeOption': themeOption.name,
      'amoledTheme': amoledTheme,
      'materialYou': materialYou,
      'uiDensity': uiDensity.name,
      'accentColor': accentColor.name,
      'defaultVideoQuality': defaultVideoQuality.name,
      'defaultAudio': defaultAudio.name,
      'autoNextEpisode': autoNextEpisode,
      'autoFullscreen': autoFullscreen,
      'playbackSpeed': playbackSpeed,
      'preferredStreamingServer': preferredStreamingServer,
      'readingDirection': readingDirection.name,
      'readingMode': readingMode.name,
      'imageQuality': imageQuality.name,
      'preloadPages': preloadPages,
      'doubleTapZoom': doubleTapZoom,
      'keepScreenOn': keepScreenOn,
      'rememberLastPage': rememberLastPage,
      'notifyNewEpisodes': notifyNewEpisodes,
      'notifyNewChapters': notifyNewChapters,
      'notifyContinueWatching': notifyContinueWatching,
      'notifyContinueReading': notifyContinueReading,
      'notifyAppUpdates': notifyAppUpdates,
      'appLanguage': appLanguage,
      'contentLanguage': contentLanguage,
      'preferredSubtitleLanguage': preferredSubtitleLanguage,
      'preferredAudioLanguage': preferredAudioLanguage,
      'region': region,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    ThemeOption parseTheme(String? val) {
      return ThemeOption.values.firstWhere((e) => e.name == val, orElse: () => ThemeOption.system);
    }
    UiDensityOption parseDensity(String? val) {
      return UiDensityOption.values.firstWhere((e) => e.name == val, orElse: () => UiDensityOption.comfortable);
    }
    AccentColorOption parseAccent(String? val) {
      return AccentColorOption.values.firstWhere((e) => e.name == val, orElse: () => AccentColorOption.purple);
    }
    VideoQualityOption parseQuality(String? val) {
      return VideoQualityOption.values.firstWhere((e) => e.name == val, orElse: () => VideoQualityOption.auto);
    }
    AudioOption parseAudio(String? val) {
      return AudioOption.values.firstWhere((e) => e.name == val, orElse: () => AudioOption.sub);
    }
    ReadingDirectionOption parseDirection(String? val) {
      return ReadingDirectionOption.values.firstWhere((e) => e.name == val, orElse: () => ReadingDirectionOption.horizontal);
    }
    ReadingModeOption parseMode(String? val) {
      return ReadingModeOption.values.firstWhere((e) => e.name == val, orElse: () => ReadingModeOption.pageByPage);
    }
    ImageQualityOption parseImgQuality(String? val) {
      return ImageQualityOption.values.firstWhere((e) => e.name == val, orElse: () => ImageQualityOption.standard);
    }

    final def = AppSettings.defaultSettings();
    return AppSettings(
      themeOption: parseTheme(json['themeOption']),
      amoledTheme: json['amoledTheme'] ?? def.amoledTheme,
      materialYou: json['materialYou'] ?? def.materialYou,
      uiDensity: parseDensity(json['uiDensity']),
      accentColor: parseAccent(json['accentColor']),
      defaultVideoQuality: parseQuality(json['defaultVideoQuality']),
      defaultAudio: parseAudio(json['defaultAudio']),
      autoNextEpisode: json['autoNextEpisode'] ?? def.autoNextEpisode,
      autoFullscreen: json['autoFullscreen'] ?? def.autoFullscreen,
      playbackSpeed: (json['playbackSpeed'] as num?)?.toDouble() ?? def.playbackSpeed,
      preferredStreamingServer: json['preferredStreamingServer'] ?? def.preferredStreamingServer,
      readingDirection: parseDirection(json['readingDirection']),
      readingMode: parseMode(json['readingMode']),
      imageQuality: parseImgQuality(json['imageQuality']),
      preloadPages: json['preloadPages'] ?? def.preloadPages,
      doubleTapZoom: json['doubleTapZoom'] ?? def.doubleTapZoom,
      keepScreenOn: json['keepScreenOn'] ?? def.keepScreenOn,
      rememberLastPage: json['rememberLastPage'] ?? def.rememberLastPage,
      notifyNewEpisodes: json['notifyNewEpisodes'] ?? def.notifyNewEpisodes,
      notifyNewChapters: json['notifyNewChapters'] ?? def.notifyNewChapters,
      notifyContinueWatching: json['notifyContinueWatching'] ?? def.notifyContinueWatching,
      notifyContinueReading: json['notifyContinueReading'] ?? def.notifyContinueReading,
      notifyAppUpdates: json['notifyAppUpdates'] ?? def.notifyAppUpdates,
      appLanguage: json['appLanguage'] ?? def.appLanguage,
      contentLanguage: json['contentLanguage'] ?? def.contentLanguage,
      preferredSubtitleLanguage: json['preferredSubtitleLanguage'] ?? def.preferredSubtitleLanguage,
      preferredAudioLanguage: json['preferredAudioLanguage'] ?? def.preferredAudioLanguage,
      region: json['region'] ?? def.region,
    );
  }
}
