import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/database/isar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 80 * 1024 * 1024; // 80MB

  // Global safety net: any framework or async error is logged in debug only,
  // never surfaced to users as a red screen or raw stack trace. User-facing
  // errors are handled gracefully by AsyncNetworkView / AppFailure instead.
  FlutterError.onError = (details) {
    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      debugPrint('[Uncaught] $error');
    }
    return true; // handled — do not crash the app
  };

  await IsarService.open();

  try {
    const sourcePath = r'C:\Users\sahil\.gemini\antigravity-ide\brain\759d018e-4259-41b0-bdd2-70e0d654aabb\media__1784555159065.jpg';
    final sourceFile = File(sourcePath);
    if (sourceFile.existsSync()) {
      final iconsDir = Directory('assets/icons');
      if (!iconsDir.existsSync()) {
        iconsDir.createSync(recursive: true);
      }
      final targetJpg = File('assets/icons/app_icon.jpg');
      final targetPng = File('assets/icons/app_icon.png');
      if (!targetJpg.existsSync() || targetJpg.lengthSync() != sourceFile.lengthSync()) {
        sourceFile.copySync(targetJpg.path);
        sourceFile.copySync(targetPng.path);
      }
    }
  } catch (_) {}

  runApp(
    const ProviderScope(
      child: AniSpinApp(),
    ),
  );
}
