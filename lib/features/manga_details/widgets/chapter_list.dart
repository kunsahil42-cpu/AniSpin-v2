import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../models/chapter_model.dart';
import '../providers/manga_details_provider.dart';

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
  String? _selectedLanguage;
  String _selectedType = 'All';
  String _selectedSort = 'Chapter';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressAsync = ref.watch(mangaProgressProvider(widget.mangaId));
    final chaptersAsync = ref.watch(mangaChaptersProvider(widget.mangaId));
    final newChapters = ref.watch(newChaptersProvider(widget.mangaId));

    return chaptersAsync.when(
      loading: () => const _SkeletonChapters(),
      error: (err, stack) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Failed to load chapters. Please try again.',
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ),
      data: (chapters) {
        if (chapters.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No chapters available.',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          );
        }

        // Dynamically get available languages
        final languages = chapters.map((c) => c.language).toSet().toList();
        languages.sort((a, b) {
          if (a.toUpperCase() == 'EN') return -1;
          if (b.toUpperCase() == 'EN') return 1;
          return a.compareTo(b);
        });

        if (_selectedLanguage == null && languages.isNotEmpty) {
          _selectedLanguage = languages.first;
        }

        // Filter by language
        var filtered = chapters.where((c) => c.language == _selectedLanguage).toList();

        // Filter by Type
        if (_selectedType == 'Official') {
          filtered = filtered.where((c) => c.scanGroup == 'Official').toList();
        } else if (_selectedType == 'Unofficial') {
          filtered = filtered.where((c) => c.scanGroup == 'Unofficial').toList();
        }

        // Filter by Search Query
        if (_searchQuery.trim().isNotEmpty) {
          final query = _searchQuery.toLowerCase().trim();
          filtered = filtered.where((c) {
            final numMatch = c.number.toLowerCase().contains(query);
            final titleMatch = c.title.toLowerCase().contains(query);
            return numMatch || titleMatch;
          }).toList();
        }

        // Sort
        if (_selectedSort == 'Chapter') {
          filtered.sort((a, b) {
            final numA = double.tryParse(a.number) ?? 0.0;
            final numB = double.tryParse(b.number) ?? 0.0;
            return numB.compareTo(numA); // Newest / largest chapter first
          });
        } else if (_selectedSort == 'Date') {
          filtered.sort((a, b) {
            final timeA = a.createdAt ?? 0;
            final timeB = b.createdAt ?? 0;
            return timeB.compareTo(timeA); // Newest upload date first
          });
        }

        final maxChNum = chapters.isNotEmpty
            ? chapters.map((c) => double.tryParse(c.number) ?? 0.0).reduce((a, b) => a > b ? a : b).toInt()
            : 0;
        final actualTotalChapters = widget.totalChapters > maxChNum
            ? widget.totalChapters
            : maxChNum;

        const languageNames = {
          'EN': 'English',
          'JA': 'Japanese',
          'ES': 'Spanish',
          'ID': 'Indonesian',
          'RU': 'Russian',
          'PT': 'Portuguese',
          'FR': 'French',
          'KO': 'Korean',
          'ZH': 'Chinese',
          'DE': 'German',
          'IT': 'Italian',
          'AR': 'Arabic',
          'HI': 'Hindi',
        };

        const languageFlags = {
          'EN': '🇬🇧',
          'JA': '🇯🇵',
          'ES': '🇪🇸',
          'ID': '🇮🇩',
          'RU': '🇷🇺',
          'PT': '🇵🇹',
          'FR': '🇫🇷',
          'KO': '🇰🇷',
          'ZH': '🇨🇳',
          'DE': '🇩🇪',
          'IT': '🇮🇹',
          'AR': '🇸🇦',
          'HI': '🇮🇳',
        };

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
                // 1. Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search chapter number...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                      filled: true,
                    ),
                  ),
                ),

                // 2. Dropdowns (LANG & TYPE)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // LANG Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LANG',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedLanguage,
                                  isExpanded: true,
                                  dropdownColor: Colors.grey[950],
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  onChanged: (lang) {
                                    setState(() {
                                      _selectedLanguage = lang;
                                    });
                                  },
                                  items: languages.map((lang) {
                                    final flag = languageFlags[lang.toUpperCase()] ?? '🌐';
                                    final name = languageNames[lang.toUpperCase()] ?? lang;
                                    return DropdownMenuItem<String>(
                                      value: lang,
                                      child: Text(
                                        '$flag  $name',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      // TYPE Dropdown
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TYPE',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedType,
                                  isExpanded: true,
                                  dropdownColor: Colors.grey[950],
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  onChanged: (type) {
                                    setState(() {
                                      _selectedType = type!;
                                    });
                                  },
                                  items: ['All', 'Official', 'Unofficial'].map((type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(
                                        type,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 3. SORT options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        'SORT:',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Chapter Sort Button
                      _SortButton(
                        label: 'Chapter ↓',
                        selected: _selectedSort == 'Chapter',
                        onTap: () {
                          setState(() {
                            _selectedSort = 'Chapter';
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      // Date Sort Button
                      _SortButton(
                        label: 'Date',
                        selected: _selectedSort == 'Date',
                        onTap: () {
                          setState(() {
                            _selectedSort = 'Date';
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const Divider(height: 24, thickness: 1),

                // 4. Flat chapters list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      if (filtered.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              'No chapters found matching current filters.',
                              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                        )
                      else
                        for (final chapter in filtered)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _ChapterRow(
                              chapter: chapter,
                              isCurrent: (double.tryParse(chapter.number)?.toInt() ?? 0) == currentChapter,
                              isRead: completed.contains(double.tryParse(chapter.number)?.toInt() ?? 0),
                              isNew: newChapters.contains(chapter.number),
                              onTap: () => _openChapter(chapter, actualTotalChapters),
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

  void _openChapter(ChapterModel chapter, int total) {
    context.push(
      '/manga/${widget.mangaId}/read/${chapter.number}',
      extra: {
        'romajiTitle': widget.romajiTitle,
        'englishTitle': widget.englishTitle,
        'coverImage': widget.coverImage,
        'bannerImage': widget.bannerImage,
        'totalChapters': total,
        'chapterId': chapter.id,
      },
    );
  }
}

class _SortButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SortButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? Colors.transparent : theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  final ChapterModel chapter;
  final bool isCurrent;
  final bool isRead;
  final bool isNew;
  final VoidCallback onTap;

  const _ChapterRow({
    required this.chapter,
    required this.isCurrent,
    required this.isRead,
    required this.isNew,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    const languageFlags = {
      'EN': '🇬🇧',
      'JA': '🇯🇵',
      'ES': '🇪🇸',
      'ID': '🇮🇩',
      'RU': '🇷🇺',
      'PT': '🇵🇹',
      'FR': '🇫🇷',
      'KO': '🇰🇷',
      'ZH': '🇨🇳',
      'DE': '🇩🇪',
      'IT': '🇮🇹',
      'AR': '🇸🇦',
      'HI': '🇮🇳',
    };
    final flag = languageFlags[chapter.language.toUpperCase()] ?? '🌐';

    final isOfficial = chapter.scanGroup == 'Official';

    final rowWidget = Card(
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              // Flag emoji
              Text(
                flag,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 14),

              // Chapter info
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Ch. ${chapter.number}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? primaryColor : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isOfficial) ...[
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF4CAF50),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                    ],
                    if (chapter.title.isNotEmpty && chapter.title != 'Chapter ${chapter.number}') ...[
                      Text(
                        '•',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          chapter.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Date
              Text(
                chapter.date,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),

              const SizedBox(width: 12),

              // Bookmark icon/status
              Icon(
                isRead ? Icons.bookmark_added_rounded : Icons.bookmark_border_rounded,
                size: 18,
                color: isRead ? primaryColor : theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );

    if (isRead) {
      return Opacity(
        opacity: 0.6,
        child: rowWidget,
      );
    }
    return rowWidget;
  }
}

class _SkeletonChapters extends StatelessWidget {
  const _SkeletonChapters();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = isDark ? Colors.grey[900]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              height: 24,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: List.generate(4, (index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
