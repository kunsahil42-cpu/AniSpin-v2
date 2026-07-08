import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/manga_details/models/chapter_model.dart';

class ChapterCache {
  static Future<Directory> _getCacheDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${docsDir.path}/chapter_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  static Future<File> _getCacheFile(int mangaId) async {
    final dir = await _getCacheDirectory();
    return File('${dir.path}/chapters_$mangaId.json');
  }

  static Future<void> saveChapters(int mangaId, List<ChapterModel> chapters) async {
    try {
      final file = await _getCacheFile(mangaId);
      final jsonList = chapters.map((c) => c.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('ChapterCache: Error saving cache for manga $mangaId: $e');
      }
    }
  }

  static Future<List<ChapterModel>?> getChapters(int mangaId) async {
    try {
      final file = await _getCacheFile(mangaId);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonList = jsonDecode(jsonString) as List;
        return jsonList
            .map((item) => ChapterModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) {
        print('ChapterCache: Error reading cache for manga $mangaId: $e');
      }
    }
    return null;
  }

  static Future<void> clearCache() async {
    try {
      final dir = await _getCacheDirectory();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (e) {
      if (kDebugMode) {
        print('ChapterCache: Error clearing cache: $e');
      }
    }
  }
}
