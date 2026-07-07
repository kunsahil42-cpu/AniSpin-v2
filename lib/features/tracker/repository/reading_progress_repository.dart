import 'package:isar/isar.dart';
import '../../../core/database/isar_service.dart';
import '../models/reading_progress.dart';

class ReadingProgressRepository {
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
