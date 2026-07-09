import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/anime_details/models/anime_details_model.dart';

class AnimeCache {
  static Future<Directory> _getCacheDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${docsDir.path}/anime_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  static Future<File> _getCacheFile(int animeId) async {
    final dir = await _getCacheDirectory();
    return File('${dir.path}/anime_$animeId.json');
  }

  static Future<void> saveAnimeDetails(int animeId, AnimeDetailsModel details) async {
    try {
      final file = await _getCacheFile(animeId);
      final jsonString = jsonEncode(details.toJson());
      await file.writeAsString(jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('AnimeCache: Error saving cache for anime $animeId: $e');
      }
    }
  }

  static Future<AnimeDetailsModel?> getAnimeDetails(int animeId) async {
    try {
      final file = await _getCacheFile(animeId);
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return AnimeDetailsModel.fromCacheJson(jsonMap);
      }
    } catch (e) {
      if (kDebugMode) {
        print('AnimeCache: Error reading cache for anime $animeId: $e');
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
        print('AnimeCache: Error clearing cache: $e');
      }
    }
  }
}
