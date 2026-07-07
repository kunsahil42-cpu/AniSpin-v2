import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';
import '../features/settings/providers/settings_provider.dart';
import '../features/settings/models/app_settings.dart';

class AniSpinApp extends ConsumerWidget {
  const AniSpinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    final lightTheme = AppTheme.buildTheme(
      brightness: Brightness.light,
      settings: settings,
    );

    final darkTheme = AppTheme.buildTheme(
      brightness: Brightness.dark,
      settings: settings,
    );

    ThemeMode themeMode;
    switch (settings.themeOption) {
      case ThemeOption.light:
        themeMode = ThemeMode.light;
        break;
      case ThemeOption.dark:
        themeMode = ThemeMode.dark;
        break;
      case ThemeOption.system:
        themeMode = ThemeMode.system;
        break;
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AniSpin',

      // Theme
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,

      // Router
      routerConfig: appRouter,

      // Material 3
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
    );
  }
}