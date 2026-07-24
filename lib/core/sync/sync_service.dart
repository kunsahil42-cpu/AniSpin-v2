import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../database/isar_service.dart';
import '../utils/encryption_utils.dart';
import '../../features/settings/providers/settings_provider.dart';
import '../../features/tracker/models/watch_progress.dart';
import '../../features/tracker/models/reading_progress.dart';
import '../../features/tracker/repository/watch_progress_repository.dart';
import '../../features/favorites/models/favorite_anime.dart';
import '../../features/favorites/models/favorite_manga.dart';
import '../../features/favorites/providers/favorites_provider.dart';
import '../../features/tracker/providers/tracker_providers.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(ref);
});

class SyncService {
  final Ref _ref;
  SyncService(this._ref);

  // ==========================================
  // HELPER METHODS FOR ACCESSING TOKENS
  // ==========================================

  String? _getAniListToken() {
    final token = _ref.read(settingsNotifierProvider).aniListToken;
    if (token == null || token.isEmpty) return null;
    return EncryptionUtils.decrypt(token);
  }

  String? _getMalToken() {
    final token = _ref.read(settingsNotifierProvider).malToken;
    if (token == null || token.isEmpty) return null;
    return EncryptionUtils.decrypt(token);
  }

  // ==========================================
  // SYNC PROGRESS (ANIME)
  // ==========================================

  Future<void> syncAnimeProgress(WatchProgress progress) async {
    // 1. Sync AniList
    final aniListToken = _getAniListToken();
    if (aniListToken != null) {
      await _syncAnimeToAniList(aniListToken, progress);
    }

    // 2. Sync MyAnimeList
    final malToken = _getMalToken();
    if (malToken != null && progress.malId != null && progress.malId! > 0) {
      await _syncAnimeToMal(malToken, progress.malId!, progress);
    }
  }

