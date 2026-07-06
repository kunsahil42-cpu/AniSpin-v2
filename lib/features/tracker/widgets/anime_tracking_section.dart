import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/watch_progress.dart';
import '../providers/tracker_providers.dart';
import '../../../core/database/isar_service.dart';

class AnimeTrackingSection extends ConsumerStatefulWidget {
  final int animeId;
  final int? malId;
  final String title;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int? totalEpisodes;

  const AnimeTrackingSection({
    super.key,
    required this.animeId,
    this.malId,
    required this.title,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    this.totalEpisodes,
  });

  @override
  ConsumerState<AnimeTrackingSection> createState() => _AnimeTrackingSectionState();
}

class _AnimeTrackingSectionState extends ConsumerState<AnimeTrackingSection> {
  final _notesController = TextEditingController();
  bool _isInit = false;

  // Local State Variables
  String? _status;
  int? _score;
  int _episode = 0;
  DateTime? _dateStarted;
  DateTime? _dateFinished;
  int _rewatchCount = 0;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveAllChanges(WatchProgress existing) async {
    final repo = ref.read(watchProgressRepositoryProvider);
    
    final progress = existing
      ..status = _status
      ..score = _score == -1 ? null : _score
      ..lastWatchedEpisode = _episode.clamp(0, widget.totalEpisodes ?? 9999)
      ..dateStarted = _dateStarted
      ..dateFinished = _dateFinished
      ..rewatchCount = _rewatchCount.clamp(0, 999)
      ..notes = _notesController.text
      ..lastWatchedAt = DateTime.now();

    if (widget.totalEpisodes != null && widget.totalEpisodes! > 0) {
      progress.watchPercentage = progress.lastWatchedEpisode / widget.totalEpisodes!;
    } else {
      progress.watchPercentage = 0.0;
    }

    await repo.saveProgress(progress);
    ref.invalidate(animeProgressProvider(widget.animeId));
    ref.invalidate(continueWatchingProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tracking changes saved successfully!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _initializeTracking() async {
    final repo = ref.read(watchProgressRepositoryProvider);
    final progress = WatchProgress()
      ..animeId = widget.animeId
      ..malId = widget.malId
      ..romajiTitle = widget.title
      ..englishTitle = widget.englishTitle
      ..coverImage = widget.coverImage
      ..bannerImage = widget.bannerImage
      ..totalEpisodes = widget.totalEpisodes
      ..lastWatchedEpisode = 0
      ..lastWatchedPosition = 0
      ..lastWatchedDuration = 0
      ..watchPercentage = 0.0
      ..lastWatchedSource = 'Tracking Section'
      ..lastWatchedAudio = 'Sub'
      ..status = 'Watching'
      ..lastWatchedAt = DateTime.now();

    await repo.saveProgress(progress);
    ref.invalidate(animeProgressProvider(widget.animeId));
    ref.invalidate(continueWatchingProvider);
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(animeProgressProvider(widget.animeId));
    final theme = Theme.of(context);

    return progressAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error loading tracker: $err')),
      data: (progress) {
        if (progress == null) {
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.analytics_outlined, size: 36, color: Colors.grey),
                  const SizedBox(height: 10),
                  const Text(
                    'Not Tracked Yet',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add this anime to your tracker to log your progress, score, and notes.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    onPressed: _initializeTracking,
                    icon: const Icon(Icons.add_task_rounded),
                    label: const Text('Add to Tracker'),
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (!_isInit) {
          _status = progress.status ?? 'Watching';
          _score = progress.score ?? -1;
          _episode = progress.lastWatchedEpisode;
          _dateStarted = progress.dateStarted;
          _dateFinished = progress.dateFinished;
          _rewatchCount = progress.rewatchCount;
          _notesController.text = progress.notes ?? '';
          _isInit = true;
        }

        final statuses = ['Watching', 'Completed', 'Plan To Watch', 'On Hold', 'Dropped'];
        final currentStatus = statuses.contains(_status) ? _status : 'Watching';

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
          ),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.15),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '📊 Tracking',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent),
                      tooltip: 'Remove from Tracker',
                      onPressed: () async {
                        final repo = ref.read(watchProgressRepositoryProvider);
                        final backup = WatchProgress()
                          ..animeId = progress.animeId
                          ..malId = progress.malId
                          ..romajiTitle = progress.romajiTitle
                          ..englishTitle = progress.englishTitle
                          ..coverImage = progress.coverImage
                          ..bannerImage = progress.bannerImage
                          ..totalEpisodes = progress.totalEpisodes
                          ..lastWatchedEpisode = progress.lastWatchedEpisode
                          ..lastWatchedPosition = progress.lastWatchedPosition
                          ..lastWatchedDuration = progress.lastWatchedDuration
                          ..watchPercentage = progress.watchPercentage
                          ..lastWatchedSource = progress.lastWatchedSource
                          ..lastWatchedAudio = progress.lastWatchedAudio
                          ..lastWatchedAt = progress.lastWatchedAt
                          ..completedEpisodes = List<int>.from(progress.completedEpisodes)
                          ..status = progress.status
                          ..score = progress.score
                          ..dateStarted = progress.dateStarted
                          ..dateFinished = progress.dateFinished
                          ..rewatchCount = progress.rewatchCount
                          ..notes = progress.notes;

                        final isar = IsarService.instance;
                        await isar.writeTxn(() async {
                          await isar.watchProgress.delete(progress.id);
                        });
                        
                        setState(() {
                          _isInit = false;
                        });

                        ref.invalidate(animeProgressProvider(widget.animeId));
                        ref.invalidate(continueWatchingProvider);

                        final messenger = ScaffoldMessenger.of(context);
                        messenger.clearSnackBars();

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
                                await repo.saveProgress(backup);
                                ref.invalidate(animeProgressProvider(widget.animeId));
                                ref.invalidate(continueWatchingProvider);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Status dropdown
                DropdownButtonFormField<String>(
                  initialValue: currentStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: statuses.map((status) {
                    return DropdownMenuItem<String>(
                      value: status,
                      child: Text(status),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _status = val;
                    });
                  },
                ),
                const SizedBox(height: 14),

                // Episode Progress
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Episode $_episode / ${widget.totalEpisodes ?? "?"}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                      onPressed: _episode > 0
                          ? () {
                              setState(() {
                                _episode--;
                              });
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      onPressed: (widget.totalEpisodes == null || _episode < widget.totalEpisodes!)
                          ? () {
                              setState(() {
                                _episode++;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Score selection (0 to 10)
                DropdownButtonFormField<int>(
                  initialValue: _score,
                  decoration: const InputDecoration(
                    labelText: 'Score',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem<int>(value: -1, child: Text('No Score')),
                    ...List.generate(11, (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(index.toString()),
                      );
                    }),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _score = val;
                    });
                  },
                ),
                const SizedBox(height: 14),

                // Dates Started and Finished
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final selected = await showDatePicker(
                            context: context,
                            initialDate: _dateStarted ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (selected != null) {
                            setState(() {
                              _dateStarted = selected;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date Started',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            suffixIcon: _dateStarted != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _dateStarted = null;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          child: Text(
                            _dateStarted != null
                                ? '${_dateStarted!.day}/${_dateStarted!.month}/${_dateStarted!.year}'
                                : 'Not Set',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final selected = await showDatePicker(
                            context: context,
                            initialDate: _dateFinished ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (selected != null) {
                            setState(() {
                              _dateFinished = selected;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Date Finished',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            suffixIcon: _dateFinished != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      setState(() {
                                        _dateFinished = null;
                                      });
                                    },
                                  )
                                : null,
                          ),
                          child: Text(
                            _dateFinished != null
                                ? '${_dateFinished!.day}/${_dateFinished!.month}/${_dateFinished!.year}'
                                : 'Not Set',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Rewatch count
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Rewatch Count',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_rounded),
                      onPressed: _rewatchCount > 0
                          ? () {
                              setState(() {
                                _rewatchCount--;
                              });
                            }
                          : null,
                    ),
                    Text(
                      '$_rewatchCount',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () {
                        setState(() {
                          _rewatchCount++;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Notes text field
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _saveAllChanges(progress),
                    icon: const Icon(Icons.save_rounded),
                    label: const Text('Save Changes'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
