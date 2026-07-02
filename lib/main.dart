import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/database/isar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarService.open();

  runApp(
    const ProviderScope(
      child: AniSpinApp(),
    ),
  );
}