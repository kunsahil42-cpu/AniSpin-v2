# Tasks

- [x] Create `AnimeCache` class for local persistence of anime details.
- [x] Add serialization and cache constructors (`toJson`, `fromCacheJson`) to `AnimeDetailsModel` and its child models.
- [x] Add `forceRefresh` support to `AnimeDetailsRepository.getAnimeDetails`.
- [x] Refactor `animeDetailsProvider` to `AnimeDetailsNotifier` (FamilyAsyncNotifier) with background refresh and `newEpisodesProvider`.
- [x] Update `EpisodeList` widget to watch `newEpisodesProvider`, render the dismissible banner, and show "NEW" tags on new episodes.
- [x] Refactor `MangaChaptersNotifier` to check for updates, merge network and cache data, update `newChaptersProvider`, and refresh silently.
- [x] Update `ChapterList` widget to watch `newChaptersProvider`, render the dismissible banner, and display "NEW" tags on new chapters.
- [x] Write unit tests to verify caching, merging, and sync logic.
- [x] Run the tests and verify implementation.
