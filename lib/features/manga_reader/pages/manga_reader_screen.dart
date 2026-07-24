// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/source_fallback/source_fallback_manager.dart';
import '../../manga_details/providers/manga_details_provider.dart';
import '../../manga_details/models/chapter_model.dart';
import '../../settings/providers/settings_provider.dart';
import '../../settings/models/app_settings.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../../tracker/models/reading_progress.dart';
import '../widgets/navigation_controls.dart';
import '../widgets/reader_image.dart';
import '../widgets/zoomable_widget.dart';
import 'package:isar/isar.dart';
import '../../../core/database/isar_service.dart';
import '../models/chapter_reading_state.dart';

class MangaReaderScreen extends ConsumerStatefulWidget {
  final int mangaId;
  final String chapterNumber;
  final String? chapterId;
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int totalChapters;

  const MangaReaderScreen({
    super.key,
    required this.mangaId,
    required this.chapterNumber,
    this.chapterId,
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
  Timer? _progressDebounceTimer;

  String? _resolvedSource;
  String? _resolvedChapterId;
  bool _resolvedIsColored = false;

  String? _currentLanguage;
  ChapterModel? _prevChapter;
  ChapterModel? _nextChapter;

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
    _progressDebounceTimer?.cancel();
    _pageController?.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_pages.isEmpty || !mounted) return;

    int activeIndex = _currentVerticalPage;
    double minDistance = double.infinity;
    bool foundInWindow = false;

    // 1. Check a localized window of +/- 3 pages around _currentVerticalPage first
    final start = (_currentVerticalPage - 3).clamp(0, _pageKeys.length - 1);
    final end = (_currentVerticalPage + 3).clamp(0, _pageKeys.length - 1);

    for (int i = start; i <= end; i++) {
      if (i >= _pageKeys.length) continue;
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
            foundInWindow = true;
          }
        }
      }
    }

    // 2. If not found in the localized window (e.g. after a large jump), check the rest
    if (!foundInWindow || minDistance > MediaQuery.of(context).size.height) {
      for (int i = 0; i < _pageKeys.length; i++) {
        // Skip the window we already checked
        if (i >= start && i <= end) continue;

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
    }

    if (activeIndex != _currentVerticalPage) {
      setState(() {
        _currentVerticalPage = activeIndex;
      });
      _preloadPages(activeIndex);
      _debouncedUpdateReadingProgress(activeIndex);
    }
  }

  void _debouncedUpdateReadingProgress(int pageIndex) {
    _progressDebounceTimer?.cancel();
    _progressDebounceTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        _updateReadingProgress(pageIndex);
      }
    });
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
      final fallbackManager = ref.read(sourceFallbackManagerProvider);
      final settings = ref.read(settingsNotifierProvider);
      final useDataSaver = settings.imageQuality != ImageQualityOption.high;

      // Check for saved per-chapter source decision in Isar
      ChapterReadingState? savedState;
      try {
        if (widget.chapterId != null) {
          savedState = await IsarService.instance.chapterReadingStates
              .filter()
              .mangaIdEqualTo(widget.mangaId)
              .chapterIdEqualTo(widget.chapterId)
              .findFirst();
        }
        if (savedState == null) {
          final targetNum = double.tryParse(widget.chapterNumber)?.toInt() ?? 0;
          savedState = await IsarService.instance.chapterReadingStates
              .filter()
              .mangaIdEqualTo(widget.mangaId)
              .chapterNumberEqualTo(targetNum)
              .findFirst();
        }
      } catch (_) {}

      bool loaded = false;
      List<String> pages = [];
      String? fallbackExternalUrl;

      if (savedState != null && savedState.chapterId != null) {
        _resolvedSource = savedState.selectedSource;
        _resolvedChapterId = savedState.chapterId;
        _resolvedIsColored = savedState.isColored;
        try {
          final fetchedPages = await fallbackManager.getChapterPages(
            chapterId: _resolvedChapterId!,
            source: _resolvedSource!,
            useDataSaver: useDataSaver,
          );
          if (fetchedPages.isNotEmpty) {
            pages = fetchedPages;
            loaded = true;
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('[MangaReaderScreen] Failed to load pages from cached source: $_resolvedSource: $e');
          }
        }
      }

      if (!loaded && widget.chapterId != null) {
        _resolvedSource = 'mangadot';
        _resolvedChapterId = widget.chapterId;
        _resolvedIsColored = false;
        try {
          final fetchedPages = await fallbackManager.getChapterPages(
            chapterId: _resolvedChapterId!,
            source: _resolvedSource!,
            useDataSaver: useDataSaver,
          );
          if (fetchedPages.isNotEmpty) {
            pages = fetchedPages;
            loaded = true;
          }
        } catch (_) {}
      }

      if (!loaded) {
        final chapters = await ref.read(mangaChaptersProvider(widget.mangaId).future);
        final targetNum = double.tryParse(widget.chapterNumber) ?? 0.0;
        final chapter = chapters.firstWhere(
          (c) {
            if (widget.chapterId != null) {
              return c.id == widget.chapterId;
            }
            final cNum = double.tryParse(c.number) ?? 0.0;
            return cNum == targetNum;
          },
          orElse: () => throw Exception('No chapters are currently available for this chapter.'),
        );

        final candidates = [chapter, ...chapter.alternatives];
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
            final fetchedPages = await fallbackManager.getChapterPages(
              chapterId: chapterId,
              source: candidate.source,
              useDataSaver: useDataSaver,
            );
            if (fetchedPages.isNotEmpty) {
              pages = fetchedPages;
              loaded = true;
              _resolvedSource = candidate.source;
              _resolvedChapterId = chapterId;
              _resolvedIsColored = candidate.isColored;
              break;
            }
          } catch (e) {
            if (kDebugMode) {
              debugPrint('[MangaReaderScreen] Failed to load pages for candidate: ${candidate.scanGroup} (${candidate.language}): $e');
            }
          }
        }
      }

      if (!loaded) {
        if (fallbackExternalUrl != null) {
          if (mounted) {
            setState(() {
              _externalUrl = fallbackExternalUrl;
              _isLoading = false;
            });
            _updateReadingProgressForExternal();
            _handleAutoLaunchExternal(fallbackExternalUrl);
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
        if (settings.rememberLastPage) {
          if (savedState != null) {
            initialPage = (savedState.lastReadPage - 1).clamp(0, pages.length - 1);
          } else {
            final progress = await ref.read(readingProgressRepositoryProvider).getProgress(widget.mangaId);
            final targetChInt = double.tryParse(widget.chapterNumber)?.toInt() ?? 0;
            if (progress != null && progress.lastReadChapter == targetChInt) {
              initialPage = (progress.lastReadPage - 1).clamp(0, pages.length - 1);
            }
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

        _resolvePrevNextChapters();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resolvePrevNextChapters() async {
    try {
      final chapters = await ref.read(mangaChaptersProvider(widget.mangaId).future);
      final currentChapter = chapters.firstWhere(
        (c) => c.id == _resolvedChapterId,
        orElse: () {
          final targetNum = double.tryParse(widget.chapterNumber) ?? 0.0;
          return chapters.firstWhere((c) => (double.tryParse(c.number) ?? 0.0) == targetNum);
        },
      );

      _currentLanguage = currentChapter.language;

      // Filter chapters by current language
      final filtered = chapters.where((c) => c.language.toUpperCase() == _currentLanguage?.toUpperCase()).toList();

      // Sort ascending numerically by chapter number
      filtered.sort((a, b) {
        final numA = double.tryParse(a.number) ?? 0.0;
        final numB = double.tryParse(b.number) ?? 0.0;
        return numA.compareTo(numB);
      });

      final curIndex = filtered.indexWhere((c) => c.id == _resolvedChapterId);
      if (mounted) {
        setState(() {
          _prevChapter = (curIndex > 0) ? filtered[curIndex - 1] : null;
          _nextChapter = (curIndex < filtered.length - 1) ? filtered[curIndex + 1] : null;
        });
      }
    } catch (_) {}
  }

  void _preloadPages(int currentIndex) {
    if (_pages.isEmpty || !mounted) return;

    // Preload current page, next 3 pages, and previous 1 page
    final indicesToPreload = [
      currentIndex,
      currentIndex + 1,
      currentIndex + 2,
      currentIndex + 3,
      currentIndex - 1,
    ];

    for (final index in indicesToPreload) {
      if (index >= 0 && index < _pages.length) {
        final url = _pages[index];
        final ImageProvider provider = ReaderImage.isLocal(url)
            ? FileImage(File(url))
            : CachedNetworkImageProvider(url);
        precacheImage(provider, context).catchError((_) {});
      }
    }

    _evictFarPages(currentIndex);
  }

  void _evictFarPages(int currentIndex) {
    if (_pages.isEmpty) return;
    const keepWindow = 6; // Keep 6 pages behind and 6 pages ahead decoded in memory
    for (int i = 0; i < _pages.length; i++) {
      if (i < currentIndex - keepWindow || i > currentIndex + keepWindow) {
        final url = _pages[i];
        final ImageProvider provider = ReaderImage.isLocal(url)
            ? FileImage(File(url))
            : CachedNetworkImageProvider(url);
        provider.evict().catchError((_) => false);
      }
    }
  }

  Future<void> _updateReadingProgressForExternal() async {
    try {
      final repo = ref.read(readingProgressRepositoryProvider);
      var progress = await repo.getProgress(widget.mangaId);
      final chInt = double.tryParse(widget.chapterNumber)?.toInt() ?? 0;

      if (progress == null) {
        progress = ReadingProgress()
          ..mangaId = widget.mangaId
          ..romajiTitle = widget.romajiTitle
          ..englishTitle = widget.englishTitle
          ..coverImage = widget.coverImage
          ..bannerImage = widget.bannerImage
          ..totalChapters = widget.totalChapters
          ..lastReadChapter = chInt
          ..lastReadPage = 1
          ..readingPercentage = widget.totalChapters > 0 ? chInt / widget.totalChapters : 0.0
          ..lastReadAt = DateTime.now()
          ..completedChapters = [chInt];
      } else {
        progress
          ..lastReadChapter = chInt
          ..lastReadPage = 1
          ..readingPercentage = widget.totalChapters > 0 ? chInt / widget.totalChapters : 0.0
          ..lastReadAt = DateTime.now();
        if (!progress.completedChapters.contains(chInt)) {
          progress.completedChapters = List<int>.from(progress.completedChapters)..add(chInt);
        }
      }

      await repo.saveProgress(progress);

      ref.invalidate(mangaProgressProvider(widget.mangaId));
      ref.invalidate(continueReadingProvider);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[MangaReaderScreen] Error saving external reading progress: $e');
      }
    }
  }

  void _handleAutoLaunchExternal(String url) {
    final settings = ref.read(settingsNotifierProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      switch (settings.externalChapterOption) {
        case ExternalChapterOption.openInBrowser:
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          break;
        case ExternalChapterOption.openInChromeCustomTabs:
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
          }
          break;
        case ExternalChapterOption.copyLinkOnly:
          await Clipboard.setData(ClipboardData(text: url));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Link copied to clipboard!')),
            );
          }
          break;
        case ExternalChapterOption.alwaysAsk:
          break;
      }
    });
  }

  Future<void> _updateReadingProgress(int pageIndex) async {
    if (_pages.isEmpty || !mounted) return;

    try {
      final repo = ref.read(readingProgressRepositoryProvider);
      var progress = await repo.getProgress(widget.mangaId);
      final chInt = double.tryParse(widget.chapterNumber)?.toInt() ?? 0;

      if (progress == null) {
        progress = ReadingProgress()
          ..mangaId = widget.mangaId
          ..romajiTitle = widget.romajiTitle
          ..englishTitle = widget.englishTitle
          ..coverImage = widget.coverImage
          ..bannerImage = widget.bannerImage
          ..totalChapters = widget.totalChapters
          ..lastReadChapter = chInt
          ..lastReadPage = pageIndex + 1
          ..readingPercentage = _pages.isNotEmpty ? (pageIndex + 1) / _pages.length : 0.0
          ..lastReadAt = DateTime.now()
          ..completedChapters = [];
      } else {
        progress
          ..lastReadChapter = chInt
          ..lastReadPage = pageIndex + 1
          ..readingPercentage = _pages.isNotEmpty ? (pageIndex + 1) / _pages.length : 0.0
          ..lastReadAt = DateTime.now();
      }

      if (pageIndex == _pages.length - 1) {
        if (!progress.completedChapters.contains(chInt)) {
          progress.completedChapters = List<int>.from(progress.completedChapters)..add(chInt);
        }
      }

      await repo.saveProgress(progress);

      // Save/update chapter level reading progress with selected source decision
      try {
        final isar = IsarService.instance;
        ChapterReadingState? existingState;
        if (_resolvedChapterId != null) {
          existingState = await isar.chapterReadingStates
              .filter()
              .mangaIdEqualTo(widget.mangaId)
              .chapterIdEqualTo(_resolvedChapterId)
              .findFirst();
        }
        if (existingState == null) {
          existingState = await isar.chapterReadingStates
              .filter()
              .mangaIdEqualTo(widget.mangaId)
              .chapterNumberEqualTo(chInt)
              .findFirst();
        }

        final newState = (existingState ?? ChapterReadingState())
          ..mangaId = widget.mangaId
          ..chapterNumber = chInt
          ..chapterId = _resolvedChapterId
          ..selectedSource = _resolvedSource ?? 'mangadot'
          ..isColored = _resolvedIsColored
          ..lastReadPage = pageIndex + 1;

        await isar.writeTxn(() async {
          await isar.chapterReadingStates.put(newState);
        });
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[MangaReaderScreen] Failed to save chapter reading state: $e');
        }
      }

      ref.invalidate(mangaProgressProvider(widget.mangaId));
      ref.invalidate(continueReadingProvider);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[MangaReaderScreen] Error saving reading progress: $e');
      }
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
                        'This chapter is hosted on an official external source and cannot be rendered inside AniSpin.',
                        style: TextStyle(color: Colors.white70, fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      SizedBox(
                        width: 250,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(_externalUrl!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(Icons.open_in_browser_rounded),
                          label: const Text('Open in Browser'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        width: 250,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(_externalUrl!);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                            }
                          },
                          icon: const Icon(Icons.chrome_reader_mode_rounded),
                          label: const Text('Open in Custom Chrome Tabs'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        width: 250,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await Clipboard.setData(ClipboardData(text: _externalUrl!));
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Link copied to clipboard!')),
                              );
                            }
                          },
                          icon: const Icon(Icons.copy_rounded, color: Colors.purpleAccent),
                          label: const Text('Copy Link', style: TextStyle(color: Colors.purpleAccent)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.purpleAccent, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      TextButton(
                        onPressed: () {
                          context.pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
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
                          _debouncedUpdateReadingProgress(index);
                        },
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          final pageUrl = _pages[index];
                          return MangaPageItem(
                            key: ValueKey(pageUrl),
                            pageUrl: pageUrl,
                            doubleTapZoomEnabled: doubleTapZoomEnabled,
                            cacheWidth: cacheWidth,
                            centerChild: true,
                          );
                        },
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        cacheExtent: 1500,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          final pageUrl = _pages[index];
                          return MangaPageItem(
                            key: ValueKey(pageUrl),
                            pageUrl: pageUrl,
                            doubleTapZoomEnabled: doubleTapZoomEnabled,
                            cacheWidth: cacheWidth,
                            pageKey: _pageKeys[index],
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
                              'Chapter ${widget.chapterNumber} of ${widget.totalChapters}',
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
                          hasPrevious: _prevChapter != null,
                          hasNext: _nextChapter != null,
                          onPrevious: () {
                            if (_prevChapter != null) {
                              context.pushReplacement(
                                '/manga/${widget.mangaId}/read/${_prevChapter!.number}',
                                extra: {
                                  'romajiTitle': widget.romajiTitle,
                                  'englishTitle': widget.englishTitle,
                                  'coverImage': widget.coverImage,
                                  'bannerImage': widget.bannerImage,
                                  'totalChapters': widget.totalChapters,
                                  'chapterId': _prevChapter!.id,
                                },
                              );
                            }
                          },
                          onNext: () {
                            if (_nextChapter != null) {
                              context.pushReplacement(
                                '/manga/${widget.mangaId}/read/${_nextChapter!.number}',
                                extra: {
                                  'romajiTitle': widget.romajiTitle,
                                  'englishTitle': widget.englishTitle,
                                  'coverImage': widget.coverImage,
                                  'bannerImage': widget.bannerImage,
                                  'totalChapters': widget.totalChapters,
                                  'chapterId': _nextChapter!.id,
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

/// Optimized representation of a single manga page to enable lazy rendering
/// and skip rebuilding when parent offsets or states change.
class MangaPageItem extends StatelessWidget {
  final String pageUrl;
  final bool doubleTapZoomEnabled;
  final int cacheWidth;
  final Key? pageKey;
  final bool centerChild;

  const MangaPageItem({
    super.key,
    required this.pageUrl,
    required this.doubleTapZoomEnabled,
    required this.cacheWidth,
    this.pageKey,
    this.centerChild = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = Container(
      key: pageKey,
      child: ReaderImage(
        source: pageUrl,
        memCacheWidth: cacheWidth,
      ),
    );

    return ZoomableWidget(
      doubleTapZoomEnabled: doubleTapZoomEnabled,
      child: centerChild ? Center(child: imageWidget) : imageWidget,
    );
  }
}