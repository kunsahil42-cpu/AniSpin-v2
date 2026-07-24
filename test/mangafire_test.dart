import 'package:flutter_test/flutter_test.dart';
import 'package:anispin/core/network/mangafire/mangafire_api.dart';

void main() {
  test('Test MangaFire search and getChapters', () async {
    final api = MangaFireApi();
    try {
      final results = await api.searchManga('One Piece');
      print('Search results count: ${results.length}');
      if (results.isNotEmpty) {
        print('First result: ${results.first}');
        final hid = results.first['hid']?.toString();
        if (hid != null) {
          final chapters = await api.getChapters(hid);
          print('Chapters count: ${chapters.length}');
          if (chapters.isNotEmpty) {
            print('First chapter: ${chapters.first}');
          }
        }
      }
    } catch (e) {
      print('Error during test: $e');
    }
  });
}
