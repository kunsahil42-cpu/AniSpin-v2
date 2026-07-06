import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../tracker/models/reading_progress.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../../manga_details/providers/manga_details_provider.dart';
import '../../manga_details/models/chapter_model.dart';
import '../providers/ocr_translation_provider.dart';
import '../../../core/database/translation_cache.dart';

class MangaReaderScreen extends ConsumerStatefulWidget {
  final int mangaId;
  final int chapterNumber;
  
  // Passed details via GoRouter extra
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
  late PageController _pageController;
  late ScrollController _scrollController;
  
  bool _isHorizontal = true; // Layout toggle
  bool _showOverlays = true;
  int _currentPage = 1;

  // Zoom parameters
  final Map<int, TransformationController> _transformationControllers = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scrollController = ScrollController();
    
    // Configure immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _onPageChanged(int index, List<String> pages) {
    setState(() {
      _currentPage = index + 1;
    });
    
    // Save progress
    _saveReadingProgress(pages.length);

    // Preload next page
    if (index + 1 < pages.length) {
      precacheImage(
        CachedNetworkImageProvider(pages[index + 1]),
        context,
      );
    }
  }

  void _saveReadingProgress(int totalPages) {
    final repo = ref.read(readingProgressRepositoryProvider);
    final percentage = _currentPage / totalPages;

    repo.getProgress(widget.mangaId).then((existing) {
      final progress = existing ?? ReadingProgress()
        ..mangaId = widget.mangaId
        ..romajiTitle = widget.romajiTitle
        ..englishTitle = widget.englishTitle
        ..coverImage = widget.coverImage
        ..bannerImage = widget.bannerImage
        ..totalChapters = widget.totalChapters;
        
      progress
        ..lastReadChapter = widget.chapterNumber
        ..lastReadPage = _currentPage
        ..readingPercentage = percentage
        ..lastReadAt = DateTime.now();

      if (progress.status == null) {
        progress.status = 'Reading';
      }

      // Mark as completed if read last page
      if (_currentPage == totalPages) {
        final completed = List<int>.from(progress.completedChapters);
        if (!completed.contains(widget.chapterNumber)) {
          completed.add(widget.chapterNumber);
          progress.completedChapters = completed;
        }
        if (widget.totalChapters > 0 && progress.completedChapters.length >= widget.totalChapters) {
          progress.status = 'Completed';
        }
      }

      repo.saveProgress(progress).then((_) {
        ref.invalidate(mangaProgressProvider(widget.mangaId));
        ref.invalidate(continueReadingProvider);
      });
    });
  }

  void _toggleOverlays() {
    setState(() {
      _showOverlays = !_showOverlays;
    });
  }

  void _doubleTapZoom(int pageIndex) {
    final controller = _transformationControllers.putIfAbsent(
      pageIndex,
      () => TransformationController(),
    );

    if (controller.value != Matrix4.identity()) {
      controller.value = Matrix4.identity();
    } else {
      // Zoom in 2.5x centered
      controller.value = Matrix4.identity()
        ..setEntry(0, 3, -150.0)
        ..setEntry(1, 3, -200.0)
        ..setEntry(0, 0, 2.5)
        ..setEntry(1, 1, 2.5);
    }
    setState(() {});
  }

  void _navigateToChapter(int targetChapter) {
    if (targetChapter < 1 || targetChapter > widget.totalChapters) return;

    context.pushReplacement(
      '/manga/${widget.mangaId}/read/$targetChapter',
      extra: {
        'romajiTitle': widget.romajiTitle,
        'englishTitle': widget.englishTitle,
        'coverImage': widget.coverImage,
        'bannerImage': widget.bannerImage,
        'totalChapters': widget.totalChapters,
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    for (var c in _transformationControllers.values) {
      c.dispose();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pagesAsync = ref.watch(mangaChapterPagesProvider(ChapterPagesArg(
      mangaId: widget.mangaId,
      chapterNumber: widget.chapterNumber,
    )));

    // Track initial load side-effect
    pagesAsync.whenData((pages) {
      if (pages.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _saveReadingProgress(pages.length);
          }
        });
      }
    });

    final chaptersAsync = ref.watch(mangaChaptersProvider(widget.mangaId));
    final chapters = chaptersAsync.valueOrNull ?? [];
    ChapterModel? chapter;
    for (final c in chapters) {
      if (c.number == widget.chapterNumber) {
        chapter = c;
        break;
      }
    }

    final isAutoTranslate = chapter?.isAutoTranslate ?? false;
    final pipelineId = chapter?.id ?? '${widget.mangaId}_${widget.chapterNumber}';

    if (isAutoTranslate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(ocrTranslationPipelineProvider(pipelineId).notifier).startPipeline();
      });
    }

    final pipelineState = isAutoTranslate
        ? ref.watch(ocrTranslationPipelineProvider(pipelineId))
        : null;

    if (isAutoTranslate) {
      ref.listen<OcrTranslationState>(
        ocrTranslationPipelineProvider(pipelineId),
        (previous, next) {
          if (next.status == OcrTranslationStatus.completed) {
            pagesAsync.whenData((pages) {
              TranslationCache().put(pipelineId, pages);
            });
          }
        },
      );
    }

    final isColored = chapter?.isColored ?? false;
    final String badgeText;
    final Color badgeColor;
    final IconData badgeIcon;

    if (isColored && !isAutoTranslate) {
      badgeText = 'Colored English';
      badgeColor = const Color(0xFF4CAF50);
      badgeIcon = Icons.check_circle_rounded;
    } else if (isColored && isAutoTranslate) {
      badgeText = 'Colored (Auto Translated)';
      badgeColor = const Color(0xFF7C4DFF);
      badgeIcon = Icons.palette_rounded;
    } else if (!isColored && !isAutoTranslate) {
      badgeText = 'Black & White English';
      badgeColor = const Color(0xFF757575);
      badgeIcon = Icons.book_rounded;
    } else {
      badgeText = 'Black & White (Auto Translated)';
      badgeColor = const Color(0xFFFF9800);
      badgeIcon = Icons.translate_rounded;
    }

    return pagesAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
        ),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.white30),
              const SizedBox(height: 16),
              const Text(
                'Failed to load pages.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(mangaChapterPagesProvider(ChapterPagesArg(
                  mangaId: widget.mangaId,
                  chapterNumber: widget.chapterNumber,
                ))),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (pages) {
        if (pages.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(
              child: Text(
                'No pages found for this chapter.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        // Adjust currentPage if it exceeds the new pages length
        if (_currentPage > pages.length) {
          _currentPage = pages.length;
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Reader Content
              GestureDetector(
                onTap: _toggleOverlays,
                child: _isHorizontal 
                    ? _buildHorizontalReader(pages) 
                    : _buildVerticalReader(pages),
              ),

              // Floating translation progress banner
              if (pipelineState != null)
                _buildTranslationBanner(context, pipelineState),

              // Header Overlay
              if (_showOverlays)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xE6000000), Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.romajiTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Chapter ${widget.chapterNumber} / ${widget.totalChapters}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (chapter != null) ...[
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: badgeColor.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: badgeColor.withValues(alpha: 0.5),
                                            width: 1,
                                          ),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                badgeIcon,
                                                size: 9,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                badgeText,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isHorizontal ? Icons.view_headline_rounded : Icons.view_carousel_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isHorizontal = !_isHorizontal;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              // Bottom Navigation Overlay
              if (_showOverlays)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xE6000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Chapter navigator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.skip_previous, color: Colors.white),
                              onPressed: widget.chapterNumber > 1
                                  ? () => _navigateToChapter(widget.chapterNumber - 1)
                                  : null,
                            ),
                            Text(
                              'Page $_currentPage of ${pages.length}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.skip_next, color: Colors.white),
                              onPressed: widget.chapterNumber < widget.totalChapters
                                  ? () => _navigateToChapter(widget.chapterNumber + 1)
                                  : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Progress Slider
                        if (_isHorizontal)
                          Slider(
                            activeColor: const Color(0xFF7C4DFF),
                            inactiveColor: Colors.white24,
                            value: _currentPage.toDouble(),
                            min: 1.0,
                            max: pages.length.toDouble(),
                            divisions: pages.length - 1,
                            onChanged: (val) {
                              _pageController.jumpToPage(val.toInt() - 1);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHorizontalReader(List<String> pages) {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (idx) => _onPageChanged(idx, pages),
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final controller = _transformationControllers.putIfAbsent(
          index,
          () => TransformationController(),
        );

        return Center(
          child: InteractiveViewer(
            transformationController: controller,
            minScale: 1.0,
            maxScale: 4.0,
            child: GestureDetector(
              onDoubleTap: () => _doubleTapZoom(index),
              child: CachedNetworkImage(
                imageUrl: pages[index],
                fit: BoxFit.contain,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
                ),
                errorWidget: (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, size: 60, color: Colors.white30),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerticalReader(List<String> pages) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (_scrollController.hasClients) {
          final extent = _scrollController.position.pixels;
          final max = _scrollController.position.maxScrollExtent;
          if (max > 0) {
            final page = ((extent / max) * pages.length).clamp(1.0, pages.length.toDouble()).toInt();
            if (page != _currentPage) {
              setState(() {
                _currentPage = page;
              });
              _saveReadingProgress(pages.length);
            }
          }
        }
        return false;
      },
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 80),
        itemCount: pages.length,
        separatorBuilder: (_, __) => const Divider(height: 20, color: Colors.white10),
        itemBuilder: (context, index) {
          final controller = _transformationControllers.putIfAbsent(
            index,
            () => TransformationController(),
          );

          return InteractiveViewer(
            transformationController: controller,
            minScale: 1.0,
            maxScale: 4.0,
            child: GestureDetector(
              onDoubleTap: () => _doubleTapZoom(index),
              child: CachedNetworkImage(
                imageUrl: pages[index],
                fit: BoxFit.fitWidth,
                placeholder: (_, __) => const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator(color: Color(0xFF7C4DFF))),
                ),
                errorWidget: (_, __, ___) => const SizedBox(
                  height: 200,
                  child: Center(child: Icon(Icons.broken_image, size: 50, color: Colors.white30)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTranslationBanner(BuildContext context, OcrTranslationState state) {
    final theme = Theme.of(context);
    final isRunning = state.status.isRunning;
    final isCompleted = state.status == OcrTranslationStatus.completed;

    if (!isRunning && !isCompleted) return const SizedBox.shrink();

    return Positioned(
      top: 80, // Just below the header bar
      left: 16,
      right: 16,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCompleted
                  ? Colors.green.withValues(alpha: 0.5)
                  : const Color(0xFF7C4DFF).withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isCompleted ? Colors.green : const Color(0xFF7C4DFF))
                    .withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isRunning)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C4DFF)),
                  ),
                )
              else
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                  size: 18,
                ),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isCompleted ? 'Translated' : 'Auto-Translating',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      state.message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
