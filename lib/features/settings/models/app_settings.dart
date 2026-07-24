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

enum ExternalChapterOption { alwaysAsk, openInBrowser, openInChromeCustomTabs, copyLinkOnly }

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
  final ExternalChapterOption externalChapterOption;

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

  // Content Filtering
  final List<String> blockedGenres;

  // Discover Filters
  final List<String> discoverGenres;
  final String? discoverSeason;
  final List<int> discoverYears;
  final List<String> discoverTypes;
  final List<String> discoverStatuses;
  final List<String> discoverLanguages;
  final List<String> discoverRatings;
  final List<String> discoverSources;
  final int? discoverMinRange;
  final int? discoverMaxRange;
  final String discoverSortBy;
  final bool discoverIsManga;
  final String lastHomeTab;

  // AniList & MyAnimeList integration fields
  final String syncPriority; // "anilist", "myanimelist", "ask"
  final String? dontRemindUpdateDate;
  final String? aniListToken;
  final String? aniListUsername;
  final int? aniListUserId;
  final String? aniListLastSync;
  final String? malToken;
  final String? malRefreshToken;
  final String? malTokenExpiresAt;
  final String? malUsername;
  final String? malLastSync;
  final String? aniListAvatar;
  final String? malAvatar;
  final String? libraryMergePreference;

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
    required this.externalChapterOption,
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
    required this.blockedGenres,
    required this.discoverGenres,
    this.discoverSeason,
    required this.discoverYears,
    required this.discoverTypes,
    required this.discoverStatuses,
    required this.discoverLanguages,
    required this.discoverRatings,
    required this.discoverSources,
    this.discoverMinRange,
    this.discoverMaxRange,
    required this.discoverSortBy,
    required this.discoverIsManga,
    required this.lastHomeTab,
    required this.syncPriority,
    this.dontRemindUpdateDate,
    this.aniListToken,
    this.aniListUsername,
    this.aniListUserId,
    this.aniListLastSync,
    this.malToken,
    this.malRefreshToken,
    this.malTokenExpiresAt,
    this.malUsername,
    this.malLastSync,
    this.aniListAvatar,
    this.malAvatar,
    this.libraryMergePreference,
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
      externalChapterOption: ExternalChapterOption.alwaysAsk,
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
      blockedGenres: const ["Adult", "Ecchi", "Hentai", "Smut"],
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
      discoverIsManga: false,
      lastHomeTab: "anime",
      syncPriority: "ask",
      dontRemindUpdateDate: null,
      aniListToken: null,
      aniListUsername: null,
      aniListUserId: null,
      aniListLastSync: null,
      malToken: null,
      malRefreshToken: null,
      malTokenExpiresAt: null,
      malUsername: null,
      malLastSync: null,
      aniListAvatar: null,
      malAvatar: null,
      libraryMergePreference: null,
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
    ExternalChapterOption? externalChapterOption,
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
    List<String>? blockedGenres,
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
    String? lastHomeTab,
    String? syncPriority,
    String? dontRemindUpdateDate,
    String? aniListToken,
    String? aniListUsername,
    int? aniListUserId,
    String? aniListLastSync,
    String? malToken,
    String? malRefreshToken,
    String? malTokenExpiresAt,
    String? malUsername,
    String? malLastSync,
    String? aniListAvatar,
    String? malAvatar,
    String? libraryMergePreference,
    bool clearSeason = false,
    bool clearMinRange = false,
    bool clearMaxRange = false,
    bool clearAniListToken = false,
    bool clearMalToken = false,
    bool clearLibraryMergePreference = false,
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
      externalChapterOption: externalChapterOption ?? this.externalChapterOption,
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
      blockedGenres: blockedGenres ?? this.blockedGenres,
      discoverGenres: discoverGenres ?? this.discoverGenres,
      discoverSeason: clearSeason ? null : (discoverSeason ?? this.discoverSeason),
      discoverYears: discoverYears ?? this.discoverYears,
      discoverTypes: discoverTypes ?? this.discoverTypes,
      discoverStatuses: discoverStatuses ?? this.discoverStatuses,
      discoverLanguages: discoverLanguages ?? this.discoverLanguages,
      discoverRatings: discoverRatings ?? this.discoverRatings,
      discoverSources: discoverSources ?? this.discoverSources,
      discoverMinRange: clearMinRange ? null : (discoverMinRange ?? this.discoverMinRange),
      discoverMaxRange: clearMaxRange ? null : (discoverMaxRange ?? this.discoverMaxRange),
      discoverSortBy: discoverSortBy ?? this.discoverSortBy,
      discoverIsManga: discoverIsManga ?? this.discoverIsManga,
      lastHomeTab: lastHomeTab ?? this.lastHomeTab,
      syncPriority: syncPriority ?? this.syncPriority,
      dontRemindUpdateDate: dontRemindUpdateDate ?? this.dontRemindUpdateDate,
      aniListToken: clearAniListToken ? null : (aniListToken ?? this.aniListToken),
      aniListUsername: clearAniListToken ? null : (aniListUsername ?? this.aniListUsername),
      aniListUserId: clearAniListToken ? null : (aniListUserId ?? this.aniListUserId),
      aniListLastSync: clearAniListToken ? null : (aniListLastSync ?? this.aniListLastSync),
      malToken: clearMalToken ? null : (malToken ?? this.malToken),
      malRefreshToken: clearMalToken ? null : (malRefreshToken ?? this.malRefreshToken),
      malTokenExpiresAt: clearMalToken ? null : (malTokenExpiresAt ?? this.malTokenExpiresAt),
      malUsername: clearMalToken ? null : (malUsername ?? this.malUsername),
      malLastSync: clearMalToken ? null : (malLastSync ?? this.malLastSync),
      aniListAvatar: clearAniListToken ? null : (aniListAvatar ?? this.aniListAvatar),
      malAvatar: clearMalToken ? null : (malAvatar ?? this.malAvatar),
      libraryMergePreference: clearLibraryMergePreference ? null : (libraryMergePreference ?? this.libraryMergePreference),
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
      'externalChapterOption': externalChapterOption.name,
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
      'blockedGenres': blockedGenres,
      'discoverGenres': discoverGenres,
      'discoverSeason': discoverSeason,
      'discoverYears': discoverYears,
      'discoverTypes': discoverTypes,
      'discoverStatuses': discoverStatuses,
      'discoverLanguages': discoverLanguages,
      'discoverRatings': discoverRatings,
      'discoverSources': discoverSources,
      'discoverMinRange': discoverMinRange,
      'discoverMaxRange': discoverMaxRange,
      'discoverSortBy': discoverSortBy,
      'discoverIsManga': discoverIsManga,
      'lastHomeTab': lastHomeTab,
      'syncPriority': syncPriority,
      'dontRemindUpdateDate': dontRemindUpdateDate,
      'aniListToken': aniListToken,
      'aniListUsername': aniListUsername,
      'aniListUserId': aniListUserId,
      'aniListLastSync': aniListLastSync,
      'malToken': malToken,
      'malRefreshToken': malRefreshToken,
      'malTokenExpiresAt': malTokenExpiresAt,
      'malUsername': malUsername,
      'malLastSync': malLastSync,
      'aniListAvatar': aniListAvatar,
      'malAvatar': malAvatar,
      'libraryMergePreference': libraryMergePreference,
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
    ExternalChapterOption parseExternalChapter(String? val) {
      return ExternalChapterOption.values.firstWhere((e) => e.name == val, orElse: () => ExternalChapterOption.alwaysAsk);
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
      externalChapterOption: parseExternalChapter(json['externalChapterOption']),
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
      blockedGenres: json.containsKey('blockedGenres')
          ? (json['blockedGenres'] as List).map((e) => e.toString()).toList()
          : def.blockedGenres,
      discoverGenres: (json['discoverGenres'] as List?)?.map((e) => e.toString()).toList() ?? def.discoverGenres,
      discoverSeason: json['discoverSeason'] as String?,
      discoverYears: (json['discoverYears'] as List?)?.map((e) => (e as num).toInt()).toList() ?? def.discoverYears,
      discoverTypes: (json['discoverTypes'] as List?)?.map((e) => e.toString()).toList() ?? def.discoverTypes,
      discoverStatuses: (json['discoverStatuses'] as List?)?.map((e) => e.toString()).toList() ?? def.discoverStatuses,
      discoverLanguages: (json['discoverLanguages'] as List?)?.map((e) => e.toString()).toList() ?? def.discoverLanguages,
      discoverRatings: (json['discoverRatings'] as List?)?.map((e) => e.toString()).toList() ?? def.discoverRatings,
      discoverSources: (json['discoverSources'] as List?)?.map((e) => e.toString()).toList() ?? def.discoverSources,
      discoverMinRange: json['discoverMinRange'] as int?,
      discoverMaxRange: json['discoverMaxRange'] as int?,
      discoverSortBy: json['discoverSortBy'] ?? def.discoverSortBy,
      discoverIsManga: json['discoverIsManga'] ?? def.discoverIsManga,
      lastHomeTab: json['lastHomeTab'] ?? def.lastHomeTab,
      syncPriority: json['syncPriority'] ?? def.syncPriority,
      dontRemindUpdateDate: json['dontRemindUpdateDate'] as String?,
      aniListToken: json['aniListToken'] as String?,
      aniListUsername: json['aniListUsername'] as String?,
      aniListUserId: json['aniListUserId'] as int?,
      aniListLastSync: json['aniListLastSync'] as String?,
      malToken: json['malToken'] as String?,
      malRefreshToken: json['malRefreshToken'] as String?,
      malTokenExpiresAt: json['malTokenExpiresAt'] as String?,
      malUsername: json['malUsername'] as String?,
      malLastSync: json['malLastSync'] as String?,
      aniListAvatar: json['aniListAvatar'] as String?,
      malAvatar: json['malAvatar'] as String?,
      libraryMergePreference: json['libraryMergePreference'] as String?,
    );
  }
}

