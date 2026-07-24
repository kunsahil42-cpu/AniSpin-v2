/// Shared helpers for reading raw Jikan v4 JSON fields and normalising them to
/// the shapes AniList-based models expect (0–100 score, uppercase enums, etc.).
///
/// Kept in one place so [AnimeMergeService] and [MangaMergeService] never
/// duplicate the parsing logic.
class JikanFieldUtils {
  const JikanFieldUtils._();

  static String string(Object? value) => value is String ? value : '';

  static bool isBlank(String? value) => value == null || value.isEmpty;

  /// Jikan `title_english` when present, otherwise the default `title`.
  static String preferredTitle(Map<String, dynamic> j) {
    final english = j['title_english'] as String?;
    if (english != null && english.isNotEmpty) return english;
    return string(j['title']);
  }

  static String cover(Map<String, dynamic> j) {
    final images = j['images'] as Map?;
    final jpg = images?['jpg'] as Map?;
    return string(jpg?['large_image_url'] ?? jpg?['image_url']);
  }

  /// Jikan has no banner field; the trailer's max thumbnail is the best proxy.
  static String banner(Map<String, dynamic> j) {
    final trailer = j['trailer'] as Map?;
    final images = trailer?['images'] as Map?;
    return string(images?['maximum_image_url']);
  }

  /// Jikan scores are 0–10; AniList averageScore is 0–100.
  static int? score100(Map<String, dynamic> j) {
    final score = j['score'];
    return score is num ? (score * 10).round() : null;
  }

  static int? intField(Map<String, dynamic> j, String key) {
    final value = j[key];
    return value is num ? value.toInt() : null;
  }

  static List<String> genres(Map<String, dynamic> j) {
    final list = j['genres'] as List?;
    if (list == null) return <String>[];
    return list
        .whereType<Map>()
        .map((g) => g['name']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static String firstStudio(Map<String, dynamic> j) {
    final studios = (j['studios'] as List?)?.whereType<Map>().toList();
    if (studios == null || studios.isEmpty) return '';
    return studios.first['name']?.toString() ?? '';
  }

  static String firstAuthor(Map<String, dynamic> j) {
    final authors = (j['authors'] as List?)?.whereType<Map>().toList();
    if (authors == null || authors.isEmpty) return '';
    return authors.first['name']?.toString() ?? '';
  }

  static String? upper(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return value.toUpperCase();
  }

  /// "24 min per ep" / "1 hr 30 min" → total minutes, best-effort.
  static int? durationMinutes(Map<String, dynamic> j) {
    final raw = j['duration'];
    if (raw is! String) return null;
    final hr = RegExp(r'(\d+)\s*hr').firstMatch(raw);
    final min = RegExp(r'(\d+)\s*min').firstMatch(raw);
    final hours = hr != null ? int.parse(hr.group(1)!) : 0;
    final minutes = min != null ? int.parse(min.group(1)!) : 0;
    final total = hours * 60 + minutes;
    return total > 0 ? total : null;
  }

  /// Maps a Jikan anime/manga `status` string to AniList's enum vocabulary.
  static String? mediaStatus(Object? value) {
    if (value is! String) return null;
    switch (value) {
      case 'Currently Airing':
      case 'Publishing':
        return 'RELEASING';
      case 'Finished Airing':
      case 'Finished':
        return 'FINISHED';
      case 'Not yet aired':
      case 'Upcoming':
        return 'NOT_YET_RELEASED';
      case 'On Hiatus':
        return 'HIATUS';
      case 'Discontinued':
        return 'CANCELLED';
      default:
        return value.toUpperCase();
    }
  }
}
