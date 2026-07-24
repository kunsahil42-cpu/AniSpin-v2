class ApiConfig {
  // OAuth credentials
  // These can be replaced with official credentials when deploying
  static const String aniListClientId = "23136"; // AniList Client ID
  static const String aniListRedirectUri = "https://anilist.co/api/v2/oauth/pin";

  static const String malClientId = "b6ca8d882ffdc440fbca9354e0bafc72"; // MyAnimeList Client ID
  static const String malClientSecret = "422168ddf5a87441bbef66ab4cb46123d954a853f2f7737ba80a5870e2a3084f"; // MAL Client Secret
  static const String malRedirectUri = "anispin://auth/mal/callback";

  // Official links provided by the user
  static const String githubRepoUrl = "https://github.com/kunsahil42-cpu/AniSpin-v2.git";
  static const String githubReleasesUrl = "https://github.com/kunsahil42-cpu/AniSpin-v2/releases";
  static const String apkDownloadSourceUrl = "https://github.com/kunsahil42-cpu/AniSpin-v2/releases";
  static const String telegramChannelUrl = "https://t.me/anispinapp";
  static const String redditCommunityUrl = "https://www.reddit.com/r/AnispinOffical";
}
