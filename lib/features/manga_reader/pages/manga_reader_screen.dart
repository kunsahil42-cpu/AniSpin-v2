// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/network/mangadex/mangadex_api.dart';
import '../../manga_details/providers/manga_details_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../../settings/models/app_settings.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../../tracker/models/reading_progress.dart';
import '../widgets/navigation_controls.dart';
import '../widgets/reader_image.dart';
import '../widgets/zoomable_widget.dart';

class MangaReaderScreen extends ConsumerStatefulWidget {
  final int mangaId;
  final int chapterNumber;
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int totalChapters;

  const MangaReaderScreen({
    super.key,
    required this.mangaId,
    required this.chapterNumber,
    required this.romajiTitle,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.totalChapters,
  });

  @override
  ConsumerState<MangaReaderScreen> createState() => _MangaReaderScreenState();
}

class _MangaReaderScreenState extends ConsumerState<MangaReaderScreen> {
  bool _showAppBar = true;
  PageController? _pageController;
  late final ScrollController _scrollController;
  bool _isLoading = true;
  String? _errorMessage;
  List<String> _pages = [];
  String? _externalUrl;

  int _currentHorizontalPage = 0;
  int _currentVerticalPage = 0;
  final List<GlobalKey> _pageKeys = [];

  int get _currentPage {
    final settings = ref.read(settingsNotifierProvider);
    return settings.readingDirection == ReadingDirectionOption.horizontal
        ? _currentHorizontalPage
        : _currentVerticalPage;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadChapter();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_pages.isEmpty || !mounted) return;

