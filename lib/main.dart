import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/database/isar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 256 * 1024 * 1024; // 256MB

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

  runApp(
    const ProviderScope(
      child: AniSpinApp(),
    ),
  );
}