  Future<void> _syncAnimeToAniList(String token, WatchProgress progress) async {
    const query = r'''
      mutation ($mediaId: Int, $status: MediaListStatus, $score: Float, $progress: Int, $notes: String) {
        SaveMediaListEntry (mediaId: $mediaId, status: $status, score: $score, progress: $progress, notes: $notes) {
          id
        }
      }
    ''';

    final mediaId = progress.animeId;
    if (mediaId <= 0) return; // Mapped temporary offline ID

    final aniStatus = _mapStatusToAniList(progress.status);
    final variables = {
      'mediaId': mediaId,
      'status': aniStatus,
      'score': progress.score?.toDouble() ?? 0.0,
      'progress': progress.lastWatchedEpisode,
      'notes': progress.notes ?? '',
    };

    try {
      await http.post(
        Uri.parse('https://graphql.anilist.co'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'query': query,
          'variables': variables,
        }),
      );
    } catch (_) {}
  }

  Future<void> _syncAnimeToMal(String token, int malId, WatchProgress progress) async {
    final url = Uri.parse('https://api.myanimelist.net/v2/anime/$malId/my_list_status');
    final malStatus = _mapStatusToMal(progress.status, isManga: false);

    try {
      await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'status': malStatus,
          'num_watched_episodes': progress.lastWatchedEpisode.toString(),
          'score': (progress.score ?? 0).toString(),
          'comments': progress.notes ?? '',
        },
      );
    } catch (_) {}
  }

  // ==========================================
  // SYNC PROGRESS (MANGA)
  // ==========================================

  Future<void> syncMangaProgress(ReadingProgress progress) async {
    // 1. Sync AniList
    final aniListToken = _getAniListToken();
    if (aniListToken != null) {
      await _syncMangaToAniList(aniListToken, progress);
    }

    // 2. Sync MyAnimeList (MAL manga ID is same as local mangaId in our imports)
    final malToken = _getMalToken();
    if (malToken != null && progress.mangaId > 0) {
      await _syncMangaToMal(malToken, progress.mangaId, progress);
    }
  }

  Future<void> _syncMangaToAniList(String token, ReadingProgress progress) async {
    const query = r'''
      mutation ($mediaId: Int, $status: MediaListStatus, $score: Float, $progress: Int, $notes: String) {
        SaveMediaListEntry (mediaId: $mediaId, status: $status, score: $score, progress: $progress, notes: $notes) {
          id
        }
      }
    ''';

    final mediaId = progress.mangaId;
    if (mediaId <= 0) return;

    final aniStatus = _mapStatusToAniList(progress.status);
    final variables = {
      'mediaId': mediaId,
      'status': aniStatus,
      'score': progress.score?.toDouble() ?? 0.0,
      'progress': progress.lastReadChapter,
      'notes': progress.notes ?? '',
    };

    try {
      await http.post(
        Uri.parse('https://graphql.anilist.co'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'query': query,
          'variables': variables,
        }),
      );
    } catch (_) {}
  }

  Future<void> _syncMangaToMal(String token, int malId, ReadingProgress progress) async {
    final url = Uri.parse('https://api.myanimelist.net/v2/manga/$malId/my_list_status');
    final malStatus = _mapStatusToMal(progress.status, isManga: true);

    try {
      await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'status': malStatus,
          'num_chapters_read': progress.lastReadChapter.toString(),
          'num_volumes_read': progress.lastReadVolume.toString(),
          'score': (progress.score ?? 0).toString(),
          'comments': progress.notes ?? '',
        },
      );
    } catch (_) {}
  }

  // ==========================================
  // SYNC FAVORITES
  // ==========================================

  Future<void> syncFavorite(int mediaId, bool isManga) async {
    final token = _getAniListToken();
    if (token == null || mediaId <= 0) return;

    const query = r'''
      mutation ($animeId: Int, $mangaId: Int) {
        ToggleFavorite (animeId: $animeId, mangaId: $mangaId) {
          id
        }
      }
    ''';

    final variables = isManga ? {'mangaId': mediaId} : {'animeId': mediaId};

    try {
      await http.post(
        Uri.parse('https://graphql.anilist.co'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'query': query,
          'variables': variables,
        }),
      );
    } catch (_) {}
  }

  // ==========================================
  // SILENT DELETION SYNC
  // ==========================================

  Future<void> syncDeleteProgress(int mediaId, int? malId, bool isManga) async {
    final aniListToken = _getAniListToken();
    if (aniListToken != null && mediaId > 0) {
      await _deleteFromAniList(aniListToken, mediaId);
    }

    final malToken = _getMalToken();
    final targetMalId = isManga ? mediaId : malId;
    if (malToken != null && targetMalId != null && targetMalId > 0) {
      await _deleteFromMal(malToken, targetMalId, isManga: isManga);
    }
  }

  Future<void> _deleteFromAniList(String token, int mediaId) async {
    const findQuery = r'''
      query ($mediaId: Int) {
        MediaList (mediaId: $mediaId) {
          id
        }
      }
    ''';

    const deleteMutation = r'''
      mutation ($id: Int) {
        DeleteMediaListEntry (id: $id) {
          deleted
        }
      }
    ''';

    try {
      final findRes = await http.post(
        Uri.parse('https://graphql.anilist.co'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'query': findQuery,
          'variables': {'mediaId': mediaId},
        }),
      );

      if (findRes.statusCode == 200) {
        final data = jsonDecode(findRes.body);
        final entryId = data['data']?['MediaList']?['id'] as int?;
        if (entryId != null) {
          await http.post(
            Uri.parse('https://graphql.anilist.co'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'query': deleteMutation,
              'variables': {'id': entryId},
            }),
          );
        }
      }
    } catch (_) {}
  }

  Future<void> _deleteFromMal(String token, int malId, {required bool isManga}) async {
    final type = isManga ? 'manga' : 'anime';
    final url = Uri.parse('https://api.myanimelist.net/v2/$type/$malId/my_list_status');

    try {
      await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
    } catch (_) {}
  }

  // ==========================================
  // POST-LOGIN FULL IMPORT & MERGE
  // ==========================================

  Future<void> importLibraryAfterLogin(BuildContext context) async {
    final settings = _ref.read(settingsNotifierProvider);
    final aniListConnected = settings.aniListToken != null && settings.aniListToken!.isNotEmpty;
    final malConnected = settings.malToken != null && settings.malToken!.isNotEmpty;

    if (!aniListConnected && !malConnected) return;

    String? choice = settings.libraryMergePreference;

    if (aniListConnected && malConnected) {
      if (choice == null || choice.isEmpty) {
        if (context.mounted) {
          choice = await showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              final theme = Theme.of(context);
              return AlertDialog(
                backgroundColor: Colors.grey[950],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                title: Row(
                  children: [
                    const Icon(Icons.merge_type_rounded, color: Colors.purpleAccent, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      "Merge Tracking Libraries",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Both AniList and MyAnimeList accounts are connected. Select which data AniSpin should use to initialize your library:",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    _buildOptionButton(context, "AniList Only", "Use AniList progress and favorites.", "anilist"),
                    const SizedBox(height: 10),
                    _buildOptionButton(context, "MyAnimeList Only", "Use MyAnimeList progress.", "myanimelist"),
                    const SizedBox(height: 10),
                    _buildOptionButton(context, "Merge Both Libraries (Recommended)", "Combine both lists seamlessly with no duplicates, keeping the highest progress/scores.", "merge"),
                  ],
                ),
              );
            },
          );
          
          if (choice == null) return;

          await _ref.read(settingsNotifierProvider.notifier).updateSettings(
            settings.copyWith(libraryMergePreference: choice),
          );
        }
      }
    } else if (aniListConnected) {
      choice = "anilist";
    } else {
      choice = "myanimelist";
    }

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Card(
            color: Colors.grey[950],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: Colors.purpleAccent),
                  const SizedBox(height: 20),
                  const Text(
                    "Syncing library updates...",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    choice == "merge" ? "Merging AniList & MyAnimeList" : "Importing from ${choice == 'anilist' ? 'AniList' : 'MyAnimeList'}",
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    try {
      if (choice == "anilist") {
        await _importFromAniListOnly();
      } else if (choice == "myanimelist") {
        await _importFromMalOnly();
      } else if (choice == "merge") {
        await _importAndMergeBoth();
      }

      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Library sync completed successfully!")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sync library: $e")),
        );
      }
    }
  }

  Widget _buildOptionButton(BuildContext context, String title, String subtitle, String value) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(value),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.purpleAccent, size: 16),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // GRAPHQL & REST API FETCHERS
  // ==========================================

  void _handleAniListResponseError(http.Response response) {
    String? apiMsg;
    try {
      final data = jsonDecode(response.body);
      final errors = data['errors'] as List?;
      if (errors != null && errors.isNotEmpty) {
        apiMsg = errors[0]['message'] as String?;
      }
    } catch (_) {}

    if (apiMsg != null && apiMsg.isNotEmpty) {
      throw Exception(apiMsg);
    }

    if (response.statusCode == 400) {
      throw Exception('AniList API returned an invalid response.');
    } else {
      throw Exception('Unable to fetch your AniList library. Please try again later.');
    }
  }

  Future<int> _fetchAniListUserId(String token) async {
    const query = r'''
      query {
        Viewer {
          id
        }
      }
    ''';
    final response = await http.post(
      Uri.parse('https://graphql.anilist.co'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'query': query}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final id = data['data']?['Viewer']?['id'] as int?;
      if (id != null) {
        return id;
      }
      throw Exception('Viewer ID not found in response');
    }
    _handleAniListResponseError(response);
    throw Exception('Failed to fetch AniList User ID');
  }

  Future<List<dynamic>> _fetchAniListAnimeList(String token, int userId) async {
    final query = '''
      query {
        MediaListCollection (userId: $userId, type: ANIME) {
          lists {
            status
            entries {
              progress
              score (format: POINT_10)
              notes
              updatedAt
              media {
                id
                idMal
                title { romaji english native }
                coverImage { large }
                bannerImage
                episodes
                genres
                averageScore
                season
                seasonYear
                studios(isMain: true) { nodes { name } }
              }
            }
          }
        }
      }
    ''';
    final response = await http.post(
      Uri.parse('https://graphql.anilist.co'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'query': query}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final lists = data['data']?['MediaListCollection']?['lists'] as List?;
      final allEntries = [];
      if (lists != null) {
        for (final list in lists) {
          final status = list['status'] as String?;
          final entries = list['entries'] as List?;
          if (entries != null) {
            for (final entry in entries) {
              allEntries.add({
                'status': status,
                'progress': entry['progress'] as int? ?? 0,
                'score': (entry['score'] as num?)?.toInt() ?? 0,
                'notes': entry['notes'] as String?,
                'updatedAt': entry['updatedAt'] as int?,
                'media': entry['media'],
              });
            }
          }
        }
      }
      return allEntries;
    }
    _handleAniListResponseError(response);
    throw Exception('Failed to fetch AniList Anime list');
  }

  Future<List<dynamic>> _fetchAniListMangaList(String token, int userId) async {
    final query = '''
      query {
        MediaListCollection (userId: $userId, type: MANGA) {
          lists {
            status
            entries {
              progress
              progressVolumes
              score (format: POINT_10)
              notes
              updatedAt
              media {
                id
                idMal
                title { romaji english native }
                coverImage { large }
                bannerImage
                chapters
                volumes
                genres
                averageScore
                staff(perPage: 5) { nodes { name { full } } }
              }
            }
          }
        }
      }
    ''';
    final response = await http.post(
      Uri.parse('https://graphql.anilist.co'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'query': query}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final lists = data['data']?['MediaListCollection']?['lists'] as List?;
      final allEntries = [];
      if (lists != null) {
        for (final list in lists) {
          final status = list['status'] as String?;
          final entries = list['entries'] as List?;
          if (entries != null) {
            for (final entry in entries) {
              allEntries.add({
                'status': status,
                'progress': entry['progress'] as int? ?? 0,
                'progressVolumes': entry['progressVolumes'] as int? ?? 0,
                'score': (entry['score'] as num?)?.toInt() ?? 0,
                'notes': entry['notes'] as String?,
                'updatedAt': entry['updatedAt'] as int?,
                'media': entry['media'],
              });
            }
          }
        }
      }
      return allEntries;
    }
    _handleAniListResponseError(response);
    throw Exception('Failed to fetch AniList Manga list');
  }

  Future<Map<String, List<dynamic>>> _fetchAniListFavorites(String token) async {
    const query = r'''
      query {
        Viewer {
          favourites {
            anime {
              nodes {
                id
                idMal
                title { romaji english native }
                coverImage { large }
                bannerImage
                episodes
                genres
                averageScore
                season
                seasonYear
                studios(isMain: true) { nodes { name } }
              }
            }
            manga {
              nodes {
                id
                idMal
                title { romaji english native }
                coverImage { large }
                bannerImage
                chapters
                volumes
                genres
                averageScore
                staff(perPage: 5) { nodes { name { full } } }
              }
            }
          }
        }
      }
    ''';
    final response = await http.post(
      Uri.parse('https://graphql.anilist.co'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'query': query}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final favs = data['data']?['Viewer']?['favourites'];
      final animeList = favs?['anime']?['nodes'] as List? ?? [];
      final mangaList = favs?['manga']?['nodes'] as List? ?? [];
      return {'anime': animeList, 'manga': mangaList};
    }
    _handleAniListResponseError(response);
    throw Exception('Failed to fetch AniList favorites');
  }

  Future<List<dynamic>> _fetchMalAnimeList(String token) async {
    final url = Uri.parse('https://api.myanimelist.net/v2/users/@me/animelist?fields=list_status{num_episodes_watched,score,status,comments,updated_at},num_episodes,alternative_titles,genres,studios,mean,start_season&limit=1000');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] as List? ?? [];
    }
    throw Exception('Failed to fetch MyAnimeList Anime list: ${response.statusCode}');
  }

  Future<List<dynamic>> _fetchMalMangaList(String token) async {
    final url = Uri.parse('https://api.myanimelist.net/v2/users/@me/mangalist?fields=list_status{num_chapters_read,num_volumes_read,score,status,comments,updated_at},num_chapters,num_volumes,alternative_titles,genres,authors{node{name}},mean&limit=1000');
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] as List? ?? [];
    }
    throw Exception('Failed to fetch MyAnimeList Manga list: ${response.statusCode}');
  }

  // ==========================================
  // IMPORT IMPLEMENTATIONS
  // ==========================================

  Future<void> _importFromAniListOnly() async {
    final token = _getAniListToken();
    if (token == null) return;

    final userId = await _fetchAniListUserId(token);
    final animeEntries = await _fetchAniListAnimeList(token, userId);
    final mangaEntries = await _fetchAniListMangaList(token, userId);
    final favorites = await _fetchAniListFavorites(token);

    final isar = IsarService.instance;
    await isar.writeTxn(() async {
      await isar.watchProgress.clear();
      for (final entry in animeEntries) {
        if (entry == null) continue;
        final media = entry['media'];
        if (media == null) continue;
        final animeId = media['id'] as int? ?? 0;
        if (animeId == 0) continue;
        final progressVal = entry['progress'] as int? ?? 0;
        final totalEps = media['episodes'] as int? ?? 0;
        
        final watch = WatchProgress()
          ..animeId = animeId
          ..malId = media['idMal'] as int?
          ..romajiTitle = media['title']?['romaji'] ?? media['title']?['english'] ?? media['title']?['native'] ?? 'Unknown'
          ..englishTitle = media['title']?['english']
          ..coverImage = media['coverImage']?['large'] ?? ''
          ..bannerImage = media['bannerImage'] as String?
          ..totalEpisodes = totalEps > 0 ? totalEps : null
          ..lastWatchedEpisode = progressVal
          ..lastWatchedPosition = 0
          ..lastWatchedDuration = 0
          ..watchPercentage = (totalEps > 0) ? (progressVal / totalEps) : 0.0
          ..lastWatchedSource = "AniList Import"
          ..lastWatchedAudio = "sub"
          ..lastWatchedAt = entry['updatedAt'] != null 
              ? DateTime.fromMillisecondsSinceEpoch((entry['updatedAt'] as int) * 1000)
              : DateTime.now()
          ..status = _mapStatusFromAniList(entry['status'] as String?)
          ..score = entry['score'] as int?
          ..notes = entry['notes'] as String?
          ..genres = (media['genres'] as List?)?.map((e) => e.toString()).toList() ?? []
          ..studio = _getStudio(media);
        watch.completedEpisodes = List<int>.generate(progressVal, (i) => i + 1);
        await isar.watchProgress.put(watch);
      }

      await isar.readingProgress.clear();
      for (final entry in mangaEntries) {
        if (entry == null) continue;
        final media = entry['media'];
        if (media == null) continue;
        final mangaId = media['id'] as int? ?? 0;
        if (mangaId == 0) continue;
        final progressVal = entry['progress'] as int? ?? 0;
        final totalChs = media['chapters'] as int? ?? 0;
        final totalVols = media['volumes'] as int? ?? 0;

        final read = ReadingProgress()
          ..mangaId = mangaId
          ..romajiTitle = media['title']?['romaji'] ?? media['title']?['english'] ?? media['title']?['native'] ?? 'Unknown'
          ..englishTitle = media['title']?['english']
          ..coverImage = media['coverImage']?['large'] ?? ''
          ..bannerImage = media['bannerImage'] as String?
          ..totalChapters = totalChs > 0 ? totalChs : null
          ..lastReadChapter = progressVal
          ..lastReadPage = 1
          ..readingPercentage = (totalChs > 0) ? (progressVal / totalChs) : 0.0
          ..lastReadAt = entry['updatedAt'] != null 
              ? DateTime.fromMillisecondsSinceEpoch((entry['updatedAt'] as int) * 1000)
              : DateTime.now()
          ..completedChapters = List<int>.generate(progressVal, (i) => i + 1)
          ..status = _mapStatusFromAniList(entry['status'] as String?)
          ..score = entry['score'] as int?
          ..notes = entry['notes'] as String?
          ..lastReadVolume = entry['progressVolumes'] as int? ?? 0
          ..totalVolumes = totalVols > 0 ? totalVols : null
          ..genres = (media['genres'] as List?)?.map((e) => e.toString()).toList() ?? []
          ..author = _getAuthor(media);
        await isar.readingProgress.put(read);
      }

      await isar.favoriteAnimes.clear();
      for (final media in favorites['anime']!) {
        if (media == null) continue;
        final animeId = media['id'] as int? ?? 0;
        if (animeId == 0) continue;
        final fav = FavoriteAnime()
          ..animeId = animeId
          ..romajiTitle = media['title']?['romaji'] ?? media['title']?['english'] ?? media['title']?['native'] ?? 'Unknown'
          ..englishTitle = media['title']?['english']
          ..coverImage = media['coverImage']?['large'] ?? ''
          ..bannerImage = media['bannerImage'] as String?
          ..averageScore = media['averageScore'] as int?
          ..episodes = media['episodes'] as int?
          ..status = media['status'] as String?
          ..studio = _getStudio(media)
          ..season = media['season'] as String?
          ..seasonYear = media['seasonYear'] as int?
          ..addedAt = DateTime.now();
        await isar.favoriteAnimes.put(fav);
      }

      await isar.favoriteMangas.clear();
      for (final media in favorites['manga']!) {
        if (media == null) continue;
        final mangaId = media['id'] as int? ?? 0;
        if (mangaId == 0) continue;
        final fav = FavoriteManga()
          ..mangaId = mangaId
          ..romajiTitle = media['title']?['romaji'] ?? media['title']?['english'] ?? media['title']?['native'] ?? 'Unknown'
          ..englishTitle = media['title']?['english']
          ..coverImage = media['coverImage']?['large'] ?? ''
          ..bannerImage = media['bannerImage'] as String?
          ..chapters = media['chapters'] as int?
          ..volumes = media['volumes'] as int?
          ..status = media['status'] as String?
          ..author = _getAuthor(media)
          ..addedAt = DateTime.now();
        await isar.favoriteMangas.put(fav);
      }
    });

    _invalidateProgressProviders();
  }

  Future<void> _importFromMalOnly() async {
    final token = _getMalToken();
    if (token == null) return;

    final animeEntries = await _fetchMalAnimeList(token);
    final mangaEntries = await _fetchMalMangaList(token);

    final isar = IsarService.instance;
    await isar.writeTxn(() async {
      await isar.watchProgress.clear();
      for (final entry in animeEntries) {
        if (entry == null) continue;
        final node = entry['node'];
        final listStatus = entry['list_status'];
        if (node == null || listStatus == null) continue;
        final malId = node['id'] as int? ?? 0;
        if (malId == 0) continue;
        final progressVal = listStatus['num_episodes_watched'] as int? ?? 0;
        final totalEps = node['num_episodes'] as int? ?? 0;

        final watch = WatchProgress()
          ..animeId = malId
          ..malId = malId
          ..romajiTitle = node['title'] ?? node['alternative_titles']?['en'] ?? 'Unknown'
          ..englishTitle = node['alternative_titles']?['en']
          ..coverImage = node['main_picture']?['large'] ?? node['main_picture']?['medium'] ?? ''
          ..bannerImage = null
          ..totalEpisodes = totalEps > 0 ? totalEps : null
          ..lastWatchedEpisode = progressVal
          ..lastWatchedPosition = 0
          ..lastWatchedDuration = 0
          ..watchPercentage = (totalEps > 0) ? (progressVal / totalEps) : 0.0
          ..lastWatchedSource = "MyAnimeList Import"
          ..lastWatchedAudio = "sub"
          ..lastWatchedAt = listStatus['updated_at'] != null 
              ? DateTime.tryParse(listStatus['updated_at'] as String)?.toLocal() ?? DateTime.now()
              : DateTime.now()
          ..status = _mapStatusFromMal(listStatus['status'] as String?, isManga: false)
          ..score = listStatus['score'] as int?
          ..notes = listStatus['comments'] as String?
          ..genres = (node['genres'] as List?)?.map((g) => g['name'].toString()).toList() ?? []
          ..studio = (node['studios'] as List?) != null && (node['studios'] as List).isNotEmpty 
              ? node['studios'][0]['name'].toString() 
              : null;
        watch.completedEpisodes = List<int>.generate(progressVal, (i) => i + 1);
        await isar.watchProgress.put(watch);
      }

      await isar.readingProgress.clear();
      for (final entry in mangaEntries) {
        if (entry == null) continue;
        final node = entry['node'];
        final listStatus = entry['list_status'];
        if (node == null || listStatus == null) continue;
        final malId = node['id'] as int? ?? 0;
        if (malId == 0) continue;
        final progressVal = listStatus['num_chapters_read'] as int? ?? 0;
        final totalChs = node['num_chapters'] as int? ?? 0;
        final totalVols = node['num_volumes'] as int? ?? 0;

        final read = ReadingProgress()
          ..mangaId = malId
          ..romajiTitle = node['title'] ?? node['alternative_titles']?['en'] ?? 'Unknown'
          ..englishTitle = node['alternative_titles']?['en']
          ..coverImage = node['main_picture']?['large'] ?? node['main_picture']?['medium'] ?? ''
          ..bannerImage = null
          ..totalChapters = totalChs > 0 ? totalChs : null
          ..lastReadChapter = progressVal
          ..lastReadPage = 1
          ..readingPercentage = (totalChs > 0) ? (progressVal / totalChs) : 0.0
          ..lastReadAt = listStatus['updated_at'] != null 
              ? DateTime.tryParse(listStatus['updated_at'] as String)?.toLocal() ?? DateTime.now()
              : DateTime.now()
          ..completedChapters = List<int>.generate(progressVal, (i) => i + 1)
          ..status = _mapStatusFromMal(listStatus['status'] as String?, isManga: true)
          ..score = listStatus['score'] as int?
          ..notes = listStatus['comments'] as String?
          ..lastReadVolume = listStatus['num_volumes_read'] as int? ?? 0
          ..totalVolumes = totalVols > 0 ? totalVols : null
          ..genres = (node['genres'] as List?)?.map((g) => g['name'].toString()).toList() ?? []
          ..author = (node['authors'] as List?) != null && (node['authors'] as List).isNotEmpty 
              ? node['authors'][0]['node']['name'].toString() 
              : null;
        await isar.readingProgress.put(read);
      }

      await isar.favoriteAnimes.clear();
      await isar.favoriteMangas.clear();
    });

    _invalidateProgressProviders();
  }

  Future<void> _importAndMergeBoth() async {
    final aniListToken = _getAniListToken();
    final malToken = _getMalToken();
    if (aniListToken == null || malToken == null) return;

    final userId = await _fetchAniListUserId(aniListToken);
    final alAnime = await _fetchAniListAnimeList(aniListToken, userId);
    final alManga = await _fetchAniListMangaList(aniListToken, userId);
    final alFavs = await _fetchAniListFavorites(aniListToken);

    final malAnime = await _fetchMalAnimeList(malToken);
    final malManga = await _fetchMalMangaList(malToken);

    final isar = IsarService.instance;
    await isar.writeTxn(() async {
      // 1. Merge Anime
      await isar.watchProgress.clear();
      final Map<String, WatchProgress> mergedAnime = {};

      for (final entry in alAnime) {
        if (entry == null) continue;
        final media = entry['media'];
        if (media == null) continue;
        final alId = media['id'] as int? ?? 0;
        if (alId == 0) continue;
        final malId = media['idMal'] as int?;
        final progressVal = entry['progress'] as int? ?? 0;
        final totalEps = media['episodes'] as int? ?? 0;
        
        final watch = WatchProgress()
          ..animeId = alId
          ..malId = malId
          ..romajiTitle = media['title']?['romaji'] ?? media['title']?['english'] ?? media['title']?['native'] ?? 'Unknown'
          ..englishTitle = media['title']?['english']
          ..coverImage = media['coverImage']?['large'] ?? ''
          ..bannerImage = media['bannerImage'] as String?
          ..totalEpisodes = totalEps > 0 ? totalEps : null
          ..lastWatchedEpisode = progressVal
          ..lastWatchedPosition = 0
          ..lastWatchedDuration = 0
          ..watchPercentage = (totalEps > 0) ? (progressVal / totalEps) : 0.0
          ..lastWatchedSource = "AniList + MAL Merge"
          ..lastWatchedAudio = "sub"
          ..lastWatchedAt = entry['updatedAt'] != null 
              ? DateTime.fromMillisecondsSinceEpoch((entry['updatedAt'] as int) * 1000)
              : DateTime.now()
          ..status = _mapStatusFromAniList(entry['status'] as String?)
          ..score = entry['score'] as int?
          ..notes = entry['notes'] as String?
          ..genres = (media['genres'] as List?)?.map((e) => e.toString()).toList() ?? []
          ..studio = _getStudio(media);
        watch.completedEpisodes = List<int>.generate(progressVal, (i) => i + 1);

        final key = malId != null ? 'mal_$malId' : 'title_${watch.romajiTitle.toLowerCase().trim()}';
        mergedAnime[key] = watch;
      }

      for (final entry in malAnime) {
        if (entry == null) continue;
        final node = entry['node'];
        final listStatus = entry['list_status'];
        if (node == null || listStatus == null) continue;
        final malId = node['id'] as int? ?? 0;
        if (malId == 0) continue;
        final progressVal = listStatus['num_episodes_watched'] as int? ?? 0;
        final totalEps = node['num_episodes'] as int? ?? 0;
        final key = 'mal_$malId';

        final malWatchAt = listStatus['updated_at'] != null 
            ? DateTime.tryParse(listStatus['updated_at'] as String)?.toLocal() ?? DateTime.now()
            : DateTime.now();

        if (mergedAnime.containsKey(key)) {
          final existing = mergedAnime[key]!;
          existing.lastWatchedEpisode = max(existing.lastWatchedEpisode, progressVal);
          existing.completedEpisodes = List<int>.generate(existing.lastWatchedEpisode, (i) => i + 1);
          final finalTotal = existing.totalEpisodes ?? totalEps;
          existing.watchPercentage = (finalTotal > 0) ? (existing.lastWatchedEpisode / finalTotal) : 0.0;
          existing.score = max(existing.score ?? 0, listStatus['score'] as int? ?? 0);
          
          final malStatus = _mapStatusFromMal(listStatus['status'] as String?, isManga: false);
          if (existing.status != 'Completed' && malStatus == 'Completed') {
            existing.status = 'Completed';
          }

          if (malWatchAt.isAfter(existing.lastWatchedAt)) {
            existing.lastWatchedAt = malWatchAt;
            if (listStatus['comments'] != null) {
              existing.notes = listStatus['comments'] as String;
            }
          }
        } else {
          final titleKey = 'title_${node['title'].toString().toLowerCase().trim()}';
          if (mergedAnime.containsKey(titleKey)) {
            final existing = mergedAnime[titleKey]!;
            existing.malId = malId;
            existing.lastWatchedEpisode = max(existing.lastWatchedEpisode, progressVal);
            existing.completedEpisodes = List<int>.generate(existing.lastWatchedEpisode, (i) => i + 1);
            final finalTotal = existing.totalEpisodes ?? totalEps;
            existing.watchPercentage = (finalTotal > 0) ? (existing.lastWatchedEpisode / finalTotal) : 0.0;
            existing.score = max(existing.score ?? 0, listStatus['score'] as int? ?? 0);
            final malStatus = _mapStatusFromMal(listStatus['status'] as String?, isManga: false);
            if (existing.status != 'Completed' && malStatus == 'Completed') {
              existing.status = 'Completed';
            }
            if (malWatchAt.isAfter(existing.lastWatchedAt)) {
              existing.lastWatchedAt = malWatchAt;
            }
          } else {
            final watch = WatchProgress()
              ..animeId = malId
              ..malId = malId
              ..romajiTitle = node['title'] ?? node['alternative_titles']?['en'] ?? 'Unknown'
              ..englishTitle = node['alternative_titles']?['en']
              ..coverImage = node['main_picture']?['large'] ?? node['main_picture']?['medium'] ?? ''
              ..bannerImage = null
              ..totalEpisodes = totalEps > 0 ? totalEps : null
              ..lastWatchedEpisode = progressVal
              ..lastWatchedPosition = 0
              ..lastWatchedDuration = 0
              ..watchPercentage = (totalEps > 0) ? (progressVal / totalEps) : 0.0
              ..lastWatchedSource = "MAL Import"
              ..lastWatchedAudio = "sub"
              ..lastWatchedAt = malWatchAt
              ..status = _mapStatusFromMal(listStatus['status'] as String?, isManga: false)
              ..score = listStatus['score'] as int?
              ..notes = listStatus['comments'] as String?
              ..genres = (node['genres'] as List?)?.map((g) => g['name'].toString()).toList() ?? []
              ..studio = (node['studios'] as List?) != null && (node['studios'] as List).isNotEmpty 
                  ? node['studios'][0]['name'].toString() 
                  : null;
            watch.completedEpisodes = List<int>.generate(progressVal, (i) => i + 1);
            mergedAnime[key] = watch;
          }
        }
      }

      for (final watch in mergedAnime.values) {
        await isar.watchProgress.put(watch);
      }

      // 2. Merge Manga
      await isar.readingProgress.clear();
      final Map<String, ReadingProgress> mergedManga = {};

      for (final entry in alManga) {
        if (entry == null) continue;
        final media = entry['media'];
        if (media == null) continue;
        final alId = media['id'] as int? ?? 0;
        if (alId == 0) continue;
        final malId = media['idMal'] as int?;
        final progressVal = entry['progress'] as int? ?? 0;
        final totalChs = media['chapters'] as int? ?? 0;
        final totalVols = media['volumes'] as int? ?? 0;

        final read = ReadingProgress()
          ..mangaId = alId
          ..romajiTitle = media['title']?['romaji'] ?? media['title']?['english'] ?? media['title']?['native'] ?? 'Unknown'
          ..englishTitle = media['title']?['english']
          ..coverImage = media['coverImage']?['large'] ?? ''
          ..bannerImage = media['bannerImage'] as String?
          ..totalChapters = totalChs > 0 ? totalChs : null
          ..lastReadChapter = progressVal
          ..lastReadPage = 1
          ..readingPercentage = (totalChs > 0) ? (progressVal / totalChs) : 0.0
          ..lastReadAt = entry['updatedAt'] != null 
              ? DateTime.fromMillisecondsSinceEpoch((entry['updatedAt'] as int) * 1000)
              : DateTime.now()
          ..completedChapters = List<int>.generate(progressVal, (i) => i + 1)
          ..status = _mapStatusFromAniList(entry['status'] as String?)
          ..score = entry['score'] as int?
          ..notes = entry['notes'] as String?
          ..lastReadVolume = entry['progressVolumes'] as int? ?? 0
          ..totalVolumes = totalVols > 0 ? totalVols : null
          ..genres = (media['genres'] as List?)?.map((e) => e.toString()).toList() ?? []
          ..author = _getAuthor(media);

        final key = malId != null ? 'mal_$malId' : 'title_${read.romajiTitle.toLowerCase().trim()}';
        mergedManga[key] = read;
      }

      for (final entry in malManga) {
        if (entry == null) continue;
        final node = entry['node'];
        final listStatus = entry['list_status'];
        if (node == null || listStatus == null) continue;
        final malId = node['id'] as int? ?? 0;
        if (malId == 0) continue;
        final progressVal = listStatus['num_chapters_read'] as int? ?? 0;
        final totalChs = node['num_chapters'] as int? ?? 0;
        final totalVols = node['num_volumes'] as int? ?? 0;
        final key = 'mal_$malId';

        final malReadAt = listStatus['updated_at'] != null 
            ? DateTime.tryParse(listStatus['updated_at'] as String)?.toLocal() ?? DateTime.now()
            : DateTime.now();

        if (mergedManga.containsKey(key)) {
          final existing = mergedManga[key]!;
          existing.lastReadChapter = max(existing.lastReadChapter, progressVal);
          existing.completedChapters = List<int>.generate(existing.lastReadChapter, (i) => i + 1);
          final finalTotal = existing.totalChapters ?? totalChs;
          existing.readingPercentage = (finalTotal > 0) ? (existing.lastReadChapter / finalTotal) : 0.0;
          existing.score = max(existing.score ?? 0, listStatus['score'] as int? ?? 0);
          existing.lastReadVolume = max(existing.lastReadVolume, listStatus['num_volumes_read'] as int? ?? 0);
          
          final malStatus = _mapStatusFromMal(listStatus['status'] as String?, isManga: true);
          if (existing.status != 'Completed' && malStatus == 'Completed') {
            existing.status = 'Completed';
          }
          if (malReadAt.isAfter(existing.lastReadAt)) {
            existing.lastReadAt = malReadAt;
            if (listStatus['comments'] != null) {
              existing.notes = listStatus['comments'] as String;
            }
          }
        } else {
          final titleKey = 'title_${node['title'].toString().toLowerCase().trim()}';
          if (mergedManga.containsKey(titleKey)) {
            final existing = mergedManga[titleKey]!;
            existing.lastReadChapter = max(existing.lastReadChapter, progressVal);
            existing.completedChapters = List<int>.generate(existing.lastReadChapter, (i) => i + 1);
            final finalTotal = existing.totalChapters ?? totalChs;
            existing.readingPercentage = (finalTotal > 0) ? (existing.lastReadChapter / finalTotal) : 0.0;
            existing.score = max(existing.score ?? 0, listStatus['score'] as int? ?? 0);
            existing.lastReadVolume = max(existing.lastReadVolume, listStatus['num_volumes_read'] as int? ?? 0);
            
            final malStatus = _mapStatusFromMal(listStatus['status'] as String?, isManga: true);
            if (existing.status != 'Completed' && malStatus == 'Completed') {
              existing.status = 'Completed';
            }
            if (malReadAt.isAfter(existing.lastReadAt)) {
              existing.lastReadAt = malReadAt;
            }
          } else {
            final read = ReadingProgress()
              ..mangaId = malId
              ..romajiTitle = node['title'] ?? node['alternative_titles']?['en'] ?? 'Unknown'
              ..englishTitle = node['alternative_titles']?['en']
              ..coverImage = node['main_picture']?['large'] ?? node['main_picture']?['medium'] ?? ''
              ..bannerImage = null
              ..totalChapters = totalChs > 0 ? totalChs : null
              ..lastReadChapter = progressVal
              ..lastReadPage = 1
              ..readingPercentage = (totalChs > 0) ? (progressVal / totalChs) : 0.0
              ..lastReadAt = malReadAt
              ..completedChapters = List<int>.generate(progressVal, (i) => i + 1)
              ..status = _mapStatusFromMal(listStatus['status'] as String?, isManga: true)
              ..score = listStatus['score'] as int?
              ..notes = listStatus['comments'] as String?
              ..lastReadVolume = listStatus['num_volumes_read'] as int? ?? 0
              ..totalVolumes = totalVols > 0 ? totalVols : null
              ..genres = (node['genres'] as List?)?.map((g) => g['name'].toString()).toList() ?? []
              ..author = (node['authors'] as List?) != null && (node['authors'] as List).isNotEmpty 
                  ? node['authors'][0]['node']['name'].toString() 
                  : null;
            mergedManga[key] = read;
          }
        }
      }

      for (final read in mergedManga.values) {
        await isar.readingProgress.put(read);
      }

      // 3. Clear and re-populate Favorites from AniList
      await isar.favoriteAnimes.clear();
      for (final media in alFavs['anime']!) {
        if (media == null) continue;
        final animeId = media['id'] as int? ?? 0;
        if (animeId == 0) continue;
        final fav = FavoriteAnime()
          ..animeId = animeId
          ..romajiTitle = media['title']?['romaji'] ?? media['title']?['english'] ?? media['title']?['native'] ?? 'Unknown'
          ..englishTitle = media['title']?['english']
          ..coverImage = media['coverImage']?['large'] ?? ''
          ..bannerImage = media['bannerImage'] as String?
          ..averageScore = media['averageScore'] as int?
          ..episodes = media['episodes'] as int?
          ..status = media['status'] as String?
          ..studio = _getStudio(media)
          ..season = media['season'] as String?
          ..seasonYear = media['seasonYear'] as int?
          ..addedAt = DateTime.now();
        await isar.favoriteAnimes.put(fav);
      }

      await isar.favoriteMangas.clear();
      for (final media in alFavs['manga']!) {
        if (media == null) continue;
        final mangaId = media['id'] as int? ?? 0;
        if (mangaId == 0) continue;
        final fav = FavoriteManga()
          ..mangaId = mangaId
          ..romajiTitle = media['title']?['romaji'] ?? media['title']?['english'] ?? media['title']?['native'] ?? 'Unknown'
          ..englishTitle = media['title']?['english']
          ..coverImage = media['coverImage']?['large'] ?? ''
          ..bannerImage = media['bannerImage'] as String?
          ..chapters = media['chapters'] as int?
          ..volumes = media['volumes'] as int?
          ..status = media['status'] as String?
          ..author = _getAuthor(media)
          ..addedAt = DateTime.now();
        await isar.favoriteMangas.put(fav);
      }
    });

    _invalidateProgressProviders();
  }

  void _invalidateProgressProviders() {
    _ref.invalidate(continueWatchingProvider);
    _ref.invalidate(continueReadingProvider);
    _ref.invalidate(favoritesProvider);
    _ref.invalidate(mangaFavoritesProvider);
  }

  String? _getStudio(Map<String, dynamic> media) {
    final nodes = media['studios']?['nodes'] as List?;
    if (nodes != null && nodes.isNotEmpty) {
      return nodes[0]['name'] as String?;
    }
    return null;
  }

  String? _getAuthor(Map<String, dynamic> media) {
    final nodes = media['staff']?['nodes'] as List?;
    if (nodes != null && nodes.isNotEmpty) {
      return nodes[0]['name']?['full'] as String?;
    }
    return null;
  }

  // ==========================================
  // FULL BACKGROUND SYNC
  // ==========================================

  Future<void> triggerBackgroundSync() async {
    final aniListToken = _getAniListToken();
    final malToken = _getMalToken();
    if (aniListToken == null && malToken == null) return;

    try {
      if (aniListToken != null && malToken != null) {
        final choice = _ref.read(settingsNotifierProvider).libraryMergePreference;
        if (choice == 'merge') {
          await _importAndMergeBoth();
          return;
        }
      }
      if (aniListToken != null) {
        await _syncFromAniList(aniListToken);
      }
      if (malToken != null) {
        await _syncFromMal(malToken);
      }
    } catch (_) {}
  }

  Future<void> _syncFromAniList(String token) async {
    final userId = await _fetchAniListUserId(token);
    final animeEntries = await _fetchAniListAnimeList(token, userId);
    final watchRepo = WatchProgressRepository();

    for (final entry in animeEntries) {
      if (entry == null) continue;
      final media = entry['media'];
      if (media == null) continue;
      final animeId = media['id'] as int? ?? 0;
      if (animeId == 0) continue;
      final progressVal = entry['progress'] as int? ?? 0;
      final scoreVal = entry['score'] as int? ?? 0;
      final notesVal = entry['notes'] as String?;
      final statusStr = entry['status'] as String?;
      final totalEps = media['episodes'] as int? ?? 0;

      final existing = await watchRepo.getProgress(animeId);
      if (existing != null) {
        final priority = _ref.read(settingsNotifierProvider).syncPriority;
        if (priority == 'anilist' || existing.lastWatchedEpisode < progressVal) {
          existing.lastWatchedEpisode = progressVal;
          existing.score = scoreVal;
          existing.status = _mapStatusFromAniList(statusStr);
          existing.notes = notesVal;
          existing.totalEpisodes = totalEps > 0 ? totalEps : null;
          existing.watchPercentage = (totalEps > 0) ? (progressVal / totalEps) : 0.0;
          existing.completedEpisodes = List<int>.generate(progressVal, (i) => i + 1);
          await watchRepo.saveProgress(existing);
        }
      } else {
        final watch = WatchProgress()
          ..animeId = animeId
          ..malId = media['idMal'] as int?
          ..romajiTitle = media['title']?['romaji'] ?? media['title']?['english'] ?? media['title']?['native'] ?? 'Unknown'
          ..englishTitle = media['title']?['english']
          ..coverImage = media['coverImage']?['large'] ?? ''
          ..bannerImage = media['bannerImage'] as String?
          ..totalEpisodes = totalEps > 0 ? totalEps : null
          ..lastWatchedEpisode = progressVal
          ..lastWatchedPosition = 0
          ..lastWatchedDuration = 0
          ..watchPercentage = (totalEps > 0) ? (progressVal / totalEps) : 0.0
          ..lastWatchedSource = "AniList Sync"
          ..lastWatchedAudio = "sub"
          ..lastWatchedAt = DateTime.now()
          ..status = _mapStatusFromAniList(statusStr)
          ..score = scoreVal
          ..notes = notesVal
          ..genres = (media['genres'] as List?)?.map((e) => e.toString()).toList() ?? []
          ..studio = _getStudio(media);
        watch.completedEpisodes = List<int>.generate(progressVal, (i) => i + 1);
        await watchRepo.saveProgress(watch);
      }
    }
  }

  Future<void> _syncFromMal(String token) async {
    final animeEntries = await _fetchMalAnimeList(token);
    final watchRepo = WatchProgressRepository();

    for (final entry in animeEntries) {
      final node = entry['node'];
      final malId = node['id'] as int;
      final listStatus = entry['list_status'];
      final progressVal = listStatus['num_episodes_watched'] as int;
      final scoreVal = listStatus['score'] as int;
      final statusStr = listStatus['status'] as String;

      final allLocal = await watchRepo.getContinueWatching();
      final localMatch = allLocal.where((x) => x.malId == malId).firstOrNull;

      if (localMatch != null) {
        final priority = _ref.read(settingsNotifierProvider).syncPriority;
        if (priority == 'myanimelist' || localMatch.lastWatchedEpisode < progressVal) {
          localMatch.lastWatchedEpisode = progressVal;
          localMatch.score = scoreVal;
          localMatch.status = _mapStatusFromMal(statusStr, isManga: false);
          localMatch.completedEpisodes = List<int>.generate(progressVal, (i) => i + 1);
          await watchRepo.saveProgress(localMatch);
        }
      }
    }
  }

  // ==========================================
  // STATUS MAPPINGS
  // ==========================================

  static String _mapStatusToAniList(String? status) {
    if (status == null) return 'PLANNING';
    final s = status.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
    if (s == 'watching' || s == 'reading') return 'CURRENT';
    if (s == 'completed') return 'COMPLETED';
    if (s == 'onhold' || s == 'paused') return 'PAUSED';
    if (s == 'dropped') return 'DROPPED';
    return 'PLANNING';
  }

  static String _mapStatusFromAniList(String? aniStatus) {
    if (aniStatus == null) return 'Plan To Watch';
    final s = aniStatus.toUpperCase();
    if (s == 'CURRENT') return 'Watching';
    if (s == 'COMPLETED') return 'Completed';
    if (s == 'PAUSED') return 'On Hold';
    if (s == 'DROPPED') return 'Dropped';
    return 'Plan To Watch';
  }

  static String _mapStatusToMal(String? status, {required bool isManga}) {
    if (status == null) return isManga ? 'plan_to_read' : 'plan_to_watch';
    final s = status.toLowerCase().replaceAll(' ', '').replaceAll('-', '');
    if (s == 'watching' || s == 'reading') return isManga ? 'reading' : 'watching';
    if (s == 'completed') return 'completed';
    if (s == 'onhold' || s == 'paused') return 'on_hold';
    if (s == 'dropped') return 'dropped';
    return isManga ? 'plan_to_read' : 'plan_to_watch';
  }

  static String _mapStatusFromMal(String? malStatus, {required bool isManga}) {
    if (malStatus == null) return isManga ? 'Plan To Read' : 'Plan To Watch';
    final s = malStatus.toLowerCase().replaceAll('_', '').replaceAll('-', '');
    if (s == 'watching' || s == 'reading') return isManga ? 'Reading' : 'Watching';
    if (s == 'completed') return 'Completed';
    if (s == 'onhold') return 'On Hold';
    if (s == 'dropped') return 'Dropped';
    return isManga ? 'Plan To Read' : 'Plan To Watch';
  }
}
