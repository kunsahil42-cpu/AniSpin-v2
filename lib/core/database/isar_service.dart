import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/favorites/models/favorite_anime.dart';
import '../../features/favorites/models/favorite_manga.dart';
import '../../features/tracker/models/watch_progress.dart';
import '../../features/tracker/models/reading_progress.dart';
import '../../features/manga_reader/models/chapter_reading_state.dart';

class IsarService {
  IsarService._();

  static Isar? _isar;

  static Future<Isar> open() async {
    if (_isar != null) {
      return _isar!;
    }

    final directory = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [
        FavoriteAnimeSchema,
        FavoriteMangaSchema,
        WatchProgressSchema,
        ReadingProgressSchema,
        ChapterReadingStateSchema,
      ],
      directory: directory.path,
      inspector: kDebugMode,
    );

    return _isar!;
  }

  static Isar get instance {
    if (_isar == null) {
      throw Exception(
        'Isar has not been initialized. Call IsarService.open() first.',
      );
    }

    return _isar!;
  }

  static Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}