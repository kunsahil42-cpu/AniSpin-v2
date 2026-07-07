import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../tracker/models/watch_progress.dart';
import '../../tracker/providers/tracker_providers.dart';
import '../../anime_details/models/stream_source_model.dart';
import '../providers/stream_provider.dart';
import '../../../core/error/app_failure.dart';
import '../../settings/providers/settings_provider.dart';
import '../../settings/models/app_settings.dart';

import '../../../shared/widgets/async_network_view.dart';
import '../../anime_details/providers/anime_details_provider.dart';
import '../../anime_details/widgets/description_section.dart';
import '../../anime_details/widgets/episode_list.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final int animeId;
  final int episodeNumber;

  /// MyAnimeList id used to resolve the real stream. Null when we don't know it
  /// (e.g. an old Continue-Watching row) — the player then shows its error state.
  final int? malId;

  // Passed details via GoRouter extra
  final String romajiTitle;
  final String? englishTitle;
  final String coverImage;
  final String bannerImage;
  final int totalEpisodes;
  final bool? initialDub;

  const VideoPlayerScreen({
    super.key,
    required this.animeId,
    required this.episodeNumber,
    this.malId,
    required this.romajiTitle,
    this.englishTitle,
    required this.coverImage,
    required this.bannerImage,
    required this.totalEpisodes,
    this.initialDub,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _showControls = true;
  bool _locked = false;
  
  static const _pipChannel = MethodChannel('com.anispin.video_player/pip');
  bool _isInPip = false;
  DateTime? _lastProgressSaveTime;
  
  // Custom gesture overlays
  double _volume = 0.7; // Range: 0.0 to 1.0
  double _brightness = 0.5; // Range: 0.0 to 1.0
  bool _showVolumeIndicator = false;
  bool _showBrightnessIndicator = false;
  Timer? _indicatorTimer;

  // Selected tracks
  bool _isDub = false; // false = Sub, true = Dub
  String _activeSubtitle = 'Off';
  late VideoQualityOption _selectedQuality;
  late int _currentEpisodeNumber;
  bool _isTrueFullscreen = false;

  int _subtitleEpoch = 0;
  bool _firstResolve = true;
  double _playbackSpeed = 1.0;
  BoxFit _videoFit = BoxFit.contain;

  Timer? _controlsTimer;

  // Resolved stream state
  StreamSource? _source;
  AppFailure? _error;

  // Auto next countdown
  bool _showCountdown = false;
  int _countdownSeconds = 5;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final settings = ref.read(settingsNotifierProvider);
    _isDub = widget.initialDub ?? (settings.defaultAudio == AudioOption.dub);
    _playbackSpeed = settings.playbackSpeed;
    _selectedQuality = settings.defaultVideoQuality;
    _currentEpisodeNumber = widget.episodeNumber;
    _isTrueFullscreen = settings.autoFullscreen;

    Future.microtask(() => _resolveStream());

    // PiP MethodChannel setup
    _pipChannel.setMethodCallHandler((call) async {
      if (call.method == 'onPipChanged') {
        final isInPip = call.arguments as bool;
        setState(() {
          _isInPip = isInPip;
          if (isInPip) {
            _showControls = false;
          }
        });
      }
    });
    _pipChannel.invokeMethod('setPlayerActive', {'active': true});

    if (_isTrueFullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Pause playback immediately if the app is minimized and not in PiP mode
      if (!_isInPip && _controller?.value.isPlaying == true) {
        _controller!.pause();
        final pos = _controller!.value.position.inMilliseconds;
        final dur = _controller!.value.duration.inMilliseconds;
        if (dur > 0) {
          _saveWatchProgress(pos, dur, pos / dur, force: true);
        }
      }
    }
  }

  void _enterTrueFullscreen() {
    setState(() {
      _isTrueFullscreen = true;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _exitTrueFullscreen() {
    setState(() {
      _isTrueFullscreen = false;
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void deactivate() {
    // Immediately stop and pause native playback during deactivation (screen transitions, popping)
    // before dispose is scheduled. This guarantees zero background audio spill.
    if (_controller != null && _controller!.value.isPlaying) {
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pipChannel.invokeMethod('setPlayerActive', {'active': false});
    _controlsTimer?.cancel();
    _countdownTimer?.cancel();
    _indicatorTimer?.cancel();
    
    // Save progress immediately on dispose before closing the controller
    if (_controller != null) {
      final pos = _controller!.value.position.inMilliseconds;
      final dur = _controller!.value.duration.inMilliseconds;
      if (dur > 0) {
        final percentage = pos / dur;
        final repo = ref.read(watchProgressRepositoryProvider);
        repo.getProgress(widget.animeId).then((existing) {
          final progress = existing ?? WatchProgress()
            ..animeId = widget.animeId
            ..malId = widget.malId
            ..romajiTitle = widget.romajiTitle
            ..englishTitle = widget.englishTitle
            ..coverImage = widget.coverImage
            ..bannerImage = widget.bannerImage
            ..totalEpisodes = widget.totalEpisodes;
            
          progress
            ..lastWatchedEpisode = _currentEpisodeNumber
            ..lastWatchedPosition = pos
            ..lastWatchedDuration = dur
            ..watchPercentage = percentage
            ..lastWatchedSource = _isDub ? 'Anikoto (Dub)' : 'Anikoto (Sub)'
            ..lastWatchedAudio = _isDub ? 'Dub' : 'Sub'
            ..lastWatchedAt = DateTime.now();

          if (progress.status == null) {
            progress.status = 'Watching';
          }

          if (percentage > 0.90) {
            final completed = List<int>.from(progress.completedEpisodes);
            if (!completed.contains(_currentEpisodeNumber)) {
              completed.add(_currentEpisodeNumber);
              progress.completedEpisodes = completed;
            }
            if (widget.totalEpisodes > 0 && progress.completedEpisodes.length >= widget.totalEpisodes) {
              progress.status = 'Completed';
            }
          }

          repo.saveProgress(progress).then((_) {
            ref.invalidate(animeProgressProvider(widget.animeId));
            ref.invalidate(continueWatchingProvider);
          });
        });
      }
      
      // Stop and release native resources properly
      _controller!.pause();
      _controller!.removeListener(_videoListener);
      _controller!.dispose();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  /// Resolves the real `.m3u8` for the current episode + audio choice, then
  /// initializes the player.
  Future<void> _resolveStream({Duration? seekToPosition}) async {
    setState(() {
      _initialized = false;
      _error = null;
    });

    final malId = widget.malId;
    if (malId == null) {
      setState(() {
        _error = AppFailure.notFound('This title has no streaming source.');
      });
      return;
    }

    final req = (malId: malId, episode: _currentEpisodeNumber, dub: _isDub);
    try {
      ref.invalidate(streamProvider(req));
      final source = await ref.read(streamProvider(req).future);
      if (!mounted) return;
      _source = source;
      _reconcileSubtitleSelection(source);
      await _initializePlayer(seekToPosition: seekToPosition);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppFailure.from(e);
      });
    }
  }

  /// Keeps [_activeSubtitle] valid for the newly-resolved [source].
  void _reconcileSubtitleSelection(StreamSource source) {
    final labels = source.subtitles.map((t) => t.label).toList();
    final settings = ref.read(settingsNotifierProvider);
    final savedSub = settings.preferredSubtitleLanguage;

    if (_firstResolve) {
      _firstResolve = false;
      if (savedSub != 'Off' && labels.contains(savedSub)) {
        _activeSubtitle = savedSub;
        return;
      }
      if (savedSub == 'Off') {
        _activeSubtitle = 'Off';
        return;
      }
      if (!_isDub && labels.isNotEmpty) {
        _activeSubtitle = labels.first;
        return;
      }
    }
    if (_activeSubtitle != 'Off' && !labels.contains(_activeSubtitle)) {
      _activeSubtitle = 'Off';
    }
  }

  /// Fetches the selected track's `.vtt`, parses it and hands the captions to
  /// the controller. 'Off' clears captions.
  Future<void> _loadSubtitle(String label) async {
    final controller = _controller;
    if (controller == null) return;

    final epoch = ++_subtitleEpoch;

    if (label == 'Off') {
      await controller.setClosedCaptionFile(null);
      if (mounted) setState(() {});
      return;
    }

    SubtitleTrack? track;
    for (final t in _source?.subtitles ?? const <SubtitleTrack>[]) {
      if (t.label == label) {
        track = t;
        break;
      }
    }
    if (track == null) return;

    try {
      final res = await http.get(
        Uri.parse(track.url),
        headers: _source?.headers ?? const {},
      );
      if (res.statusCode != 200) return;
      if (!mounted || epoch != _subtitleEpoch) return;
      final captions = WebVTTCaptionFile(res.body);
      await controller.setClosedCaptionFile(Future.value(captions));
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading subtitle "$label": $e');
    }
  }

  Future<void> _initializePlayer({Duration? seekToPosition}) async {
    final source = _source;
    if (source == null) return;

    setState(() {
      _initialized = false;
    });

    // Dispose previous controller if any
    if (_controller != null) {
      _controller!.removeListener(_videoListener);
      await _controller!.dispose();
    }

    final playableUrl = await _M3u8Parser.getSelectedQualityUrl(
      source.url,
      _selectedQuality,
      source.headers,
    );

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(playableUrl),
      httpHeaders: source.headers,
      videoPlayerOptions: VideoPlayerOptions(
        allowBackgroundPlayback: false,
        mixWithOthers: true,
      ),
    );

    try {
      await _controller!.initialize();
      _controller!.addListener(_videoListener);
      
      // Determine seek position
      if (seekToPosition != null) {
        await _controller!.seekTo(seekToPosition);
      } else {
        // Load saved progress from Isar if exists
        final repo = ref.read(watchProgressRepositoryProvider);
        final savedProgress = await repo.getProgress(widget.animeId);
        if (savedProgress != null && savedProgress.lastWatchedEpisode == _currentEpisodeNumber) {
          await _controller!.seekTo(Duration(milliseconds: savedProgress.lastWatchedPosition));
        }
      }
      
      await _controller!.setPlaybackSpeed(_playbackSpeed);
      await _controller!.play();
      setState(() {
        _initialized = true;
      });
      _loadSubtitle(_activeSubtitle);
      _startControlsTimer();
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      if (mounted) {
        setState(() {
          _initialized = false;
          _error = AppFailure.server('This stream could not be played.');
        });
      }
    }
  }

  void _videoListener() {
    if (_controller == null) return;

    // Trigger Watch Progress Save
    final currentPos = _controller!.value.position.inMilliseconds;
    final totalDur = _controller!.value.duration.inMilliseconds;
    if (totalDur > 0) {
      final percentage = currentPos / totalDur;
      _saveWatchProgress(currentPos, totalDur, percentage);

      // Check if video is finished -> trigger Auto Next countdown
      if (_controller!.value.position >= _controller!.value.duration && !_showCountdown) {
        final settings = ref.read(settingsNotifierProvider);
        if (settings.autoNextEpisode) {
          _triggerAutoNext();
        }
      }
    }
  }

  void _saveWatchProgress(int position, int duration, double percentage, {bool force = false}) {
    final now = DateTime.now();
    if (!force && _lastProgressSaveTime != null && now.difference(_lastProgressSaveTime!) < const Duration(seconds: 8)) {
      return; // Skip saving to avoid continuous Isar database writes and Riverpod invalidations
    }
    _lastProgressSaveTime = now;

    final repo = ref.read(watchProgressRepositoryProvider);
    repo.getProgress(widget.animeId).then((existing) {
      final progress = existing ?? WatchProgress()
        ..animeId = widget.animeId
        ..malId = widget.malId
        ..romajiTitle = widget.romajiTitle
        ..englishTitle = widget.englishTitle
        ..coverImage = widget.coverImage
        ..bannerImage = widget.bannerImage
        ..totalEpisodes = widget.totalEpisodes;
        
      progress
        ..lastWatchedEpisode = _currentEpisodeNumber
        ..lastWatchedPosition = position
        ..lastWatchedDuration = duration
        ..watchPercentage = percentage
        ..lastWatchedSource = _isDub ? 'Anikoto (Dub)' : 'Anikoto (Sub)'
        ..lastWatchedAudio = _isDub ? 'Dub' : 'Sub'
        ..lastWatchedAt = DateTime.now();

      if (progress.status == null) {
        progress.status = 'Watching';
      }

      // Mark as completed if watched more than 90%
      if (percentage > 0.90) {
        final completed = List<int>.from(progress.completedEpisodes);
        if (!completed.contains(_currentEpisodeNumber)) {
          completed.add(_currentEpisodeNumber);
          progress.completedEpisodes = completed;
        }
        if (widget.totalEpisodes > 0 && progress.completedEpisodes.length >= widget.totalEpisodes) {
          progress.status = 'Completed';
        }
      }

      repo.saveProgress(progress).then((_) {
        ref.invalidate(animeProgressProvider(widget.animeId));
        ref.invalidate(continueWatchingProvider);
      });
    });
  }

  void _triggerAutoNext() {
    if (_currentEpisodeNumber >= widget.totalEpisodes) return;
    
    setState(() {
      _showCountdown = true;
      _countdownSeconds = 5;
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdownSeconds > 1) {
          _countdownSeconds--;
        } else {
          timer.cancel();
          _playNextEpisode();
        }
      });
    });
  }

  void _playNextEpisode() {
    _countdownTimer?.cancel();
    if (_currentEpisodeNumber < widget.totalEpisodes) {
      setState(() {
        _currentEpisodeNumber++;
        _firstResolve = true; // Apply default subtitles on new episode
      });
      _resolveStream();
    }
  }

  void _playPreviousEpisode() {
    if (_currentEpisodeNumber > 1) {
      setState(() {
        _currentEpisodeNumber--;
        _firstResolve = true;
      });
      _resolveStream();
    }
  }

  void _cancelCountdown() {
    _countdownTimer?.cancel();
    setState(() {
      _showCountdown = false;
    });
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_locked) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startControlsTimer();
      }
    });
  }

  // Swipe gesture volume/brightness modifiers
  void _handleVerticalDragUpdate(double delta, double screenWidth, double localX) {
    if (_locked) return;
    
    // Left side: Brightness, Right side: Volume
    final isLeft = localX < screenWidth / 2;
    setState(() {
      if (isLeft) {
        _brightness = (_brightness - delta / 200).clamp(0.0, 1.0);
        _showBrightnessIndicator = true;
        _showVolumeIndicator = false;
      } else {
        _volume = (_volume - delta / 200).clamp(0.0, 1.0);
        _showVolumeIndicator = true;
        _showBrightnessIndicator = false;
        _controller?.setVolume(_volume);
      }
    });

    _indicatorTimer?.cancel();
    _indicatorTimer = Timer(const Duration(seconds: 2), () {
      setState(() {
        _showVolumeIndicator = false;
        _showBrightnessIndicator = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInPip) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _initialized && _controller != null
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
                ),
        ),
      );
    }
    return PopScope(
      canPop: !_isTrueFullscreen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _exitTrueFullscreen();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
            final showFullscreen = _isTrueFullscreen || isLandscape;

            final playerHeight = showFullscreen 
                ? constraints.maxHeight 
                : constraints.maxHeight * 0.40;

            return Stack(
              children: [
                // 1. Details view (Portrait mode only)
                if (!showFullscreen)
                  Positioned(
                    top: playerHeight,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: _buildDetailsSection(),
                    ),
                  ),

                // 2. Video Player widget with smooth size transitions
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  top: 0,
                  left: 0,
                  right: 0,
                  height: playerHeight,
                  child: _buildPlayerWidget(showFullscreen, constraints.maxWidth, playerHeight),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlayerWidget(bool showFullscreen, double width, double height) {
    return GestureDetector(
      onTap: _toggleControls,
      onDoubleTap: () {
        if (_isTrueFullscreen) {
          _exitTrueFullscreen();
        } else {
          _enterTrueFullscreen();
        }
      },
      onVerticalDragUpdate: (details) {
        if (showFullscreen) {
          _handleVerticalDragUpdate(details.delta.dy, width, details.localPosition.dx);
        }
      },
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // Video display
            Center(
              child: _initialized && _controller != null
                  ? SizedBox.expand(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (!showFullscreen) ...[
                            // Blurred backdrop banner image
                            Image.network(
                              widget.bannerImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                            ),
                            ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                child: Container(color: Colors.black45),
                              ),
                            ),
                          ],
                          Center(
                            child: FittedBox(
                              fit: showFullscreen ? _videoFit : BoxFit.contain,
                              clipBehavior: Clip.hardEdge,
                              child: SizedBox(
                                width: _controller!.value.size.width,
                                height: _controller!.value.size.height,
                                child: VideoPlayer(_controller!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _error != null
                      ? _buildErrorState()
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Color(0xFF7C4DFF)),
                            SizedBox(height: 16),
                            Text('Preparing stream...', style: TextStyle(color: Colors.white70)),
                          ],
                        ),
            ),

            // Buffering Indicator overlay
            if (_initialized && _controller != null)
              ValueListenableBuilder(
                valueListenable: _controller!,
                builder: (context, value, child) {
                  if (value.isBuffering) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

            // Subtitle overlay
            if (_initialized && _controller != null && _activeSubtitle != 'Off')
              Positioned(
                left: 24,
                right: 24,
                bottom: _showControls && !_locked ? (showFullscreen ? 96 : 48) : 24,
                child: ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: _controller!,
                  builder: (context, value, _) {
                    final text = value.caption.text;
                    if (text.isEmpty) return const SizedBox.shrink();
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: showFullscreen ? 18 : 13,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Volume & Brightness indicators
            if (showFullscreen) ...[
              if (_showVolumeIndicator)
                Center(
                  child: Card(
                    color: const Color(0xD9000000),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.volume_up, color: Color(0xFF7C4DFF)),
                          const SizedBox(width: 8),
                          Text('Volume: ${(_volume * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_showBrightnessIndicator)
                Center(
                  child: Card(
                    color: const Color(0xD9000000),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.brightness_medium, color: Color(0xFF7C4DFF)),
                          const SizedBox(width: 8),
                          Text('Brightness: ${(_brightness * 100).toInt()}%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],

            // Controls overlays
            if (_showControls)
              ..._buildControlsOverlays(showFullscreen, width, height),

            // Auto next countdown overlay
            if (_showCountdown)
              _buildCountdownOverlay(showFullscreen),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildControlsOverlays(bool showFullscreen, double width, double height) {
    if (showFullscreen) {
      return [
        // Top Gradient overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 90,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xD9000000), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Bottom Gradient overlay
        if (!_locked)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xD9000000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

        // Header Controls
        if (!_locked)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (_isTrueFullscreen) {
                      _exitTrueFullscreen();
                    } else {
                      context.pop();
                    }
                  },
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.romajiTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Episode $_currentEpisodeNumber / ${widget.totalEpisodes}',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.picture_in_picture, color: Colors.white),
                  onPressed: () {
                    _pipChannel.invokeMethod('enterPip');
                  },
                ),
              ],
            ),
          ),

        // Lockdown lock button
        Positioned(
          left: 20,
          top: height / 2 - 20,
          child: IconButton(
            icon: Icon(_locked ? Icons.lock : Icons.lock_open, color: Colors.white),
            onPressed: () {
              setState(() {
                _locked = !_locked;
                _showControls = true;
              });
              _startControlsTimer();
            },
          ),
        ),

        // Central controllers
        if (!_locked)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous Episode Skip
                IconButton(
                  iconSize: 36,
                  icon: Icon(Icons.skip_previous, color: _currentEpisodeNumber > 1 ? Colors.white : Colors.white24),
                  onPressed: _currentEpisodeNumber > 1 ? _playPreviousEpisode : null,
                ),
                IconButton(
                  iconSize: 42,
                  icon: const Icon(Icons.replay_10_rounded, color: Colors.white),
                  onPressed: () {
                    if (_controller == null) return;
                    final newPos = _controller!.value.position - const Duration(seconds: 10);
                    _controller!.seekTo(newPos);
                    _startControlsTimer();
                  },
                ),
                IconButton(
                  iconSize: 64,
                  icon: Icon(
                    _controller?.value.isPlaying == true ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: const Color(0xFF7C4DFF),
                  ),
                  onPressed: () {
                    if (_controller == null) return;
                    setState(() {
                      if (_controller!.value.isPlaying) {
                        _controller!.pause();
                        final pos = _controller!.value.position.inMilliseconds;
                        final dur = _controller!.value.duration.inMilliseconds;
                        if (dur > 0) {
                          _saveWatchProgress(pos, dur, pos / dur, force: true);
                        }
                      } else {
                        _controller!.play();
                      }
                    });
                    _startControlsTimer();
                  },
                ),
                IconButton(
                  iconSize: 42,
                  icon: const Icon(Icons.forward_10_rounded, color: Colors.white),
                  onPressed: () {
                    if (_controller == null) return;
                    final newPos = _controller!.value.position + const Duration(seconds: 10);
                    _controller!.seekTo(newPos);
                    _startControlsTimer();
                  },
                ),
                // Next Episode Skip
                IconButton(
                  iconSize: 36,
                  icon: Icon(Icons.skip_next, color: _currentEpisodeNumber < widget.totalEpisodes ? Colors.white : Colors.white24),
                  onPressed: _currentEpisodeNumber < widget.totalEpisodes ? _playNextEpisode : null,
                ),
              ],
            ),
          ),

        // Bottom status bar / seeker
        if (!_locked)
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Seeker Slider
                if (_controller != null)
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _controller!,
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          Text(
                            _formatDuration(value.position),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Expanded(
                            child: Slider(
                              activeColor: const Color(0xFF7C4DFF),
                              inactiveColor: Colors.white24,
                              value: value.position.inMilliseconds.toDouble(),
                              min: 0.0,
                              max: value.duration.inMilliseconds.toDouble().clamp(0.1, double.infinity),
                              onChanged: (val) {
                                _controller!.seekTo(Duration(milliseconds: val.toInt()));
                                _startControlsTimer();
                              },
                            ),
                          ),
                          Text(
                            _formatDuration(value.duration),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                const SizedBox(height: 4),
                // Options bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.speed, color: Colors.white, size: 16),
                          label: Text('${_playbackSpeed}x', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          onPressed: _showSpeedSelector,
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.aspect_ratio, color: Colors.white, size: 16),
                          label: Text(_getFitLabel(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                          onPressed: _toggleVideoFit,
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.settings, color: Colors.white, size: 16),
                          label: Text(_getQualityLabel(_selectedQuality), style: const TextStyle(color: Colors.white, fontSize: 12)),
                          onPressed: _showQualitySelector,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.subtitles, color: Colors.white, size: 16),
                          label: Text('Sub: $_activeSubtitle', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          onPressed: _showSubtitleSelector,
                        ),
                        const SizedBox(width: 12),
                        TextButton.icon(
                          icon: const Icon(Icons.audiotrack, color: Colors.white, size: 16),
                          label: Text('Audio: ${_isDub ? "Dub" : "Sub"}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                          onPressed: _showAudioSelector,
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: Icon(_isTrueFullscreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white),
                          onPressed: () {
                            if (_isTrueFullscreen) {
                              _exitTrueFullscreen();
                            } else {
                              _enterTrueFullscreen();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
      ];
    } else {
      // Embedded controls (simplified for Portrait)
      return [
        // Small Top gradient
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0x99000000), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Small Bottom gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Color(0x99000000)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),

        // Simple Header
        Positioned(
          top: 10,
          left: 10,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),

        // Simple Center Play/Pause & skips
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 28,
                icon: Icon(Icons.skip_previous, color: _currentEpisodeNumber > 1 ? Colors.white : Colors.white24),
                onPressed: _currentEpisodeNumber > 1 ? _playPreviousEpisode : null,
              ),
              IconButton(
                iconSize: 48,
                icon: Icon(
                  _controller?.value.isPlaying == true ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: const Color(0xFF7C4DFF),
                ),
                onPressed: () {
                  if (_controller == null) return;
                  setState(() {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                      final pos = _controller!.value.position.inMilliseconds;
                      final dur = _controller!.value.duration.inMilliseconds;
                      if (dur > 0) {
                        _saveWatchProgress(pos, dur, pos / dur, force: true);
                      }
                    } else {
                      _controller!.play();
                    }
                  });
                  _startControlsTimer();
                },
              ),
              IconButton(
                iconSize: 28,
                icon: Icon(Icons.skip_next, color: _currentEpisodeNumber < widget.totalEpisodes ? Colors.white : Colors.white24),
                onPressed: _currentEpisodeNumber < widget.totalEpisodes ? _playNextEpisode : null,
              ),
            ],
          ),
        ),

        // Simple Bottom seek & fullscreen & selectors
        Positioned(
          bottom: 5,
          left: 10,
          right: 10,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_controller != null)
                ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: _controller!,
                  builder: (context, value, child) {
                    return Row(
                      children: [
                        Text(
                          _formatDuration(value.position),
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: Slider(
                              activeColor: const Color(0xFF7C4DFF),
                              inactiveColor: Colors.white24,
                              value: value.position.inMilliseconds.toDouble(),
                              min: 0.0,
                              max: value.duration.inMilliseconds.toDouble().clamp(0.1, double.infinity),
                              onChanged: (val) {
                                _controller!.seekTo(Duration(milliseconds: val.toInt()));
                                _startControlsTimer();
                              },
                            ),
                          ),
                        ),
                        Text(
                          _formatDuration(value.duration),
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    );
                  },
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.subtitles, color: Colors.white, size: 14),
                        label: Text('Sub: $_activeSubtitle', style: const TextStyle(color: Colors.white, fontSize: 11)),
                        onPressed: _showSubtitleSelector,
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: const Icon(Icons.audiotrack, color: Colors.white, size: 14),
                        label: Text('Audio: ${_isDub ? "Dub" : "Sub"}', style: const TextStyle(color: Colors.white, fontSize: 11)),
                        onPressed: _showAudioSelector,
                      ),
                    ],
                  ),
                  IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: _enterTrueFullscreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ];
    }
  }

  Widget _buildCountdownOverlay(bool showFullscreen) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Up Next',
              style: TextStyle(color: Colors.white70, fontSize: showFullscreen ? 18 : 13),
            ),
            const SizedBox(height: 4),
            Text(
              'Episode ${_currentEpisodeNumber + 1}',
              style: TextStyle(color: Colors.white, fontSize: showFullscreen ? 24 : 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: showFullscreen ? 24 : 12),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: showFullscreen ? 80 : 50,
                  height: showFullscreen ? 80 : 50,
                  child: CircularProgressIndicator(
                    value: _countdownSeconds / 5,
                    color: const Color(0xFF7C4DFF),
                    strokeWidth: showFullscreen ? 6 : 4,
                  ),
                ),
                Text(
                  '$_countdownSeconds',
                  style: TextStyle(color: Colors.white, fontSize: showFullscreen ? 28 : 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: showFullscreen ? 32 : 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _cancelCountdown,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white30),
                    padding: showFullscreen ? null : const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _playNextEpisode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
                    foregroundColor: Colors.white,
                    padding: showFullscreen ? null : const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  child: const Text('Skip'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    final animeDetailsAsync = ref.watch(animeDetailsProvider(widget.animeId));

    return AsyncNetworkView(
      value: animeDetailsAsync,
      onRetry: () => ref.invalidate(animeDetailsProvider(widget.animeId)),
      data: (animeData) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                animeData.romajiTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (animeData.englishTitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  animeData.englishTitle!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              DescriptionSection(description: animeData.description),
              const SizedBox(height: 24),
              EpisodeList(
                animeId: animeData.id,
                malId: animeData.idMal,
                totalEpisodes: animeData.episodes ?? widget.totalEpisodes,
                status: animeData.status,
                romajiTitle: animeData.romajiTitle,
                englishTitle: animeData.englishTitle,
                coverImage: animeData.coverImage,
                bannerImage: animeData.bannerImage,
                streamingEpisodes: animeData.streamingEpisodes,
                nextAiringEpisode: animeData.nextAiringEpisode,
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Widget _buildErrorState() {
    final failure = _error;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white70, size: 48),
          const SizedBox(height: 16),
          Text(
            failure?.title ?? 'Stream unavailable',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            failure?.message ?? 'We could not load this episode.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white30),
                ),
                child: const Text('Back'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _resolveStream,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4DFF),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSpeedSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
          return ListTile(
            title: Text('${speed}x'),
            trailing: _playbackSpeed == speed ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
            onTap: () {
              setState(() {
                _playbackSpeed = speed;
                _controller?.setPlaybackSpeed(speed);
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  String _getFitLabel() {
    switch (_videoFit) {
      case BoxFit.contain:
        return 'Fit';
      case BoxFit.cover:
        return 'Zoom';
      case BoxFit.fill:
        return 'Stretch';
      default:
        return 'Fit';
    }
  }

  void _toggleVideoFit() {
    setState(() {
      if (_videoFit == BoxFit.contain) {
        _videoFit = BoxFit.cover;
      } else if (_videoFit == BoxFit.cover) {
        _videoFit = BoxFit.fill;
      } else {
        _videoFit = BoxFit.contain;
      }
    });
    _startControlsTimer();
  }

  String _getQualityLabel(VideoQualityOption quality) {
    switch (quality) {
      case VideoQualityOption.auto:
        return 'Auto Quality';
      case VideoQualityOption.p360:
        return '360p';
      case VideoQualityOption.p480:
        return '480p';
      case VideoQualityOption.p720:
        return '720p';
      case VideoQualityOption.p1080:
        return '1080p';
    }
  }

  void _showQualitySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: VideoQualityOption.values.map((quality) {
          return ListTile(
            title: Text(_getQualityLabel(quality)),
            trailing: _selectedQuality == quality ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
            onTap: () {
              Navigator.pop(context);
              if (_selectedQuality == quality) return;
              setState(() {
                _selectedQuality = quality;
              });
              final pos = _controller?.value.position;
              _initializePlayer(seekToPosition: pos);
            },
          );
        }).toList(),
      ),
    );
  }



  void _showAudioSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        const options = [false, true]; // Sub, Dub
        return ListView(
          shrinkWrap: true,
          children: options.map((dub) {
            final isActive = _isDub == dub;
            return ListTile(
              title: Text(
                dub ? '🇺🇸 English (Dub)' : '🇯🇵 Japanese (Sub)',
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? const Color(0xFF7C4DFF) : null,
                ),
              ),
              trailing: isActive ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
              onTap: () {
                Navigator.pop(context);
                if (_isDub == dub) return;
                final pos = _controller?.value.position;
                setState(() {
                  _isDub = dub;
                  _activeSubtitle = 'Off';
                });
                ref.read(settingsNotifierProvider.notifier).setDefaultAudio(dub ? AudioOption.dub : AudioOption.sub);
                _resolveStream(seekToPosition: pos);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showSubtitleSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final tracks = _source?.subtitles ?? const [];
        final labels = ['Off', ...tracks.map((t) => t.label)];
        return ListView(
          shrinkWrap: true,
          children: labels.map((label) {
            final isActive = _activeSubtitle == label;
            return ListTile(
              title: Text(
                label,
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? const Color(0xFF7C4DFF) : null,
                ),
              ),
              trailing: isActive ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
              onTap: () {
                Navigator.pop(context);
                if (_activeSubtitle == label) return;
                setState(() {
                  _activeSubtitle = label;
                });
                ref.read(settingsNotifierProvider.notifier).setPreferredSubtitleLanguage(label);
                _loadSubtitle(label);
              },
            );
          }).toList(),
        );
      },
    );
  }


}

// ==========================================================================
// HLS STREAM QUALITY PARSER
// ==========================================================================

class _M3u8Parser {
  static Future<String> getSelectedQualityUrl(
    String masterUrl,
    VideoQualityOption preferredQuality,
    Map<String, String> headers,
  ) async {
    if (preferredQuality == VideoQualityOption.auto) {
      return masterUrl;
    }

    try {
      final res = await http.get(Uri.parse(masterUrl), headers: headers)
          .timeout(const Duration(seconds: 4));
      if (res.statusCode != 200) return masterUrl;

      final lines = const LineSplitter().convert(res.body);
      String? matchedUrl;
      int closestResolution = 0;
      
      int targetHeight = 1080;
      switch (preferredQuality) {
        case VideoQualityOption.p360:
          targetHeight = 360;
          break;
        case VideoQualityOption.p480:
          targetHeight = 480;
          break;
        case VideoQualityOption.p720:
          targetHeight = 720;
          break;
        case VideoQualityOption.p1080:
          targetHeight = 1080;
          break;
        default:
          return masterUrl;
      }

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.startsWith('#EXT-X-STREAM-INF:')) {
          final resMatch = RegExp(r'RESOLUTION=\d+x(\d+)').firstMatch(line);
          if (resMatch != null) {
            final h = int.tryParse(resMatch.group(1) ?? '') ?? 0;
            if (i + 1 < lines.length) {
              final subUrl = lines[i + 1].trim();
              if (!subUrl.startsWith('#')) {
                if (h == targetHeight) {
                  matchedUrl = subUrl;
                  break;
                }
                if (matchedUrl == null || 
                    (h - targetHeight).abs() < (closestResolution - targetHeight).abs()) {
                  matchedUrl = subUrl;
                  closestResolution = h;
                }
              }
            }
          }
        }
      }

      if (matchedUrl != null) {
        if (matchedUrl.startsWith('http')) {
          return matchedUrl;
        } else {
          final uri = Uri.parse(masterUrl);
          final pathSegments = List<String>.from(uri.pathSegments);
          if (pathSegments.isNotEmpty) {
            pathSegments.removeLast(); // remove master.m3u8 filename
          }
          final basePath = uri.replace(pathSegments: [...pathSegments, matchedUrl]);
          return basePath.toString();
        }
      }
    } catch (_) {}

    return masterUrl;
  }
}
