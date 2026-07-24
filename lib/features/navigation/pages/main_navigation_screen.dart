import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../discover/pages/discover_screen.dart';
import '../../favorites/pages/favorites_screen.dart';
import '../../home/pages/home_screen.dart';
import '../../settings/pages/settings_screen.dart';
import '../../tracker/pages/tracker_screen.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../settings/providers/settings_provider.dart';
import '../../../core/update/update_checker.dart';
import '../../../core/sync/sync_service.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdates();
      _triggerBackgroundSync();
    });
  }

  Future<void> _checkForUpdates() async {
    try {
      final settings = ref.read(settingsNotifierProvider);
      final today = DateTime.now().toIso8601String().substring(0, 10);
      
      // Do not prompt if reminded today
      if (settings.dontRemindUpdateDate == today) {
        return;
      }
      
      final info = await UpdateChecker.checkForUpdates();
      if (info.isUpdateAvailable && mounted) {
        _showUpdatePopup(info, today);
      }
    } catch (_) {}
  }

  void _showUpdatePopup(AppUpdateInfo info, String today) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Update Available!"),
        content: Text("AniSpin ${info.latestVersion} is available."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final settings = ref.read(settingsNotifierProvider);
              ref.read(settingsNotifierProvider.notifier).updateSettings(
                settings.copyWith(dontRemindUpdateDate: today),
              );
            },
            child: const Text("Don't remind me today"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Later"),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final uri = Uri.parse(info.downloadUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: const Text("Update Now"),
          ),
        ],
      ),
    );
  }

  void _triggerBackgroundSync() {
    try {
      ref.read(syncServiceProvider).triggerBackgroundSync();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationIndexProvider);

    const screens = [
      HomeScreen(),
      DiscoverScreen(),
      FavoritesScreen(),
      TrackerScreen(),
      SettingsScreen(),
    ];

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        ref.read(navigationIndexProvider.notifier).state = 0;
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: screens,
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}