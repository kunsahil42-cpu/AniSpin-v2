import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/tracker_providers.dart';
import '../models/watch_progress.dart';
import '../models/reading_progress.dart';


class TrackerScreen extends ConsumerStatefulWidget {
  const TrackerScreen({super.key});

  @override
  ConsumerState<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends ConsumerState<TrackerScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<int> _pendingAnime = {};
  final Set<int> _pendingManga = {};

  // Search & Filter State
  String _searchQuery = '';
  String _selectedStatusFilter = 'All';
  String _selectedSort = 'Recently Updated';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedStatusFilter = 'All';
          _searchQuery = '';
        });
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _runUndoableWatchRemoval(WatchProgress item) async {
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(watchProgressRepositoryProvider);
    
    setState(() {
      _pendingAnime.add(item.animeId);
    });

    await repo.deleteProgress(item);
    ref.invalidate(continueWatchingProvider);
    ref.invalidate(animeProgressProvider(item.animeId));

    if (mounted) {
      setState(() {
        _pendingAnime.remove(item.animeId);
      });
    }

    messenger.hideCurrentSnackBar();

    Timer? undoTimer;
    undoTimer = Timer(const Duration(seconds: 5), () {
      messenger.hideCurrentSnackBar();
    });

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 5),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text("Removed from Tracker")),
          ],
        ),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () async {
            undoTimer?.cancel();
            await repo.saveProgress(item);
            ref.invalidate(continueWatchingProvider);
            ref.invalidate(animeProgressProvider(item.animeId));
          },
        ),
      ),
    );
  }

  Future<void> _runUndoableMangaRemoval(ReadingProgress item) async {
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(readingProgressRepositoryProvider);

    setState(() {
      _pendingManga.add(item.mangaId);
    });

    await repo.deleteProgress(item);
    ref.invalidate(continueReadingProvider);
    ref.invalidate(mangaProgressProvider(item.mangaId));

    if (mounted) {
      setState(() {
        _pendingManga.remove(item.mangaId);
      });
    }

    messenger.hideCurrentSnackBar();

    Timer? undoTimer;
    undoTimer = Timer(const Duration(seconds: 5), () {
      messenger.hideCurrentSnackBar();
    });

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 5),
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text("Removed from Tracker")),
          ],
        ),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () async {
            undoTimer?.cancel();
            await repo.saveProgress(item);
            ref.invalidate(continueReadingProvider);
            ref.invalidate(mangaProgressProvider(item.mangaId));
          },
        ),
      ),
    );
  }

  String _getFavoriteGenre(List<List<String>> genresList) {
    final Map<String, int> counts = {};
    for (final genres in genresList) {
      for (final genre in genres) {
        counts[genre] = (counts[genre] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return 'None';
    var favorite = 'None';
    var maxCount = 0;
    counts.forEach((genre, count) {
      if (count > maxCount) {
        maxCount = count;
        favorite = genre;
      }
    });
    return favorite;
  }

  String _getFavoriteStudioOrAuthor(List<String?> items) {
    final Map<String, int> counts = {};
    for (final item in items) {
      if (item != null && item.isNotEmpty) {
        counts[item] = (counts[item] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return 'None';
    var favorite = 'None';
    var maxCount = 0;
    counts.forEach((name, count) {
      if (count > maxCount) {
        maxCount = count;
        favorite = name;
      }
    });
    return favorite;
  }

  @override
  Widget build(BuildContext context) {
    final continueWatchingAsync = ref.watch(continueWatchingProvider);
    final continueReadingAsync = ref.watch(continueReadingProvider);
    final theme = Theme.of(context);

    final showSearchAndFilter = _tabController.index == 0 || _tabController.index == 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📊 Track progress'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(icon: Icon(Icons.movie_outlined), text: 'Anime History'),
            Tab(icon: Icon(Icons.menu_book_outlined), text: 'Manga History'),
            Tab(icon: Icon(Icons.analytics_outlined), text: 'Statistics'),
            Tab(icon: Icon(Icons.history_toggle_off_rounded), text: 'Timeline'),
          ],
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
        ),
      ),
      body: Column(
        children: [
          // Dynamic Search, Sort & Status Filters
          if (showSearchAndFilter) _buildSearchAndFilterHeader(theme),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Anime History
                continueWatchingAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error: $err')),
                  data: (list) {
                    var filtered = list
                        .where((item) => !_pendingAnime.contains(item.animeId))
                        .toList();

                    // Apply Search
                    if (_searchQuery.isNotEmpty) {
                      filtered = filtered.where((item) {
                        final title = item.romajiTitle.toLowerCase();
                        final engTitle = item.englishTitle?.toLowerCase() ?? '';
                        return title.contains(_searchQuery.toLowerCase()) || engTitle.contains(_searchQuery.toLowerCase());
                      }).toList();
                    }

                    // Apply Status Filter
                    if (_selectedStatusFilter != 'All') {
                      filtered = filtered.where((item) {
                        final status = item.status ?? 'Watching';
                        return status.toLowerCase() == _selectedStatusFilter.toLowerCase();
                      }).toList();
                    }

                    // Apply Sort
                    if (_selectedSort == 'Recently Updated') {
                      filtered.sort((a, b) => b.lastWatchedAt.compareTo(a.lastWatchedAt));
                    } else if (_selectedSort == 'Recently Added') {
                      filtered.sort((a, b) => b.id.compareTo(a.id));
                    } else if (_selectedSort == 'Highest Score') {
                      filtered.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
                    } else if (_selectedSort == 'A-Z') {
                      filtered.sort((a, b) => a.romajiTitle.toLowerCase().compareTo(b.romajiTitle.toLowerCase()));
                    } else if (_selectedSort == 'Progress') {
                      filtered.sort((a, b) => b.watchPercentage.compareTo(a.watchPercentage));
                    }

                    if (filtered.isEmpty) {
                      return const _EmptyHistory(
                        icon: Icons.movie_creation_outlined,
                        message: 'No matching anime watch history found.',
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        final key = ValueKey("anime_dismiss_${item.animeId}_${item.id}");
                        return Dismissible(
                          key: key,
                          direction: DismissDirection.endToStart,
                          background: Container(color: Colors.transparent),
                          onDismissed: (_) => _runUndoableWatchRemoval(item),
                          child: _WatchProgressTile(
                            item: item,
                            onTap: () {
                              context.push(
                                '/anime/${item.animeId}?title=${Uri.encodeComponent(item.romajiTitle)}',
                              );
                            },
                            onDelete: () => _runUndoableWatchRemoval(item),
                          )
                              .animate()
                              .fadeIn(duration: 350.ms)
                              .slideY(
                                begin: .15,
                                end: 0,
                                duration: 350.ms,
                              ),
                        );
                      },
                    );
                  },
                ),

                // Tab 2: Manga History
                continueReadingAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Error: $err')),
                  data: (list) {
                    var filtered = list
                        .where((item) => !_pendingManga.contains(item.mangaId))
                        .toList();

                    // Apply Search
                    if (_searchQuery.isNotEmpty) {
                      filtered = filtered.where((item) {
                        final title = item.romajiTitle.toLowerCase();
                        final engTitle = item.englishTitle?.toLowerCase() ?? '';
                        return title.contains(_searchQuery.toLowerCase()) || engTitle.contains(_searchQuery.toLowerCase());
                      }).toList();
                    }

                    // Apply Status Filter
                    if (_selectedStatusFilter != 'All') {
                      filtered = filtered.where((item) {
                        final status = item.status ?? 'Reading';
                        return status.toLowerCase() == _selectedStatusFilter.toLowerCase();
                      }).toList();
                    }

                    // Apply Sort
                    if (_selectedSort == 'Recently Updated') {
                      filtered.sort((a, b) => b.lastReadAt.compareTo(a.lastReadAt));
                    } else if (_selectedSort == 'Recently Added') {
                      filtered.sort((a, b) => b.id.compareTo(a.id));
                    } else if (_selectedSort == 'Highest Score') {
                      filtered.sort((a, b) => (b.score ?? 0).compareTo(a.score ?? 0));
                    } else if (_selectedSort == 'A-Z') {
                      filtered.sort((a, b) => a.romajiTitle.toLowerCase().compareTo(b.romajiTitle.toLowerCase()));
                    } else if (_selectedSort == 'Progress') {
                      filtered.sort((a, b) => b.readingPercentage.compareTo(a.readingPercentage));
                    }

                    if (filtered.isEmpty) {
                      return const _EmptyHistory(
                        icon: Icons.menu_book_outlined,
                        message: 'No matching manga reading history found.',
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        final key = ValueKey("manga_dismiss_${item.mangaId}_${item.id}");
                        return Dismissible(
                          key: key,
                          direction: DismissDirection.endToStart,
                          background: Container(color: Colors.transparent),
                          onDismissed: (_) => _runUndoableMangaRemoval(item),
                          child: _ReadingProgressTile(
                            item: item,
                            onTap: () {
                              context.push(
                                '/manga/${item.mangaId}?title=${Uri.encodeComponent(item.romajiTitle)}',
                              );
                            },
                            onDelete: () => _runUndoableMangaRemoval(item),
                          )
                              .animate()
                              .fadeIn(duration: 350.ms)
                              .slideY(
                                begin: .15,
                                end: 0,
                                duration: 350.ms,
                              ),
                        );
                      },
                    );
                  },
                ),

                // Tab 3: Statistics Tab
                _buildStatsView(continueWatchingAsync, continueReadingAsync, theme),

                // Tab 4: Activity Timeline Tab
                _buildTimelineView(continueWatchingAsync, continueReadingAsync, theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterHeader(ThemeData theme) {
    final isAnime = _tabController.index == 0;
    final statuses = isAnime
        ? ['All', 'Watching', 'Completed', 'Plan To Watch', 'On Hold', 'Dropped']
        : ['All', 'Reading', 'Completed', 'Plan To Read', 'On Hold', 'Dropped'];

    final sortOptions = ['Recently Updated', 'Recently Added', 'Highest Score', 'A-Z', 'Progress'];

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: isAnime ? 'Search anime in tracker...' : 'Search manga in tracker...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort_rounded),
                tooltip: 'Sort Options',
                onSelected: (val) {
                  setState(() {
                    _selectedSort = val;
                  });
                },
                itemBuilder: (context) {
                  return sortOptions.map((opt) {
                    return PopupMenuItem<String>(
                      value: opt,
                      child: Row(
                        children: [
                          Icon(
                            opt == _selectedSort ? Icons.radio_button_checked : Icons.radio_button_off,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(opt),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: statuses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final status = statuses[index];
                final isSelected = _selectedStatusFilter.toLowerCase() == status.toLowerCase();

                return FilterChip(
                  label: Text(status),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatusFilter = selected ? status : 'All';
                    });
                  },
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsView(
    AsyncValue<List<WatchProgress>> animeAsync,
    AsyncValue<List<ReadingProgress>> mangaAsync,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📺 Anime Stats', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          animeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading stats: $err'),
            data: (list) {
              final activeList = list
                  .where((item) => !_pendingAnime.contains(item.animeId))
                  .toList();

              if (activeList.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text("No Anime stats yet.")));
              
              final totalWatched = activeList.length;
              final totalEpisodes = activeList.fold<int>(0, (sum, item) => sum + item.lastWatchedEpisode);
              final totalHours = (totalEpisodes * 24 / 60).round();
              
              final scoredList = activeList.where((item) => item.score != null && item.score! > 0).toList();
              final avgScore = scoredList.isEmpty
                  ? 0.0
                  : scoredList.fold<int>(0, (sum, item) => sum + item.score!) / scoredList.length;

              final watching = activeList.where((item) => (item.status ?? 'Watching').toLowerCase() == 'watching').length;
              final completed = activeList.where((item) => (item.status ?? '').toLowerCase() == 'completed').length;
              final planToWatch = activeList.where((item) => (item.status ?? '').toLowerCase() == 'plan to watch').length;
              final dropped = activeList.where((item) => (item.status ?? '').toLowerCase() == 'dropped').length;

              final favoriteGenre = _getFavoriteGenre(activeList.map((item) => item.genres).toList());
              final favoriteStudio = _getFavoriteStudioOrAuthor(activeList.map((item) => item.studio).toList());

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard("Episodes", totalEpisodes.toString(), Icons.play_circle_fill, theme)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMetricCard("Hours Watched", "$totalHours hr", Icons.timer, theme)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMetricCard("Avg Score", avgScore.toStringAsFixed(1), Icons.star, theme)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard("Favorite Genre", favoriteGenre, Icons.theater_comedy_rounded, theme)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMetricCard("Top Studio", favoriteStudio, Icons.business_rounded, theme)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Status Breakdown", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          _buildProgressBarRow("Watching", watching, totalWatched, Colors.blue),
                          const SizedBox(height: 8),
                          _buildProgressBarRow("Completed", completed, totalWatched, Colors.green),
                          const SizedBox(height: 8),
                          _buildProgressBarRow("Plan To Watch", planToWatch, totalWatched, Colors.purple),
                          const SizedBox(height: 8),
                          _buildProgressBarRow("Dropped", dropped, totalWatched, Colors.redAccent),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          Text('📖 Manga Stats', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          mangaAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Text('Error loading stats: $err'),
            data: (list) {
              final activeList = list
                  .where((item) => !_pendingManga.contains(item.mangaId))
                  .toList();

              if (activeList.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text("No Manga stats yet.")));

              final totalTracked = activeList.length;
              final totalChapters = activeList.fold<int>(0, (sum, item) => sum + item.lastReadChapter);
              final totalVolumes = activeList.fold<int>(0, (sum, item) => sum + item.lastReadVolume);
              
              final scoredList = activeList.where((item) => item.score != null && item.score! > 0).toList();
              final avgScore = scoredList.isEmpty
                  ? 0.0
                  : scoredList.fold<int>(0, (sum, item) => sum + item.score!) / scoredList.length;

              final reading = activeList.where((item) => (item.status ?? 'Reading').toLowerCase() == 'reading').length;
              final completed = activeList.where((item) => (item.status ?? '').toLowerCase() == 'completed').length;
              final planToRead = activeList.where((item) => (item.status ?? '').toLowerCase() == 'plan to read').length;

              final favoriteGenre = _getFavoriteGenre(activeList.map((item) => item.genres).toList());
              final favoriteAuthor = _getFavoriteStudioOrAuthor(activeList.map((item) => item.author).toList());

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard("Chapters Read", totalChapters.toString(), Icons.chrome_reader_mode, theme)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMetricCard("Volumes", totalVolumes.toString(), Icons.layers_rounded, theme)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMetricCard("Avg Score", avgScore.toStringAsFixed(1), Icons.star_purple500, theme)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard("Favorite Genre", favoriteGenre, Icons.theater_comedy_rounded, theme)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildMetricCard("Top Author", favoriteAuthor, Icons.history_edu_rounded, theme)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Status Breakdown", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          _buildProgressBarRow("Reading", reading, totalTracked, Colors.blue),
                          const SizedBox(height: 8),
                          _buildProgressBarRow("Completed", completed, totalTracked, Colors.green),
                          const SizedBox(height: 8),
                          _buildProgressBarRow("Plan To Read", planToRead, totalTracked, Colors.purple),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              value, 
              maxLines: 1, 
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              title, 
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center, 
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBarRow(String label, int value, int total, Color color) {
    final ratio = total > 0 ? value / total : 0.0;
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 12))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              color: color,
              backgroundColor: color.withValues(alpha: 0.15),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('$value', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildTimelineView(
    AsyncValue<List<WatchProgress>> animeAsync,
    AsyncValue<List<ReadingProgress>> mangaAsync,
    ThemeData theme,
  ) {
    final List<_ActivityItem> activities = [];

    final animeList = (animeAsync.value ?? [])
        .where((item) => !_pendingAnime.contains(item.animeId))
        .toList();
    for (final item in animeList) {
      activities.add(_ActivityItem(
        title: item.romajiTitle,
        details: 'Watched Episode ${item.lastWatchedEpisode} • ${item.status ?? "Watching"}',
        timestamp: item.lastWatchedAt,
        coverImage: item.coverImage,
        isAnime: true,
      ));
    }

    final mangaList = (mangaAsync.value ?? [])
        .where((item) => !_pendingManga.contains(item.mangaId))
        .toList();
    for (final item in mangaList) {
      activities.add(_ActivityItem(
        title: item.romajiTitle,
        details: 'Read Chapter ${item.lastReadChapter} • ${item.status ?? "Reading"}',
        timestamp: item.lastReadAt,
        coverImage: item.coverImage,
        isAnime: false,
      ));
    }

    activities.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    if (activities.isEmpty) {
      return const _EmptyHistory(
        icon: Icons.history_toggle_off_rounded,
        message: "No recent tracking activities.",
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 2,
                      color: index == activities.length - 1
                          ? Colors.transparent
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: activity.coverImage,
                              width: 45,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  activity.details,
                                  style: TextStyle(color: theme.colorScheme.primary, fontSize: 12),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTimeAgo(activity.timestamp),
                                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _ActivityItem {
  final String title;
  final String details;
  final DateTime timestamp;
  final String coverImage;
  final bool isAnime;

  _ActivityItem({
    required this.title,
    required this.details,
    required this.timestamp,
    required this.coverImage,
    required this.isAnime,
  });
}

class _WatchProgressTile extends StatelessWidget {
  final WatchProgress item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _WatchProgressTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.coverImage,
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.romajiTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Episode ${item.lastWatchedEpisode} (${item.status ?? "Watching"})',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: (item.watchPercentage.isNaN || item.watchPercentage.isInfinite) ? 0.0 : item.watchPercentage,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${((item.watchPercentage.isNaN || item.watchPercentage.isInfinite) ? 0.0 : item.watchPercentage * 100).toInt()}% completed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadingProgressTile extends StatelessWidget {
  final ReadingProgress item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ReadingProgressTile({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.coverImage,
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.romajiTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chapter ${item.lastReadChapter} (Vol ${item.lastReadVolume}) (${item.status ?? "Reading"})',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: (item.readingPercentage.isNaN || item.readingPercentage.isInfinite) ? 0.0 : item.readingPercentage,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${((item.readingPercentage.isNaN || item.readingPercentage.isInfinite) ? 0.0 : item.readingPercentage * 100).toInt()}% completed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyHistory({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}