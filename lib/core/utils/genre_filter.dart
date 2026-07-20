bool isMediaBlocked({
  required List<String> genres,
  required bool isAdult,
  required List<String> blockedGenres,
}) {
  if (blockedGenres.isEmpty) return false;

  final normalizedBlocked = blockedGenres.map((g) => g.trim().toLowerCase()).toSet();

  // 1. Check if Adult is blocked AND the media is marked isAdult
  if (normalizedBlocked.contains('adult') && isAdult) {
    return true;
  }

  // 2. Check if any of the media's genres match a blocked genre
  for (final genre in genres) {
    final normalizedGenre = genre.trim().toLowerCase();
    if (normalizedBlocked.contains(normalizedGenre)) {
      return true;
    }
  }

  return false;
}
