import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/isar_service.dart';
import '../../../core/sync/sync_service.dart';
import '../models/reading_progress.dart';

class ReadingProgressRepository {
  final Ref? _ref;
  ReadingProgressRepository([this._ref]);

  Isar get _isar => IsarService.instance;

  Future<void> saveProgress(ReadingProgress progress) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.collection<ReadingProgress>()
          .filter()
          .mangaIdEqualTo(progress.mangaId)
          .findFirst();

      if (existing != null) {
        progress.id = existing.id;
      }
      await _isar.collection<ReadingProgress>().put(progress);
    });

    if (_ref != null && progress.mangaId != -999) {
      try {
        _ref.read(syncServiceProvider).syncMangaProgress(progress);
      } catch (_) {}
    }
  }

  Future<void> deleteProgress(ReadingProgress progress) async {
    await _isar.writeTxn(() async {
      await _isar.readingProgress.delete(progress.id);
    });

    if (_ref != null && progress.mangaId != -999) {
      try {
        _ref.read(syncServiceProvider).syncDeleteProgress(progress.mangaId, null, true);
      } catch (_) {}
    }
  }

  Future<ReadingProgress?> getProgress(int mangaId) async {
    return await _isar.collection<ReadingProgress>()
        .filter()
        .mangaIdEqualTo(mangaId)
        .findFirst();
  }

  Future<List<ReadingProgress>> getContinueReading() async {
    return await _isar.collection<ReadingProgress>()
        .filter()
        .mangaIdGreaterThan(0)
        .sortByLastReadAtDesc()
        .findAll();
  }

  Stream<List<ReadingProgress>> watchContinueReading() {
    return _isar.collection<ReadingProgress>()
        .filter()
        .mangaIdGreaterThan(0)
        .sortByLastReadAtDesc()
        .watch(fireImmediately: true);
  }
}
