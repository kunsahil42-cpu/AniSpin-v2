import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TranslationCache {
  static final TranslationCache _instance = TranslationCache._internal();
  factory TranslationCache() => _instance;
  TranslationCache._internal();

  Map<String, List<String>> _cache = {};
  bool _loaded = false;
  File? _cacheFile;

  Future<void> _init() async {
    if (_loaded) return;
    try {
      final dir = await getApplicationDocumentsDirectory();
      _cacheFile = File('${dir.path}/translation_cache.json');
      if (await _cacheFile!.exists()) {
        final content = await _cacheFile!.readAsString();
        final Map<String, dynamic> decoded = json.decode(content);
        _cache = decoded.map((key, value) => MapEntry(key, List<String>.from(value)));
      }
    } catch (_) {}
    _loaded = true;
  }

  Future<List<String>?> get(String chapterId) async {
    await _init();
    return _cache[chapterId];
  }

  Future<void> put(String chapterId, List<String> pages) async {
    await _init();
    _cache[chapterId] = pages;
    try {
      if (_cacheFile != null) {
        await _cacheFile!.writeAsString(json.encode(_cache));
      }
    } catch (_) {}
  }
}
