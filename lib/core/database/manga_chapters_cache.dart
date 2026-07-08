import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/manga_details/models/chapter_model.dart';

class MangaChaptersCache {
  static final MangaChaptersCache _instance = MangaChaptersCache._internal();
  factory MangaChaptersCache() => _instance;
  MangaChaptersCache._internal();

  Map<String, List<ChapterModel>> _cache = {};
  bool _loaded = false;
  File? _cacheFile;

  Future<void> _init() async {
    if (_loaded) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      _cacheFile = File('${dir.path}/manga_chapters_cache.json');
      if (await _cacheFile!.exists()) {
        final content = await _cacheFile!.readAsString();
        final Map<String, dynamic> decoded = json.decode(content);
        _cache = decoded.map((key, value) {
          final list = (value as List)
              .map((item) => ChapterModel.fromJson(item as Map<String, dynamic>))
              .toList();
          return MapEntry(key, list);
        });
      }
    } catch (e) {
      debugPrint('Error loading manga chapters cache: $e');
    }
    _loaded = true;
  }

  Future<List<ChapterModel>?> get(int mangaId) async {
    await _init();
    return _cache[mangaId.toString()];
  }

  Future<void> put(int mangaId, List<ChapterModel> chapters) async {
    await _init();
    _cache[mangaId.toString()] = chapters;
    try {
      if (_cacheFile != null) {
        final Map<String, dynamic> encoded = _cache.map((key, value) =>
            MapEntry(key, value.map((c) => c.toJson()).toList()));
        await _cacheFile!.writeAsString(json.encode(encoded));
      }
    } catch (e) {
      debugPrint('Error saving manga chapters cache: $e');
    }
  }

  Future<void> clear() async {
    await _init();
    _cache.clear();
    try {
      if (_cacheFile != null && await _cacheFile!.exists()) {
        await _cacheFile!.delete();
      }
    } catch (_) {}
  }
}
