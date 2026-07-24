import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/sync/sync_service.dart';
import '../models/watch_progress.dart';

class WatchProgressRepository {
  final Ref? _ref;
  WatchProgressRepository([this._ref]);

  Isar get _isar => IsarService.instance;

  Future<void> saveProgress(WatchProgress progress) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.collection<WatchProgress>()
          .filter()
          .animeIdEqualTo(progress.animeId)
          .findFirst();

      if (existing != null) {
        progress.id = existing.id;
      }
      await _isar.collection<WatchProgress>().put(progress);
    });

    if (_ref != null && progress.animeId != -999) {
      try {
        _ref.read(syncServiceProvider).syncAnimeProgress(progress);
      } catch (_) {}
    }
  }

  Future<void> deleteProgress(WatchProgress progress) async {
    await _isar.writeTxn(() async {
      await _isar.watchProgress.delete(progress.id);
    });

    if (_ref != null && progress.animeId != -999) {
      try {
        _ref.read(syncServiceProvider).syncDeleteProgress(progress.animeId, progress.malId, false);
      } catch (_) {}
    }
  }

  Future<WatchProgress?> getProgress(int animeId) async {
    return await _isar.collection<WatchProgress>()
        .filter()
        .animeIdEqualTo(animeId)
        .findFirst();
  }

  Future<List<WatchProgress>> getContinueWatching() async {
    final list = await _isar.collection<WatchProgress>()
        .filter()
        .animeIdGreaterThan(0)
        .sortByLastWatchedAtDesc()
        .findAll();
    return list.where((x) => x.romajiTitle.toLowerCase() != 'settings').toList();
  }

  Stream<List<WatchProgress>> watchContinueWatching() {
    return _isar.collection<WatchProgress>()
        .filter()
        .animeIdGreaterThan(0)
        .sortByLastWatchedAtDesc()
        .watch(fireImmediately: true)
        .map((list) => list.where((x) => x.romajiTitle.toLowerCase() != 'settings').toList());
  }
}