    int activeIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < _pageKeys.length; i++) {
      final key = _pageKeys[i];
      final context = key.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null && box.attached) {
          final position = box.localToGlobal(Offset.zero);
          final distance = position.dy.abs();
          if (distance < minDistance) {
            minDistance = distance;
            activeIndex = i;
          }
        }
      }
    }

    if (activeIndex != _currentVerticalPage) {
      setState(() {
        _currentVerticalPage = activeIndex;
      });
      _preloadPages(activeIndex);
      _updateReadingProgress(activeIndex);
    }
  }

  void _scrollToVerticalPage(int pageIndex) {
    if (pageIndex <= 0 || pageIndex >= _pageKeys.length) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        final context = _pageKeys[pageIndex].currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          if (_scrollController.hasClients) {
            final screenWidth = MediaQuery.of(this.context).size.width;
            final pageHeight = screenWidth * 1.5;
            _scrollController.jumpTo(pageIndex * pageHeight);
          }
        }
      });
    });
  }

  Future<void> _loadChapter() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _externalUrl = null;
      _pages = [];
      _pageKeys.clear();
    });

    try {
      final chapters = await ref.read(mangaChaptersProvider(widget.mangaId).future);
      final chapter = chapters.firstWhere(
        (c) => c.number == widget.chapterNumber,
        orElse: () => throw Exception('Chapter ${widget.chapterNumber} not found'),
      );

      final mangaDex = ref.read(mangaDexApiProvider);
      final candidates = [chapter, ...chapter.alternatives];
      final settings = ref.read(settingsNotifierProvider);
      final useDataSaver = settings.imageQuality != ImageQualityOption.high;
      
      bool loaded = false;
      List<String> pages = [];
      String? fallbackExternalUrl;

      for (final candidate in candidates) {
        if (candidate.isExternal) {
          if (candidate.externalUrl != null && candidate.externalUrl!.isNotEmpty) {
            fallbackExternalUrl ??= candidate.externalUrl;
          }
          continue;
        }

        final chapterId = candidate.id;
        if (chapterId == null) continue;

        try {
          final fetchedPages = await mangaDex.getChapterPages(chapterId, useDataSaver: useDataSaver);
          if (fetchedPages.isNotEmpty) {
            pages = fetchedPages;
            loaded = true;
            break;
          }
        } catch (e) {
          print('MangaReaderScreen: Failed to load pages for candidate: ${candidate.scanGroup} (${candidate.language}): $e');
        }
      }

      if (!loaded) {
        if (fallbackExternalUrl != null) {
          if (mounted) {
            setState(() {
              _externalUrl = fallbackExternalUrl;
              _isLoading = false;
            });
          }
          return;
        }
        throw Exception('No pages available from any supported source.');
      }

      if (mounted) {
        setState(() {
          _pages = pages;
          _pageKeys.addAll(List.generate(pages.length, (_) => GlobalKey()));
          _isLoading = false;
        });

        int initialPage = 0;
        final settings = ref.read(settingsNotifierProvider);
        if (settings.rememberLastPage) {
          final progress = await ref.read(readingProgressRepositoryProvider).getProgress(widget.mangaId);
          if (progress != null && progress.lastReadChapter == widget.chapterNumber) {
            initialPage = (progress.lastReadPage - 1).clamp(0, pages.length - 1);
          }
        }

        if (settings.readingDirection == ReadingDirectionOption.horizontal) {
          _currentHorizontalPage = initialPage;
          _pageController = PageController(initialPage: initialPage);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _preloadPages(initialPage);
            _updateReadingProgress(initialPage);
          });
        } else {
          _currentVerticalPage = initialPage;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _preloadPages(initialPage);
            _updateReadingProgress(initialPage);
            _scrollToVerticalPage(initialPage);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _preloadPages(int currentIndex) {
    if (_pages.isEmpty || !mounted) return;

    final indicesToPreload = [
      currentIndex,
      currentIndex + 1,
      currentIndex + 2,
      currentIndex - 1,
    ];

    for (final index in indicesToPreload) {
      if (index >= 0 && index < _pages.length) {
        final url = _pages[index];
        if (ReaderImage.isLocal(url)) {
          precacheImage(FileImage(File(url)), context).catchError((_) {});
        } else {
          precacheImage(CachedNetworkImageProvider(url), context).catchError((_) {});
        }
      }
    }
  }

  Future<void> _updateReadingProgress(int pageIndex) async {
    if (_pages.isEmpty || !mounted) return;

    try {
      final repo = ref.read(readingProgressRepositoryProvider);
      var progress = await repo.getProgress(widget.mangaId);

      if (progress == null) {
        progress = ReadingProgress()
          ..mangaId = widget.mangaId
          ..romajiTitle = widget.romajiTitle
          ..englishTitle = widget.englishTitle
          ..coverImage = widget.coverImage
          ..bannerImage = widget.bannerImage
          ..totalChapters = widget.totalChapters
          ..lastReadChapter = widget.chapterNumber
          ..lastReadPage = pageIndex + 1
          ..readingPercentage = (pageIndex + 1) / _pages.length
          ..lastReadAt = DateTime.now()
          ..completedChapters = [];
      } else {
        progress
          ..lastReadChapter = widget.chapterNumber
          ..lastReadPage = pageIndex + 1
          ..readingPercentage = (pageIndex + 1) / _pages.length
          ..lastReadAt = DateTime.now();
      }

      if (pageIndex == _pages.length - 1) {
        if (!progress.completedChapters.contains(widget.chapterNumber)) {
          progress.completedChapters.add(widget.chapterNumber);
        }
      }

      await repo.saveProgress(progress);

      ref.invalidate(mangaProgressProvider(widget.mangaId));
      ref.invalidate(continueReadingProvider);
    } catch (e) {
      print('MangaReaderScreen: Error saving reading progress: $e');
    }
  }

  void _showSettingsBottomSheet() {
    final theme = Theme.of(context);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[950],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final currentSettings = ref.watch(settingsNotifierProvider);
            final currentDir = currentSettings.readingDirection;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Reader Settings',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Reading Mode',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  RadioListTile<ReadingDirectionOption>(
                    title: const Text('Horizontal (Swipe)', style: TextStyle(color: Colors.white)),
                    value: ReadingDirectionOption.horizontal,
                    groupValue: currentDir,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (val) {
                      if (val != null) {
                        final oldPage = _currentPage;
                        notifier.setReadingDirection(val);
                        if (val == ReadingDirectionOption.horizontal) {
                          _currentHorizontalPage = oldPage;
                          _pageController = PageController(initialPage: oldPage);
                          _preloadPages(oldPage);
                        } else {
                          _currentVerticalPage = oldPage;
                          _scrollToVerticalPage(oldPage);
                          _preloadPages(oldPage);
                        }
                        Navigator.pop(context);
                      }
                    },
                  ),
                  RadioListTile<ReadingDirectionOption>(
                    title: const Text('Vertical (Continuous)', style: TextStyle(color: Colors.white)),
                    value: ReadingDirectionOption.vertical,
                    groupValue: currentDir,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (val) {
                      if (val != null) {
                        final oldPage = _currentPage;
                        notifier.setReadingDirection(val);
                        if (val == ReadingDirectionOption.horizontal) {
                          _currentHorizontalPage = oldPage;
                          _pageController = PageController(initialPage: oldPage);
                          _preloadPages(oldPage);
                        } else {
                          _currentVerticalPage = oldPage;
                          _scrollToVerticalPage(oldPage);
                          _preloadPages(oldPage);
                        }
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = ref.watch(settingsNotifierProvider);
    final isHorizontal = settings.readingDirection == ReadingDirectionOption.horizontal;
    final doubleTapZoomEnabled = settings.doubleTapZoom;
    final screenWidth = MediaQuery.of(context).size.width;
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final cacheWidth = (screenWidth * devicePixelRatio).toInt();

    // Make sure we have a controller initialized if in horizontal mode
    if (isHorizontal && _pageController == null) {
      _pageController = PageController(initialPage: _currentHorizontalPage);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_externalUrl != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.open_in_new_rounded,
                        color: Colors.purpleAccent,
                        size: 64,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'External Chapter',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'This chapter is hosted on an external official source and cannot be rendered page-by-page inside the app.',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _externalUrl!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Link copied to clipboard! Paste it in your browser to read.'),
                              duration: Duration(seconds: 4),
                            ),
                          );
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('Copy Link to Read'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent.withAlpha(50),
                          foregroundColor: Colors.purpleAccent,
                          side: const BorderSide(color: Colors.purpleAccent, width: 1),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_errorMessage',
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadChapter,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_pages.isEmpty)
              const Center(
                child: Text(
                  'No pages available in this chapter.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showAppBar = !_showAppBar;
                  });
                },
                child: isHorizontal
                    ? PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentHorizontalPage = index;
                            _showAppBar = index > 0;
                          });
                          _preloadPages(index);
                          _updateReadingProgress(index);
                        },
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          final pageUrl = _pages[index];

                          return ZoomableWidget(
                            doubleTapZoomEnabled: doubleTapZoomEnabled,
                            child: Center(
                              child: ReaderImage(
                                source: pageUrl,
                                memCacheWidth: cacheWidth,
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        cacheExtent: 3000,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          final pageUrl = _pages[index];

                          return ZoomableWidget(
                            doubleTapZoomEnabled: doubleTapZoomEnabled,
                            child: Container(
                              key: _pageKeys[index],
                              child: ReaderImage(
                                source: pageUrl,
                                memCacheWidth: cacheWidth,
                              ),
                            ),
                          );
                        },
                      ),
              ),

            // App bar
            AnimatedOpacity(
              opacity: _showAppBar ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.romajiTitle,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.englishTitle != null &&
                                widget.englishTitle!.isNotEmpty)
                              Text(
                                widget.englishTitle!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              'Chapter ${widget.chapterNumber}/${widget.totalChapters}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onPressed: _showSettingsBottomSheet,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Controls overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: !_showAppBar,
                child: AnimatedOpacity(
                  opacity: _showAppBar ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_pages.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Text(
                              'Page ${_currentPage + 1}/${_pages.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),

                        NavigationControls(
                          currentChapter: widget.chapterNumber,
                          totalChapters: widget.totalChapters,
                          onPrevious: () {
                            if (widget.chapterNumber > 1) {
                              context.pushReplacement(
                                '/manga/${widget.mangaId}/read/${widget.chapterNumber - 1}',
                                extra: {
                                  'romajiTitle': widget.romajiTitle,
                                  'englishTitle': widget.englishTitle,
                                  'coverImage': widget.coverImage,
                                  'bannerImage': widget.bannerImage,
                                  'totalChapters': widget.totalChapters,
                                },
                              );
                            }
                          },
                          onNext: () {
                            if (widget.chapterNumber < widget.totalChapters) {
                              context.pushReplacement(
                                '/manga/${widget.mangaId}/read/${widget.chapterNumber + 1}',
                                extra: {
                                  'romajiTitle': widget.romajiTitle,
                                  'englishTitle': widget.englishTitle,
                                  'coverImage': widget.coverImage,
                                  'bannerImage': widget.bannerImage,
                                  'totalChapters': widget.totalChapters,
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}