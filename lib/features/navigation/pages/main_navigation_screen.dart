import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../discover/pages/discover_screen.dart';
import '../../favorites/pages/favorites_screen.dart';
import '../../home/pages/home_screen.dart';
import '../../settings/pages/settings_screen.dart';
import '../../tracker/pages/tracker_screen.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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