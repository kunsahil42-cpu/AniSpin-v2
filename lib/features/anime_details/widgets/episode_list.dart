import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../models/anime_details_model.dart';
import '../providers/anime_details_provider.dart';

class EpisodeList extends ConsumerStatefulWidget {
  final int animeId;
  final int? malId;
  final int totalEpisodes;
  final String? status;
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final List<StreamingEpisode> streamingEpisodes;
  final NextAiringEpisode? nextAiringEpisode;
  final ValueChanged<int>? onEpisodeSelected;

  const EpisodeList({
    super.key,
    required this.animeId,
    this.malId,
    required this.totalEpisodes,
    this.status,
    required this.romajiTitle,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.streamingEpisodes,
    this.nextAiringEpisode,
    this.onEpisodeSelected,
  });

  @override
  ConsumerState<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends ConsumerState<EpisodeList> {
  String _selectedAudio = 'Sub & Dub';
  ({int start, int end})? _selectedRange;
  String _searchQuery = '';
  final _searchController = TextEditingController();
  bool _showAiringBanner = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  int _getActualEpisodesCount() {
    // 1. If nextAiringEpisode is available (indicating active airing)
    if (widget.nextAiringEpisode != null) {
      return widget.nextAiringEpisode!.episode - 1;
    }

    int maxEp = widget.totalEpisodes;

    // 2. Parse streamingEpisodes to see if it lists a higher number
    if (widget.streamingEpisodes.isNotEmpty) {
      for (final ep in widget.streamingEpisodes) {
        final epNum = _extractEpisodeNumber(ep.title, 0);
        if (epNum != null && epNum > maxEp) {
          maxEp = epNum;
        }
      }
    }

    return maxEp > 0 ? maxEp : 12;
  }

  List<({int start, int end})> _getRanges(int actualTotal) {
    final List<({int start, int end})> ranges = [];
    for (int i = 1; i <= actualTotal; i += 100) {
      int end = i + 99;
      if (end > actualTotal) end = actualTotal;
      ranges.add((start: i, end: end));
    }
    return ranges;
  }

  String _formatAiringTime(int timestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toUtc();
    final year = dt.year;
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour24 = dt.hour;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    final hour = hour12.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$year/$month/$day $hour:$minute $period GMT';
  }

  int? _extractEpisodeNumber(String title, int indexFallback) {
    // Matches patterns like "Episode 12", "EP 12", "Ep. 12"
    final epRegex = RegExp(r'(?:episode|ep|ep\.)\s*(\d+)', caseSensitive: false);
    final match = epRegex.firstMatch(title);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    // Matches any standalone number
    final numRegex = RegExp(r'\b(\d+)\b');
    final matches = numRegex.allMatches(title);
    for (final m in matches) {
      final val = int.tryParse(m.group(0)!);
      if (val != null) return val;
    }
    return indexFallback;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressAsync = ref.watch(animeProgressProvider(widget.animeId));
    final actualTotal = _getActualEpisodesCount();

    return progressAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (progress) {
        final currentEp = progress?.lastWatchedEpisode ?? 1;
        final completed = progress?.completedEpisodes ?? [];

        // Determine default range based on current episode if not manually selected
        final ranges = _getRanges(actualTotal);
        final activeRange = _selectedRange ?? (() {
          return ranges.firstWhere(
            (r) => currentEp >= r.start && currentEp <= r.end,
            orElse: () => ranges.isNotEmpty ? ranges.first : (start: 1, end: 1),
          );
        })();

        // Filter episodes to show
        final List<int> episodesToShow = [];
        final query = _searchQuery.trim();
        if (query.isNotEmpty) {
          for (int i = 1; i <= actualTotal; i++) {
            if (i.toString().contains(query)) {
              episodesToShow.add(i);
            }
          }
        } else {
          for (int i = activeRange.start; i <= activeRange.end; i++) {
            episodesToShow.add(i);
          }
        }

        final newEpisodes = ref.watch(newEpisodesProvider(widget.animeId));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (newEpisodes.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.new_releases_rounded,
                          color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'New Episode Available! (Episode ${newEpisodes.join(", ")})',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18, color: theme.colorScheme.primary),
                        onPressed: () {
                          ref.read(newEpisodesProvider(widget.animeId).notifier).state = {};
                        },
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Next Airing Episode Banner ───────────────────────────────────
            if (widget.nextAiringEpisode != null && _showAiringBanner)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active_rounded,
                          color: theme.colorScheme.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'The next episode is predicted to arrive on '
                          '${_formatAiringTime(widget.nextAiringEpisode!.airingAt)} '
                          '(It\'s coming)',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18, color: theme.colorScheme.primary),
                        onPressed: () {
                          setState(() {
                            _showAiringBanner = false;
                          });
                        },
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // ── Title Header ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🎬 Episodes',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$actualTotal Episodes',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            // ── Controls Row ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  // Audio selector (Sub / Dub)
                  PopupMenuButton<String>(
                    initialValue: _selectedAudio,
                    onSelected: (val) {
                      setState(() {
                        _selectedAudio = val;
                      });
                    },
                    itemBuilder: (context) => ['Sub & Dub', 'Sub', 'Dub'].map((val) {
                      return PopupMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedAudio,
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Range selector (e.g. 1-100)
                  PopupMenuButton<({int start, int end})>(
                    initialValue: activeRange,
                    onSelected: (val) {
                      setState(() {
                        _selectedRange = val;
                      });
                    },
                    itemBuilder: (context) => ranges.map((r) {
                      return PopupMenuItem<({int start, int end})>(
                        value: r,
                        child: Text('${r.start}-${r.end}'),
                      );
                    }).toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${activeRange.start}-${activeRange.end}',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Search text field
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val;
                          });
                        },
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Find number',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          prefixIcon: Icon(Icons.search_rounded, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.12)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Grid of Episodes ─────────────────────────────────────────────
            episodesToShow.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No episodes found',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1.3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: episodesToShow.length,
                    itemBuilder: (context, index) {
                      final episodeNum = episodesToShow[index];
                      final isCurrent = episodeNum == currentEp;
                      final isCompleted = completed.contains(episodeNum);

                      Color bg = theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2);
                      Color textColor = theme.colorScheme.onSurface;
                      BorderSide border = BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.1));

                      if (isCurrent) {
                        bg = theme.colorScheme.primary.withValues(alpha: 0.15);
                        textColor = theme.colorScheme.primary;
                        border = BorderSide(color: theme.colorScheme.primary, width: 2);
                      } else if (isCompleted) {
                        textColor = Colors.green;
                        border = BorderSide(color: Colors.green.withValues(alpha: 0.5));
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.fromBorderSide(border),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () {
                              if (widget.onEpisodeSelected != null) {
                                widget.onEpisodeSelected!(episodeNum);
                                return;
                              }
                              final playDub = _selectedAudio == 'Dub';
                              context.push(
                                '/anime/${widget.animeId}/play/$episodeNum',
                                extra: {
                                  'malId': widget.malId,
                                  'romajiTitle': widget.romajiTitle,
                                  'englishTitle': widget.englishTitle,
                                  'coverImage': widget.coverImage,
                                  'bannerImage': widget.bannerImage,
                                  'totalEpisodes': actualTotal,
                                  'dub': playDub,
                                },
                              );
                            },
                            child: Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    '$episodeNum',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  if (isCompleted && !isCurrent)
                                    const Positioned(
                                      top: 4,
                                      right: 4,
                                      child: CircleAvatar(
                                        radius: 3,
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                  if (newEpisodes.contains(episodeNum))
                                    Positioned(
                                      top: 4,
                                      left: 4,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.error,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'NEW',
                                          style: theme.textTheme.labelSmall?.copyWith(
                                            color: theme.colorScheme.onError,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 7,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        );
      },
    );
  }
}
