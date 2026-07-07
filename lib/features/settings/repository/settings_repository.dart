import 'dart:convert';
import 'package:isar/isar.dart';
import '../../../core/database/isar_service.dart';
import '../../tracker/models/watch_progress.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  Isar get _isar => IsarService.instance;

  static const int settingsReservedId = -999;

  Future<void> saveSettings(AppSettings settings) async {
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
  }

  AppSettings? getSettingsSync() {
    final record = _isar.collection<WatchProgress>()
        .filter()
        .animeIdEqualTo(settingsReservedId)
        .findFirstSync();

    if (record != null && record.notes != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(record.notes!);
        return AppSettings.fromJson(json);
      } catch (_) {
        return null;
      }
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
        return AppSettings.fromJson(json);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
