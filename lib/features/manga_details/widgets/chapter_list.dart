import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../models/chapter_model.dart';
import '../providers/manga_details_provider.dart';

/// Number of chapters per collapsible range (1–50, 51–100, …).
const int _kGroupSize = 50;

class ChapterList extends ConsumerStatefulWidget {
  final int mangaId;
  final int totalChapters;
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;

  const ChapterList({
    super.key,
    required this.mangaId,
    required this.totalChapters,
    required this.romajiTitle,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
  });

  @override
  ConsumerState<ChapterList> createState() => _ChapterListState();
}

class _ChapterListState extends ConsumerState<ChapterList> {
  bool _ascending = false; // Default: show newest first

  // Accordion state: the block index (0 => 1–50, 1 => 51–100, …) that is
  // currently expanded. Only one group is open at a time so we never build
  // more than a single range of rows, no matter how many chapters exist.
  int? _expandedBlock;
  bool _userInteracted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressAsync = ref.watch(mangaProgressProvider(widget.mangaId));
    final chaptersAsync = ref.watch(mangaChaptersProvider(widget.mangaId));

    return chaptersAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Failed to load chapters. Please try again.',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ),
      data: (chapters) {
        if (chapters.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No chapters available.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        // Build groups of 50 from a numerically-sorted copy so ranges are
        // always correct (never lexicographic: 2 before 10, 49 before 50…).
        final groups = _buildGroups(chapters, ascending: _ascending);

        // The effective open group: before the user touches anything, the
        // first visible group is expanded. After that, honour their choice.
        final effectiveExpanded =
            _userInteracted ? _expandedBlock : groups.first.block;

        return progressAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (progress) {
            final currentChapter = progress?.lastReadChapter ?? 1;
            final completed = progress?.completedChapters ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '📚 Chapters',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${chapters.length} Chapters',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: _ascending
                                ? 'Sorted oldest first'
                                : 'Sorted newest first',
                            icon: Icon(
                              _ascending
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _ascending = !_ascending;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    children: [
                      for (final group in groups)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _ChapterGroupTile(
                            group: group,
                            expanded: group.block == effectiveExpanded,
                            ascending: _ascending,
                            currentChapter: currentChapter,
                            completed: completed,
                            onToggle: () => _toggle(group.block),
                            onOpenChapter: _openChapter,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _toggle(int block) {
    setState(() {
      // Resolve the currently-open block first so the very first tap behaves
      // consistently with the "first group open by default" rule.
      final current = _userInteracted ? _expandedBlock : block;
      _userInteracted = true;
      _expandedBlock = current == block ? null : block;
    });
  }

  void _openChapter(ChapterModel chapter) {
    context.push(
      '/manga/${widget.mangaId}/read/${chapter.number}',
      extra: {
        'romajiTitle': widget.romajiTitle,
        'englishTitle': widget.englishTitle,
        'coverImage': widget.coverImage,
        'bannerImage': widget.bannerImage,
        'totalChapters': widget.totalChapters,
      },
    );
  }

  /// Groups chapters into blocks of [_kGroupSize], ordered for display.
  ///
  /// Grouping is driven purely by chapter number, so a chapter's block is
  /// stable regardless of the sort direction; only the order in which groups
  /// and their rows are presented flips with [ascending].
  static List<_ChapterGroup> _buildGroups(
    List<ChapterModel> chapters, {
    required bool ascending,
  }) {
    final byBlock = <int, List<ChapterModel>>{};
    for (final c in chapters) {
      // (n - 1) ~/ 50 => 1..50 -> block 0, 51..100 -> block 1, …
      final block = ((c.number - 1) ~/ _kGroupSize).clamp(0, 1 << 30);
      (byBlock[block] ??= <ChapterModel>[]).add(c);
    }

    final blocks = byBlock.keys.toList()..sort();
    if (!ascending) {
      final reversed = blocks.reversed.toList();
      blocks
        ..clear()
        ..addAll(reversed);
    }

    return [
      for (final block in blocks)
        _ChapterGroup(
          block: block,
          chapters: _sortWithin(byBlock[block]!, ascending: ascending),
        ),
    ];
  }

  static List<ChapterModel> _sortWithin(
    List<ChapterModel> chapters, {
    required bool ascending,
  }) {
    final sorted = List<ChapterModel>.from(chapters);
    sorted.sort((a, b) =>
        ascending ? a.number.compareTo(b.number) : b.number.compareTo(a.number));
    return sorted;
  }
}

/// A single range of chapters (e.g. 51–100) plus its rows.
class _ChapterGroup {
  final int block;
  final List<ChapterModel> chapters;

  const _ChapterGroup({required this.block, required this.chapters});

  /// Lowest chapter number in the group (labels the start of the range).
  int get start =>
      chapters.map((c) => c.number).reduce((a, b) => a < b ? a : b);

  /// Highest chapter number in the group (labels the end of the range).
  int get end => chapters.map((c) => c.number).reduce((a, b) => a > b ? a : b);

  String get label => start == end ? 'Chapter $start' : 'Chapters $start–$end';
}

/// Aurora-styled expandable range header + lazily-built rows.
///
/// The chapter rows are only created while [expanded] is true, so collapsed
/// groups cost a single header widget each — the list stays smooth even with
/// thousands of chapters.
class _ChapterGroupTile extends StatelessWidget {
  final _ChapterGroup group;
  final bool expanded;
  final bool ascending;
  final int currentChapter;
  final List<int> completed;
  final VoidCallback onToggle;
  final void Function(ChapterModel) onOpenChapter;

  const _ChapterGroupTile({
    required this.group,
    required this.expanded,
    required this.ascending,
    required this.currentChapter,
    required this.completed,
    required this.onToggle,
    required this.onOpenChapter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final containsCurrent =
        currentChapter >= group.start && currentChapter <= group.end;

    return Card(
      elevation: expanded ? 3 : 0,
      color: expanded
          ? theme.colorScheme.primary.withValues(alpha: 0.06)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: expanded
              ? primaryColor.withValues(alpha: 0.6)
              : theme.colorScheme.outline.withValues(alpha: 0.08),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Range header ──────────────────────────────────────────────
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: expanded ? primaryColor : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      group.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: expanded ? primaryColor : null,
                      ),
                    ),
                  ),
                  if (containsCurrent) ...[
                    Icon(Icons.bookmark_rounded,
                        size: 16, color: primaryColor),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    '${group.chapters.length}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Lazily-built rows with a smooth expand/collapse ───────────
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Column(
                      children: [
                        for (final chapter in group.chapters)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: _ChapterRow(
                              chapter: chapter,
                              isCurrent: chapter.number == currentChapter,
                              isRead: completed.contains(chapter.number),
                              onTap: () => onOpenChapter(chapter),
                            ),
                          ),
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  final ChapterModel chapter;
  final bool isCurrent;
  final bool isRead;
  final VoidCallback onTap;

  const _ChapterRow({
    required this.chapter,
    required this.isCurrent,
    required this.isRead,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final String badgeText;
    final Color badgeColor;
    final List<Color> gradientColors;
    final IconData badgeIcon;

    if (chapter.isColored && !chapter.isAutoTranslate) {
      badgeText = 'Colored English';
      badgeColor = const Color(0xFF4CAF50);
      gradientColors = [const Color(0xFF4CAF50), const Color(0xFF2E7D32)];
      badgeIcon = Icons.check_circle_rounded;
    } else if (chapter.isColored && chapter.isAutoTranslate) {
      badgeText = 'Colored (Auto Translated)';
      badgeColor = const Color(0xFF7C4DFF);
      gradientColors = [const Color(0xFF7C4DFF), const Color(0xFF651FFF)];
      badgeIcon = Icons.palette_rounded;
    } else if (!chapter.isColored && !chapter.isAutoTranslate) {
      badgeText = 'Black & White English';
      badgeColor = const Color(0xFF757575);
      gradientColors = [const Color(0xFF757575), const Color(0xFF424242)];
      badgeIcon = Icons.book_rounded;
    } else {
      badgeText = 'Black & White (Auto Translated)';
      badgeColor = const Color(0xFFFF9800);
      gradientColors = [const Color(0xFFFF9800), const Color(0xFFF57C00)];
      badgeIcon = Icons.translate_rounded;
    }

    return Card(
      elevation: isCurrent ? 4 : 0,
      color: isCurrent
          ? theme.colorScheme.primary.withValues(alpha: 0.08)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isCurrent ? primaryColor : theme.colorScheme.outline.withValues(alpha: 0.08),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Read status circle
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent
                      ? primaryColor
                      : isRead
                          ? Colors.grey.withValues(alpha: 0.4)
                          : Colors.green, // Unread is bright green
                ),
              ),
              const SizedBox(width: 14),
              // Chapter Title & Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? primaryColor : null,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: badgeColor.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              badgeIcon,
                              size: 10,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              badgeText,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            chapter.scanGroup,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          chapter.date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Language Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  chapter.language,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
