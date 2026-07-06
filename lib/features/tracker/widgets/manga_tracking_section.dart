import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reading_progress.dart';
import '../providers/tracker_providers.dart';
import '../../../core/database/isar_service.dart';

class MangaTrackingSection extends ConsumerStatefulWidget {
  final int mangaId;
  final String title;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int? totalChapters;
  final int? totalVolumes;
  final List<String>? genres;
  final String? author;

  const MangaTrackingSection({
    super.key,
    required this.mangaId,
    required this.title,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    this.totalChapters,
    this.totalVolumes,
    this.genres,
    this.author,
  });

  @override
  ConsumerState<MangaTrackingSection> createState() => _MangaTrackingSectionState();
}

class _MangaTrackingSectionState extends ConsumerState<MangaTrackingSection> {
  final _notesController = TextEditingController();
  bool _isInit = false;

  // Local State Variables
  String? _status;
  int? _score;
  int _chapter = 0;
  int _volume = 0;
  DateTime? _dateStarted;
  DateTime? _dateFinished;
  int _rereadCount = 0;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveAllChanges(ReadingProgress existing) async {
    final repo = ref.read(readingProgressRepositoryProvider);
    
    final progress = existing
      ..status = _status
      ..score = _score == -1 ? null : _score
      ..lastReadChapter = _chapter.clamp(0, widget.totalChapters ?? 9999)
      ..lastReadVolume = _volume.clamp(0, widget.totalVolumes ?? 999)
      ..dateStarted = _dateStarted
      ..dateFinished = _dateFinished
      ..rereadCount = _rereadCount.clamp(0, 999)
      ..notes = _notesController.text
      ..lastReadAt = DateTime.now()
      ..genres = widget.genres ?? []
      ..author = widget.author;

    if (widget.totalChapters != null && widget.totalChapters! > 0) {
      progress.readingPercentage = progress.lastReadChapter / widget.totalChapters!;
    } else {
      progress.readingPercentage = 0.0;
    }

    await repo.saveProgress(progress);
    ref.invalidate(mangaProgressProvider(widget.mangaId));
    ref.invalidate(continueReadingProvider);

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
    final repo = ref.read(readingProgressRepositoryProvider);
    final progress = ReadingProgress()
      ..mangaId = widget.mangaId
      ..romajiTitle = widget.title
      ..englishTitle = widget.englishTitle
      ..coverImage = widget.coverImage
      ..bannerImage = widget.bannerImage
      ..totalChapters = widget.totalChapters
      ..totalVolumes = widget.totalVolumes
      ..lastReadChapter = 0
      ..lastReadPage = 0
      ..readingPercentage = 0.0
      ..lastReadAt = DateTime.now()
      ..status = 'Reading'
      ..lastReadVolume = 0
      ..genres = widget.genres ?? []
      ..author = widget.author;

    await repo.saveProgress(progress);
    ref.invalidate(mangaProgressProvider(widget.mangaId));
    ref.invalidate(continueReadingProvider);
  }

  @override
  Widget build(BuildContext context) {
    final progressAsync = ref.watch(mangaProgressProvider(widget.mangaId));
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
                    'Add this manga to your tracker to log your progress, score, and notes.',
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
          _status = progress.status ?? 'Reading';
          _score = progress.score ?? -1;
          _chapter = progress.lastReadChapter;
          _volume = progress.lastReadVolume;
          _dateStarted = progress.dateStarted;
          _dateFinished = progress.dateFinished;
          _rereadCount = progress.rereadCount;
          _notesController.text = progress.notes ?? '';
          _isInit = true;
        }

        final statuses = ['Reading', 'Completed', 'Plan To Read', 'On Hold', 'Dropped'];
        final currentStatus = statuses.contains(_status) ? _status : 'Reading';

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
                        final repo = ref.read(readingProgressRepositoryProvider);
                        final backup = ReadingProgress()
                          ..mangaId = progress.mangaId
                          ..romajiTitle = progress.romajiTitle
                          ..englishTitle = progress.englishTitle
                          ..coverImage = progress.coverImage
                          ..bannerImage = progress.bannerImage
                          ..totalChapters = progress.totalChapters
                          ..totalVolumes = progress.totalVolumes
                          ..lastReadChapter = progress.lastReadChapter
                          ..lastReadPage = progress.lastReadPage
                          ..readingPercentage = progress.readingPercentage
                          ..lastReadAt = progress.lastReadAt
                          ..lastReadVolume = progress.lastReadVolume
                          ..completedChapters = List<int>.from(progress.completedChapters)
                          ..status = progress.status
                          ..score = progress.score
                          ..dateStarted = progress.dateStarted
                          ..dateFinished = progress.dateFinished
                          ..rereadCount = progress.rereadCount
                          ..notes = progress.notes;

                        final isar = IsarService.instance;
                        await isar.writeTxn(() async {
                          await isar.readingProgress.delete(progress.id);
                        });
                        
                        setState(() {
                          _isInit = false;
                        });

                        ref.invalidate(mangaProgressProvider(widget.mangaId));
                        ref.invalidate(continueReadingProvider);

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
                                ref.invalidate(mangaProgressProvider(widget.mangaId));
                                ref.invalidate(continueReadingProvider);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Status
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

                // Chapter Progress
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Chapter $_chapter / ${widget.totalChapters ?? "?"}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                      onPressed: _chapter > 0
                          ? () {
                              setState(() {
                                _chapter--;
                              });
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      onPressed: (widget.totalChapters == null || _chapter < widget.totalChapters!)
                          ? () {
                              setState(() {
                                _chapter++;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Volume Progress
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Volume $_volume / ${widget.totalVolumes ?? "?"}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                      onPressed: _volume > 0
                          ? () {
                              setState(() {
                                _volume--;
                              });
                            }
                          : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded),
                      onPressed: (widget.totalVolumes == null || _volume < widget.totalVolumes!)
                          ? () {
                              setState(() {
                                _volume++;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Score
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
                            labelText: 'Started Date',
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
                            labelText: 'Finished Date',
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

                // Reread count
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Reread Count',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_rounded),
                      onPressed: _rereadCount > 0
                          ? () {
                              setState(() {
                                _rereadCount--;
                              });
                            }
                          : null,
                    ),
                    Text(
                      '$_rereadCount',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded),
                      onPressed: () {
                        setState(() {
                          _rereadCount++;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 14),

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
