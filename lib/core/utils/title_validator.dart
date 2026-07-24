bool isTitleMatch(String? selected, {String? romaji, String? english, String? native}) {
  if (selected == null || selected.trim().isEmpty) return true; // Bypass validation if selected is not provided

  final cleanSelected = _normalize(selected);
  if (cleanSelected.isEmpty) return true;

  if (romaji != null && _isSemanticMatch(cleanSelected, _normalize(romaji))) return true;
  if (english != null && _isSemanticMatch(cleanSelected, _normalize(english))) return true;
  if (native != null && _isSemanticMatch(cleanSelected, _normalize(native))) return true;

  return false;
}

String _normalize(String s) {
  return s
      .toLowerCase()
      .replaceAll(RegExp(r'\([^)]*\)'), '')
      .replaceAll(RegExp(r'\[[^\]]*\]'), '')
      .replaceAll(RegExp(r'[:\-!~\?\.\s_+]+'), ' ')
      .trim();
}

bool _isSemanticMatch(String cleanSelected, String cleanFetched) {
  if (cleanSelected == cleanFetched) return true;
  if (cleanSelected.contains(cleanFetched) || cleanFetched.contains(cleanSelected)) return true;

  final selTokens = cleanSelected.split(' ').where((t) => t.length >= 3).toSet();
  final fetTokens = cleanFetched.split(' ').where((t) => t.length >= 3).toSet();

  if (selTokens.isNotEmpty && fetTokens.isNotEmpty) {
    final intersection = selTokens.intersection(fetTokens);
    final minLen = selTokens.length < fetTokens.length ? selTokens.length : fetTokens.length;
    if (intersection.length >= (minLen * 0.5).ceil()) {
      return true;
    }
  }
  return false;
}
