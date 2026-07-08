import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';

import '../models/app_settings.dart';
import '../providers/settings_provider.dart';
import '../../../core/database/isar_service.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../../tracker/models/watch_progress.dart';
import '../../tracker/models/reading_progress.dart';
import '../../favorites/models/favorite_anime.dart';
import '../../favorites/models/favorite_manga.dart';

// ==========================================================================
// MAIN SETTINGS SCREEN
// ==========================================================================

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("⚙️ Settings"),
        centerTitle: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          // Grouped Settings List
          _buildSectionHeader(context, "Preferences"),
          const SizedBox(height: 8),
          _buildMenuCard(
            context,
            children: [
              _buildMenuTile(
                context,
                icon: Icons.palette_outlined,
                title: "Appearance & Theme",
                subtitle: _getAppearanceSubtitle(settings),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppearanceSettingsPage()),
                ),
              ),
              _buildMenuTile(
                context,
                icon: Icons.play_circle_outline_rounded,
                title: "Anime Playback",
                subtitle: "Quality, audio preferences & speed",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlaybackSettingsPage()),
                ),
              ),
              _buildMenuTile(
                context,
                icon: Icons.chrome_reader_mode_outlined,
                title: "Manga Reader",
                subtitle: "Direction, page mode & zoom",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MangaSettingsPage()),
                ),
              ),
              _buildMenuTile(
                context,
                icon: Icons.filter_alt_outlined,
                title: "Content Filters",
                subtitle: "Manage blocked genres",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContentFiltersSettingsPage()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildSectionHeader(context, "System & Data"),
          const SizedBox(height: 8),
          _buildMenuCard(
            context,
            children: [
              _buildMenuTile(
                context,
                icon: Icons.notifications_none_rounded,
                title: "Notifications",
                subtitle: "Manage alert preferences",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
                ),
              ),

              _buildMenuTile(
                context,
                icon: Icons.storage_rounded,
                title: "Cache Manager",
                subtitle: "Calculates and clears app caches",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CacheSettingsPage()),
                ),
              ),
              _buildMenuTile(
                context,
                icon: Icons.backup_rounded,
                title: "Backup & Restore",
                subtitle: "Export/Import settings & progress",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BackupSettingsPage()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ❤️ Credits & Acknowledgements section
          _buildSectionHeader(context, "❤️ Credits & Acknowledgements"),
          const SizedBox(height: 8),
          _buildCreditsCards(context),

          const SizedBox(height: 32),

          // Footer
          Center(
            child: Text(
              "AniVerse v1.0.0",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  String _getAppearanceSubtitle(AppSettings settings) {
    final themeStr = settings.themeOption.name[0].toUpperCase() + settings.themeOption.name.substring(1);
    final amoledStr = settings.amoledTheme ? " + AMOLED" : "";
    return "$themeStr$amoledStr (${settings.accentColor.name})";
  }



  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 50.ms);
  }

  Widget _buildMenuCard(BuildContext context, {required List<Widget> children}) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: children,
      ),
    ).animate().fadeIn(duration: 450.ms, delay: 100.ms).slideX(begin: 0.03, end: 0);
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildCreditsCards(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    final cardAnikoto = _buildSingleCreditCard(
      context,
      title: "Anikoto",
      message: '"Thank you for providing a free anime streaming API."',
      icon: Icons.play_circle_outline_rounded,
    ).animate().fadeIn(duration: 500.ms, delay: 150.ms).slideY(begin: 0.1, end: 0);

    final cardMangaDex = _buildSingleCreditCard(
      context,
      title: "MangaDex",
      message: '"Thank you for providing a free manga API and reader services."',
      icon: Icons.chrome_reader_mode_outlined,
    ).animate().fadeIn(duration: 500.ms, delay: 250.ms).slideY(begin: 0.1, end: 0);

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: cardAnikoto),
          const SizedBox(width: 16),
          Expanded(child: cardMangaDex),
        ],
      );
    } else {
      return Column(
        children: [
          cardAnikoto,
          const SizedBox(height: 12),
          cardMangaDex,
        ],
      );
    }
  }

  Widget _buildSingleCreditCard(
    BuildContext context, {
    required String title,
    required String message,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: isDark ? 2 : 1,
      shadowColor: isDark ? Colors.black38 : Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    theme.colorScheme.surface,
                    theme.colorScheme.surface.withValues(alpha: 0.85),
                  ]
                : [
                    Colors.white,
                    theme.colorScheme.surface.withValues(alpha: 0.95),
                  ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================================
// APPEARANCE & THEME SUB-PAGE
// ==========================================================================

class AppearanceSettingsPage extends ConsumerWidget {
  const AppearanceSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance & Theme"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          // Theme Option Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("App Theme", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...ThemeOption.values.map((opt) {
                    final isSelected = settings.themeOption == opt;
                    final label = opt.name == 'system' ? 'System Default' : opt.name[0].toUpperCase() + opt.name.substring(1);
                    return ListTile(
                      title: Text(label),
                      trailing: isSelected ? Icon(Icons.check_rounded, color: theme.colorScheme.primary) : null,
                      onTap: () => notifier.setThemeOption(opt),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // AMOLED & Material You Card
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_rounded),
                  title: const Text("AMOLED Dark Mode"),
                  subtitle: const Text("Pure black backgrounds for OLED screens"),
                  value: settings.amoledTheme,
                  onChanged: (val) => notifier.setAmoledTheme(val),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.color_lens_rounded),
                  title: const Text("Material You Colors"),
                  subtitle: const Text("Dynamic accent colors on Android 12+"),
                  value: settings.materialYou,
                  onChanged: (val) => notifier.setMaterialYou(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Accent Color Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Accent Color", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: AccentColorOption.values.map((colorOpt) {
                      final isSelected = settings.accentColor == colorOpt;
                      final label = colorOpt.name == 'dynamicColor' ? 'Dynamic' : colorOpt.name[0].toUpperCase() + colorOpt.name.substring(1);
                      return ChoiceChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) notifier.setAccentColor(colorOpt);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // UI Density Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("UI Layout Density", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...UiDensityOption.values.map((density) {
                    final isSelected = settings.uiDensity == density;
                    final label = density.name[0].toUpperCase() + density.name.substring(1);
                    return ListTile(
                      title: Text(label),
                      trailing: isSelected ? Icon(Icons.check_rounded, color: theme.colorScheme.primary) : null,
                      onTap: () => notifier.setUiDensity(density),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// ANIME PLAYBACK SUB-PAGE
// ==========================================================================

class PlaybackSettingsPage extends ConsumerWidget {
  const PlaybackSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Anime Playback"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          // Quality & Audio
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preferred Video Quality", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<VideoQualityOption>(
                    initialValue: settings.defaultVideoQuality,
                    decoration: const InputDecoration(labelText: "Default Quality"),
                    items: VideoQualityOption.values.map((q) {
                      final label = q == VideoQualityOption.auto ? "Auto" : q.name.substring(1);
                      return DropdownMenuItem(value: q, child: Text(label));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) notifier.setDefaultVideoQuality(val);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text("Preferred Audio", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: AudioOption.values.map((aud) {
                      final label = aud.name.toUpperCase();
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: settings.defaultAudio == aud,
                          onSelected: (selected) {
                            if (selected) notifier.setDefaultAudio(aud);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Playback Behaviors
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.playlist_play_rounded),
                  title: const Text("Auto Next Episode"),
                  subtitle: const Text("Starts counting down to the next episode automatically"),
                  value: settings.autoNextEpisode,
                  onChanged: (val) => notifier.setAutoNextEpisode(val),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.fullscreen_rounded),
                  title: const Text("Auto Fullscreen"),
                  subtitle: const Text("Rotate player automatically on launch"),
                  value: settings.autoFullscreen,
                  onChanged: (val) => notifier.setAutoFullscreen(val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Playback Speed
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Default Playback Speed", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Slider(
                    value: settings.playbackSpeed,
                    min: 0.5,
                    max: 2.0,
                    divisions: 6,
                    label: "${settings.playbackSpeed}x",
                    onChanged: (val) => notifier.setPlaybackSpeed(val),
                  ),
                  Center(
                    child: Text(
                      "Current Speed: ${settings.playbackSpeed}x",
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Preferred Server
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Preferred Streaming Server", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: settings.preferredStreamingServer,
                    decoration: const InputDecoration(labelText: "Primary Server"),
                    items: const [
                      DropdownMenuItem(value: "Anikoto", child: Text("Anikoto (Megaplay)")),
                      DropdownMenuItem(value: "Vidstreaming", child: Text("Vidstreaming (Backup)")),
                    ],
                    onChanged: (val) {
                      if (val != null) notifier.setPreferredStreamingServer(val);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// MANGA READER SUB-PAGE
// ==========================================================================

class MangaSettingsPage extends ConsumerWidget {
  const MangaSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Manga Reader"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          // Direction and Mode Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reading Mode", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<ReadingDirectionOption>(
                    initialValue: settings.readingDirection,
                    decoration: const InputDecoration(labelText: "Reading Mode"),
                    items: ReadingDirectionOption.values.map((dir) {
                      final label = dir.name[0].toUpperCase() + dir.name.substring(1);
                      return DropdownMenuItem(value: dir, child: Text(label));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) notifier.setReadingDirection(val);
                    },
                  ),
                  const SizedBox(height: 20),
                  Text("Page Progression Mode", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<ReadingModeOption>(
                    initialValue: settings.readingMode,
                    decoration: const InputDecoration(labelText: "Layout Pattern"),
                    items: ReadingModeOption.values.map((m) {
                      final label = m == ReadingModeOption.pageByPage ? "Page by Page" : "Continuous Scroll";
                      return DropdownMenuItem(value: m, child: Text(label));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) notifier.setReadingMode(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Image Quality Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Image Loading Quality", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8.0,
                    children: ImageQualityOption.values.map((q) {
                      final label = q == ImageQualityOption.dataSaver ? "Data Saver" : q.name[0].toUpperCase() + q.name.substring(1);
                      return ChoiceChip(
                        label: Text(label),
                        selected: settings.imageQuality == q,
                        onSelected: (selected) {
                          if (selected) notifier.setImageQuality(q);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Reader Behaviors
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.download_for_offline_rounded),
                  title: const Text("Preload Pages"),
                  subtitle: const Text("Cache subsequent pages in background while reading"),
                  value: settings.preloadPages,
                  onChanged: (val) => notifier.setPreloadPages(val),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.zoom_in_rounded),
                  title: const Text("Double Tap Zoom"),
                  subtitle: const Text("Zoom in automatically when double tapping pages"),
                  value: settings.doubleTapZoom,
                  onChanged: (val) => notifier.setDoubleTapZoom(val),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.screen_lock_rotation_rounded),
                  title: const Text("Keep Screen On"),
                  subtitle: const Text("Prevent screen sleep during reading"),
                  value: settings.keepScreenOn,
                  onChanged: (val) => notifier.setKeepScreenOn(val),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.history_rounded),
                  title: const Text("Remember Last Page"),
                  subtitle: const Text("Restores reading position on chapter reload"),
                  value: settings.rememberLastPage,
                  onChanged: (val) => notifier.setRememberLastPage(val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// NOTIFICATIONS SUB-PAGE
// ==========================================================================

class NotificationSettingsPage extends ConsumerWidget {
  const NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.movie_filter_rounded),
                  title: const Text("New Anime Episodes"),
                  subtitle: const Text("Notify when tracked anime releases a new episode"),
                  value: settings.notifyNewEpisodes,
                  onChanged: (val) => notifier.setNotifyNewEpisodes(val),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.library_books_rounded),
                  title: const Text("New Manga Chapters"),
                  subtitle: const Text("Notify when tracked manga receives an update"),
                  value: settings.notifyNewChapters,
                  onChanged: (val) => notifier.setNotifyNewChapters(val),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.ondemand_video_rounded),
                  title: const Text("Continue Watching Reminder"),
                  subtitle: const Text("Reminds to finish watching unfinished anime titles"),
                  value: settings.notifyContinueWatching,
                  onChanged: (val) => notifier.setNotifyContinueWatching(val),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.menu_book_rounded),
                  title: const Text("Continue Reading Reminder"),
                  subtitle: const Text("Reminds to finish reading in-progress manga volumes"),
                  value: settings.notifyContinueReading,
                  onChanged: (val) => notifier.setNotifyContinueReading(val),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.system_update_rounded),
                  title: const Text("App Updates"),
                  subtitle: const Text("Notify when a new AniVerse version is available"),
                  value: settings.notifyAppUpdates,
                  onChanged: (val) => notifier.setNotifyAppUpdates(val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ==========================================================================
// CACHE MANAGER SUB-PAGE
// ==========================================================================

class CacheSettingsPage extends StatefulWidget {
  const CacheSettingsPage({super.key});

  @override
  State<CacheSettingsPage> createState() => _CacheSettingsPageState();
}

class _CacheSettingsPageState extends State<CacheSettingsPage> {
  double _imgSize = 0.0;
  double _vidSize = 0.0;
  double _mangaSize = 0.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCacheSizes();
  }

  Future<void> _loadCacheSizes() async {
    setState(() => _loading = true);
    final img = await CacheManager.getImageCacheSize();
    final vid = await CacheManager.getVideoCacheSize();
    final manga = await CacheManager.getMangaCacheSize();
    if (mounted) {
      setState(() {
        _imgSize = img;
        _vidSize = vid;
        _mangaSize = manga;
        _loading = false;
      });
    }
  }

  Future<void> _confirmClear(String cacheTitle, Future<void> Function() clearAction) async {
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Clear $cacheTitle?"),
        content: Text("Are you sure you want to delete all stored data for $cacheTitle? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            child: const Text("Clear"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _loading = true);
      await clearAction();
      await _loadCacheSizes();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$cacheTitle Cleared successfully")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double totalSize = _imgSize + _vidSize + _mangaSize;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cache Manager"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              children: [
                // Total Cache Size Hero
                Card(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                    child: Column(
                      children: [
                        Text("Total Cached Data", style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text(
                          "${totalSize.toStringAsFixed(2)} MB",
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cache detail listings
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.image_outlined),
                        title: const Text("Image Cache"),
                        trailing: Text(
                          "${_imgSize.toStringAsFixed(2)} MB",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("Posters, cover images & banner graphics"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.play_circle_outline_rounded),
                        title: const Text("Video Cache"),
                        trailing: Text(
                          "${_vidSize.toStringAsFixed(2)} MB",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("Buffered episode segments & logs"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.menu_book_outlined),
                        title: const Text("Manga Cache"),
                        trailing: Text(
                          "${_mangaSize.toStringAsFixed(2)} MB",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("Downloaded pages & OCR translations"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Management Actions
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cleanup Actions", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.image_rounded),
                            label: const Text("Clear Image Cache"),
                            onPressed: () => _confirmClear("Image Cache", CacheManager.clearImageCache),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text("Clear Video Cache"),
                            onPressed: () => _confirmClear("Video Cache", CacheManager.clearVideoCache),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.book_rounded),
                            label: const Text("Clear Manga Cache"),
                            onPressed: () => _confirmClear("Manga Cache", CacheManager.clearMangaCache),
                          ),
                        ),
                        const Divider(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            icon: const Icon(Icons.delete_forever_rounded),
                            label: const Text("Clear All Cache"),
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.error,
                              foregroundColor: theme.colorScheme.onError,
                            ),
                            onPressed: () => _confirmClear("All Cache", () async {
                              await CacheManager.clearImageCache();
                              await CacheManager.clearVideoCache();
                              await CacheManager.clearMangaCache();
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

// ==========================================================================
// BACKUP & RESTORE SUB-PAGE
// ==========================================================================

class BackupSettingsPage extends StatefulWidget {
  const BackupSettingsPage({super.key});

  @override
  State<BackupSettingsPage> createState() => _BackupSettingsPageState();
}

class _BackupSettingsPageState extends State<BackupSettingsPage> {
  final TextEditingController _jsonController = TextEditingController();
  bool _working = false;
  String _backupPath = "";

  @override
  void initState() {
    super.initState();
    _loadBackupPath();
  }

  Future<void> _loadBackupPath() async {
    final docDir = await getApplicationDocumentsDirectory();
    setState(() {
      _backupPath = '${docDir.path}/aniverse_backup.json';
    });
  }

  Future<void> _exportBackup(WidgetRef ref) async {
    setState(() => _working = true);
    try {
      final json = await BackupService.exportBackup(ref);
      _jsonController.text = json;
      await Clipboard.setData(ClipboardData(text: json));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Backup saved to documents and copied to clipboard!\nPath: $_backupPath")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Export failed: $e")),
        );
      }
    } finally {
      setState(() => _working = false);
    }
  }

  Future<void> _importBackup(WidgetRef ref) async {
    final text = _jsonController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please paste the backup JSON text first.")),
      );
      return;
    }

    setState(() => _working = true);
    try {
      await BackupService.restoreBackup(text, ref);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Backup restored successfully!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Restore failed: $e")),
        );
      }
    } finally {
      setState(() => _working = false);
    }
  }

  Future<void> _importFromFile(WidgetRef ref) async {
    setState(() => _working = true);
    try {
      final file = File(_backupPath);
      if (await file.exists()) {
        final content = await file.readAsString();
        _jsonController.text = content;
        await BackupService.restoreBackup(content, ref);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Backup restored from file successfully!")),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No backup file found in documents directory.")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Restore failed: $e")),
        );
      }
    } finally {
      setState(() => _working = false);
    }
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup & Restore"),
      ),
      body: _working
          ? const Center(child: CircularProgressIndicator())
          : Consumer(
              builder: (context, ref, child) {
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Export Section
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Create Backup", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text(
                              "Generates a complete backup of settings, favorites, and tracking progress in JSON format.",
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                icon: const Icon(Icons.download_rounded),
                                label: const Text("Export Backup Payload"),
                                onPressed: () => _exportBackup(ref),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Paste Restoring
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Restore Backup", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            const Text(
                              "Paste exported JSON text or load the local document file directly.",
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _jsonController,
                              maxLines: 6,
                              decoration: const InputDecoration(
                                hintText: "Paste backup JSON here...",
                                alignLabelWithHint: true,
                              ),
                              style: const TextStyle(fontFamily: "monospace", fontSize: 11),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.file_open_rounded),
                                    label: const Text("Load File"),
                                    onPressed: () => _importFromFile(ref),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: FilledButton.icon(
                                    icon: const Icon(Icons.upload_rounded),
                                    label: const Text("Restore JSON"),
                                    onPressed: () => _importBackup(ref),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Future Cloud placeholder
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_queue_rounded, size: 16, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            "Cloud Sync ready (Sprint 13 Preview)",
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

// ==========================================================================
// HELPERS - CACHE MANAGER & BACKUP SERVICE
// ==========================================================================

class CacheManager {
  static Future<double> getImageCacheSize() async {
    final tempDir = await getTemporaryDirectory();
    final size = await _getDirSize(tempDir);
    return size / (1024 * 1024); // MB
  }

  static Future<double> getVideoCacheSize() async {
    return 0.0;
  }

  static Future<double> getMangaCacheSize() async {
    double size = 0.0;
    
    // 1. Translation cache
    final tempDir = await getTemporaryDirectory();
    final transCacheFile = File('${tempDir.path}/translation_cache.json');
    if (await transCacheFile.exists()) {
      final len = await transCacheFile.length();
      size += len;
    }
    
    // 2. Chapter cache
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${docsDir.path}/chapter_cache');
      if (await cacheDir.exists()) {
        size += await _getDirSize(cacheDir);
      }
    } catch (_) {}
    
    return size / (1024 * 1024); // MB
  }

  static Future<void> clearImageCache() async {
    final tempDir = await getTemporaryDirectory();
    if (await tempDir.exists()) {
      await for (final file in tempDir.list()) {
        try {
          if (file is File && !file.path.endsWith('.json')) {
            await file.delete();
          } else if (file is Directory) {
            await file.delete(recursive: true);
          }
        } catch (_) {}
      }
    }
    PaintingBinding.instance.imageCache.clear();
  }

  static Future<void> clearVideoCache() async {
    // Mock video cache clear
  }

  static Future<void> clearMangaCache() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${docsDir.path}/chapter_cache');
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
      }
    } catch (_) {}
  }

  static Future<int> _getDirSize(Directory dir) async {
    int total = 0;
    try {
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            total += await entity.length();
          }
        }
      }
    } catch (_) {}
    return total;
  }
}

class BackupService {
  static Future<String> exportBackup(WidgetRef ref) async {
    final isar = IsarService.instance;
    final settings = ref.read(settingsNotifierProvider);

    final favAnime = await isar.collection<FavoriteAnime>().where().findAll();
    final favManga = await isar.collection<FavoriteManga>().where().findAll();
    final watchProg = await isar.collection<WatchProgress>().where().findAll();
    final readProg = await isar.collection<ReadingProgress>().where().findAll();

    final payload = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': settings.toJson(),
      'favorites_anime': favAnime.map((e) => {
        'animeId': e.animeId,
        'romajiTitle': e.romajiTitle,
        'englishTitle': e.englishTitle,
        'coverImage': e.coverImage,
        'bannerImage': e.bannerImage,
        'averageScore': e.averageScore,
        'episodes': e.episodes,
        'status': e.status,
        'studio': e.studio,
        'season': e.season,
        'seasonYear': e.seasonYear,
        'addedAt': e.addedAt.toIso8601String(),
      }).toList(),
      'favorites_manga': favManga.map((e) => {
        'mangaId': e.mangaId,
        'romajiTitle': e.romajiTitle,
        'englishTitle': e.englishTitle,
        'coverImage': e.coverImage,
        'bannerImage': e.bannerImage,
        'chapters': e.chapters,
        'volumes': e.volumes,
        'status': e.status,
        'author': e.author,
        'addedAt': e.addedAt.toIso8601String(),
      }).toList(),
      'watch_progress': watchProg.map((e) => {
        'animeId': e.animeId,
        'malId': e.malId,
        'romajiTitle': e.romajiTitle,
        'englishTitle': e.englishTitle,
        'coverImage': e.coverImage,
        'bannerImage': e.bannerImage,
        'totalEpisodes': e.totalEpisodes,
        'lastWatchedEpisode': e.lastWatchedEpisode,
        'lastWatchedPosition': e.lastWatchedPosition,
        'lastWatchedDuration': e.lastWatchedDuration,
        'watchPercentage': e.watchPercentage,
        'lastWatchedSource': e.lastWatchedSource,
        'lastWatchedAudio': e.lastWatchedAudio,
        'lastWatchedAt': e.lastWatchedAt.toIso8601String(),
        'completedEpisodes': e.completedEpisodes,
        'status': e.status,
        'score': e.score,
        'dateStarted': e.dateStarted?.toIso8601String(),
        'dateFinished': e.dateFinished?.toIso8601String(),
        'rewatchCount': e.rewatchCount,
        'notes': e.notes,
        'genres': e.genres,
        'studio': e.studio,
      }).toList(),
      'reading_progress': readProg.map((e) => {
        'mangaId': e.mangaId,
        'romajiTitle': e.romajiTitle,
        'englishTitle': e.englishTitle,
        'coverImage': e.coverImage,
        'bannerImage': e.bannerImage,
        'totalChapters': e.totalChapters,
        'lastReadChapter': e.lastReadChapter,
        'lastReadPage': e.lastReadPage,
        'readingPercentage': e.readingPercentage,
        'lastReadAt': e.lastReadAt.toIso8601String(),
        'completedChapters': e.completedChapters,
        'status': e.status,
        'score': e.score,
        'dateStarted': e.dateStarted?.toIso8601String(),
        'dateFinished': e.dateFinished?.toIso8601String(),
        'rereadCount': e.rereadCount,
        'notes': e.notes,
        'lastReadVolume': e.lastReadVolume,
        'totalVolumes': e.totalVolumes,
        'genres': e.genres,
        'author': e.author,
      }).toList(),
    };

    final jsonStr = jsonEncode(payload);

    final documentsDir = await getApplicationDocumentsDirectory();
    final file = File('${documentsDir.path}/aniverse_backup.json');
    await file.writeAsString(jsonStr);

    return jsonStr;
  }

  static Future<void> restoreBackup(String jsonStr, WidgetRef ref) async {
    final Map<String, dynamic> payload = jsonDecode(jsonStr);
    final isar = IsarService.instance;

    await isar.writeTxn(() async {
      await isar.collection<FavoriteAnime>().clear();
      await isar.collection<FavoriteManga>().clear();
      await isar.collection<WatchProgress>().clear();
      await isar.collection<ReadingProgress>().clear();

      if (payload.containsKey('settings')) {
        final settings = AppSettings.fromJson(payload['settings']);
        await ref.read(settingsNotifierProvider.notifier).updateSettings(settings);
      }

      if (payload.containsKey('favorites_anime')) {
        final list = payload['favorites_anime'] as List;
        for (final item in list) {
          final anime = FavoriteAnime()
            ..animeId = item['animeId']
            ..romajiTitle = item['romajiTitle']
            ..englishTitle = item['englishTitle']
            ..coverImage = item['coverImage']
            ..bannerImage = item['bannerImage']
            ..averageScore = item['averageScore']
            ..episodes = item['episodes']
            ..status = item['status']
            ..studio = item['studio']
            ..season = item['season']
            ..seasonYear = item['seasonYear']
            ..addedAt = DateTime.tryParse(item['addedAt'] ?? '') ?? DateTime.now();
          await isar.collection<FavoriteAnime>().put(anime);
        }
      }

      if (payload.containsKey('favorites_manga')) {
        final list = payload['favorites_manga'] as List;
        for (final item in list) {
          final manga = FavoriteManga()
            ..mangaId = item['mangaId']
            ..romajiTitle = item['romajiTitle']
            ..englishTitle = item['englishTitle']
            ..coverImage = item['coverImage']
            ..bannerImage = item['bannerImage']
            ..chapters = item['chapters']
            ..volumes = item['volumes']
            ..status = item['status']
            ..author = item['author']
            ..addedAt = DateTime.tryParse(item['addedAt'] ?? '') ?? DateTime.now();
          await isar.collection<FavoriteManga>().put(manga);
        }
      }

      if (payload.containsKey('watch_progress')) {
        final list = payload['watch_progress'] as List;
        for (final item in list) {
          // Exclude the reserved settings record itself
          if (item['animeId'] == -999) continue;
          final watch = WatchProgress()
            ..animeId = item['animeId']
            ..malId = item['malId']
            ..romajiTitle = item['romajiTitle']
            ..englishTitle = item['englishTitle']
            ..coverImage = item['coverImage']
            ..bannerImage = item['bannerImage']
            ..totalEpisodes = item['totalEpisodes'] ?? 0
            ..lastWatchedEpisode = item['lastWatchedEpisode']
            ..lastWatchedPosition = item['lastWatchedPosition']
            ..lastWatchedDuration = item['lastWatchedDuration']
            ..watchPercentage = (item['watchPercentage'] as num?)?.toDouble() ?? 0.0
            ..lastWatchedSource = item['lastWatchedSource'] ?? ''
            ..lastWatchedAudio = item['lastWatchedAudio'] ?? ''
            ..lastWatchedAt = DateTime.tryParse(item['lastWatchedAt'] ?? '') ?? DateTime.now()
            ..completedEpisodes = List<int>.from(item['completedEpisodes'] ?? [])
            ..status = item['status']
            ..score = item['score']
            ..dateStarted = DateTime.tryParse(item['dateStarted'] ?? '')
            ..dateFinished = DateTime.tryParse(item['dateFinished'] ?? '')
            ..rewatchCount = item['rewatchCount'] ?? 0
            ..notes = item['notes']
            ..genres = List<String>.from(item['genres'] ?? [])
            ..studio = item['studio'];
          await isar.collection<WatchProgress>().put(watch);
        }
      }

      if (payload.containsKey('reading_progress')) {
        final list = payload['reading_progress'] as List;
        for (final item in list) {
          final read = ReadingProgress()
            ..mangaId = item['mangaId']
            ..romajiTitle = item['romajiTitle']
            ..englishTitle = item['englishTitle']
            ..coverImage = item['coverImage']
            ..bannerImage = item['bannerImage']
            ..totalChapters = item['totalChapters']
            ..lastReadChapter = item['lastReadChapter']
            ..lastReadPage = item['lastReadPage']
            ..readingPercentage = (item['readingPercentage'] as num?)?.toDouble() ?? 0.0
            ..lastReadAt = DateTime.tryParse(item['lastReadAt'] ?? '') ?? DateTime.now()
            ..completedChapters = List<int>.from(item['completedChapters'] ?? [])
            ..status = item['status']
            ..score = item['score']
            ..dateStarted = DateTime.tryParse(item['dateStarted'] ?? '')
            ..dateFinished = DateTime.tryParse(item['dateFinished'] ?? '')
            ..rereadCount = item['rereadCount'] ?? 0
            ..notes = item['notes']
            ..lastReadVolume = item['lastReadVolume'] ?? 0
            ..totalVolumes = item['totalVolumes']
            ..genres = List<String>.from(item['genres'] ?? [])
            ..author = item['author'];
          await isar.collection<ReadingProgress>().put(read);
        }
      }
    });

    ref.invalidate(continueWatchingProvider);
    ref.invalidate(continueReadingProvider);
  }
}

// ==========================================================================
// CONTENT FILTERS SUB-PAGE
// ==========================================================================

class ContentFiltersSettingsPage extends ConsumerStatefulWidget {
  const ContentFiltersSettingsPage({super.key});

  @override
  ConsumerState<ContentFiltersSettingsPage> createState() => _ContentFiltersSettingsPageState();
}

class _ContentFiltersSettingsPageState extends ConsumerState<ContentFiltersSettingsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  static const List<String> _allGenres = [
    "Action",
    "Adult",
    "Adventure",
    "Avant Garde",
    "Boys Love",
    "Comedy",
    "Crime",
    "Demons",
    "Drama",
    "Ecchi",
    "Fantasy",
    "Girls Love",
    "Gourmet",
    "Harem",
    "Hentai",
    "Historical",
    "Horror",
    "Iyashikei",
    "Isekai",
    "Josei",
    "Kids",
    "Magic",
    "Magical Girls",
    "Mahou Shoujo",
    "Martial Arts",
    "Mature",
    "Mecha",
    "Medical",
    "Military",
    "Music",
    "Mystery",
    "Parody",
    "Philosophical",
    "Police",
    "Psychological",
    "Reverse Harem",
    "Romance",
    "School",
    "Sci-Fi",
    "Seinen",
    "Shoujo",
    "Shoujo Ai",
    "Shounen",
    "Shounen Ai",
    "Slice of Life",
    "Smut",
    "Space",
    "Sports",
    "Super Power",
    "Superhero",
    "Supernatural",
    "Suspense",
    "Thriller",
    "Tragedy",
    "Vampire",
    "Wuxia",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsNotifierProvider);
    final blockedGenres = settings.blockedGenres;
    final notifier = ref.read(settingsNotifierProvider.notifier);

    final filteredGenres = _allGenres
        .where((genre) => genre.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("🚫 Blocked Genres"),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Genres selected here will not appear in Home, Discover, Search, Recommendations, Trending, Continue Watching, Continue Reading, Related Anime, Related Manga, or Notifications.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search genres...",
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = "";
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.12),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: () {
                          notifier.setBlockedGenres(List<String>.from(_allGenres));
                        },
                        icon: const Icon(Icons.select_all_rounded, size: 18),
                        label: const Text("Select All"),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          notifier.setBlockedGenres(const []);
                        },
                        icon: const Icon(Icons.clear_all_rounded, size: 18),
                        label: const Text("Clear All"),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          notifier.setBlockedGenres(const ["Adult", "Ecchi", "Hentai", "Smut"]);
                        },
                        icon: const Icon(Icons.restore_rounded, size: 18),
                        label: const Text("Reset to Default"),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),
          const Divider(),
          Expanded(
            child: filteredGenres.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No genres found matching \"$_searchQuery\"",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms)
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3.5,
                    ),
                    itemCount: filteredGenres.length,
                    itemBuilder: (context, index) {
                      final genre = filteredGenres[index];
                      final isBlocked = blockedGenres.contains(genre);
                      return _buildGenreCard(context, genre, isBlocked, blockedGenres, notifier, theme, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreCard(
    BuildContext context,
    String genre,
    bool isBlocked,
    List<String> blockedGenres,
    SettingsNotifier notifier,
    ThemeData theme,
    int index,
  ) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: isBlocked
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.12)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isBlocked
              ? theme.colorScheme.primary.withValues(alpha: 0.3)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.15),
        ),
      ),
      child: InkWell(
        onTap: () {
          final newBlocked = List<String>.from(blockedGenres);
          if (isBlocked) {
            newBlocked.remove(genre);
          } else {
            newBlocked.add(genre);
          }
          notifier.setBlockedGenres(newBlocked);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Row(
            children: [
              Checkbox(
                value: isBlocked,
                activeColor: theme.colorScheme.primary,
                onChanged: (val) {
                  final newBlocked = List<String>.from(blockedGenres);
                  if (isBlocked) {
                    newBlocked.remove(genre);
                  } else {
                    newBlocked.add(genre);
                  }
                  notifier.setBlockedGenres(newBlocked);
                },
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  genre,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isBlocked ? FontWeight.bold : FontWeight.normal,
                    color: isBlocked ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 250.ms, delay: (10 * (index % 10)).ms);
  }
}