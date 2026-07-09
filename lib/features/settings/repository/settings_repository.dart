import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../../core/database/isar_service.dart';
import '../../tracker/models/watch_progress.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  Isar get _isar => IsarService.instance;

  static const int settingsReservedId = -999;

  Future<void> saveSettings(AppSettings settings) async {
    if (kDebugMode) {
      debugPrint('[Settings] ▶ saveSettings() called');
      debugPrint('[Settings]   blockedGenres BEFORE save: ${settings.blockedGenres}');
    }

    await _isar.writeTxn(() async {
      final existing = await _isar.collection<WatchProgress>()
          .filter()
          .animeIdEqualTo(settingsReservedId)
          .findFirst();

      final progress = existing ?? WatchProgress()
        ..animeId = settingsReservedId
        ..romajiTitle = "Settings"
        ..coverImage = ""
        ..lastWatchedEpisode = 0
        ..lastWatchedPosition = 0
        ..lastWatchedDuration = 0
        ..watchPercentage = 0.0
        ..lastWatchedSource = ""
        ..lastWatchedAudio = ""
        ..lastWatchedAt = DateTime.now();

      progress.notes = jsonEncode(settings.toJson());

      await _isar.collection<WatchProgress>().put(progress);
    });

    if (kDebugMode) {
      debugPrint('[Settings]   blockedGenres AFTER save: ${settings.blockedGenres}');
      debugPrint('[Settings] ✔ saveSettings() complete');
    }
  }

  AppSettings? getSettingsSync() {
    final record = _isar.collection<WatchProgress>()
        .filter()
        .animeIdEqualTo(settingsReservedId)
        .findFirstSync();

    if (record != null && record.notes != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(record.notes!);
        final settings = AppSettings.fromJson(json);
        if (kDebugMode) {
          debugPrint('[Settings] ▶ getSettingsSync() — record found');
          debugPrint('[Settings]   blockedGenres loaded from storage: ${settings.blockedGenres}');
        }
        return settings;
      } catch (e, st) {
        // Log so we can diagnose issues — don't crash, just fall back to defaults.
        if (kDebugMode) {
          debugPrint('[Settings] ✖ getSettingsSync() — failed to parse stored settings: $e');
          debugPrint('$st');
        }
        return null;
      }
    }

    if (kDebugMode) {
      debugPrint('[Settings] ▶ getSettingsSync() — no saved record found (first launch or DB cleared)');
    }
    return null;
  }

  Future<AppSettings?> getSettings() async {
    final record = await _isar.collection<WatchProgress>()
        .filter()
        .animeIdEqualTo(settingsReservedId)
        .findFirst();

    if (record != null && record.notes != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(record.notes!);
        final settings = AppSettings.fromJson(json);
        if (kDebugMode) {
          debugPrint('[Settings] ▶ getSettings() async — blockedGenres loaded: ${settings.blockedGenres}');
        }
        return settings;
      } catch (e, st) {
        if (kDebugMode) {
          debugPrint('[Settings] ✖ getSettings() — failed to parse stored settings: $e');
          debugPrint('$st');
        }
        return null;
      }
    }
    return null;
  }
}
