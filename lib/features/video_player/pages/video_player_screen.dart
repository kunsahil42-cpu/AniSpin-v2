import 'dart:async';
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

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _initialized = false;
  bool _showControls = true;
  bool _locked = false;
  bool _isPipActive = false;
  
  // Custom gesture overlays
  double _volume = 0.7; // Range: 0.0 to 1.0
  double _brightness = 0.5; // Range: 0.0 to 1.0
  bool _showVolumeIndicator = false;
  bool _showBrightnessIndicator = false;
  Timer? _indicatorTimer;

  // Selected tracks
  bool _isDub = false; // false = Sub, true = Dub
  String _activeSubtitle = 'Off';

  /// Bumped every time a subtitle load starts, so a slow `.vtt` fetch that
  /// finishes after the user switched tracks (or episode) is discarded instead
  /// of clobbering the newer selection.
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
    _isDub = widget.initialDub ?? false;
    Future.microtask(() => _resolveStream());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Resolves the real `.m3u8` for the current episode + audio choice, then
  /// initializes the player. Any failure (including a missing MAL id) lands in
  /// [_error], which the UI renders as "Stream unavailable" + Retry.
  Future<void> _resolveStream() async {
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

    final req = (malId: malId, episode: widget.episodeNumber, dub: _isDub);
    try {
      // Re-resolve fresh each time so Retry actually re-hits the source.
      ref.invalidate(streamProvider(req));
      final source = await ref.read(streamProvider(req).future);
      if (!mounted) return;
      _source = source;
      _reconcileSubtitleSelection(source);
      await _initializePlayer();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = AppFailure.from(e);
      });
    }
  }

  /// Keeps [_activeSubtitle] valid for the newly-resolved [source]. On the very
  /// first resolve of a subbed stream we auto-enable the source's default (or
  /// first) caption track; afterwards we respect the user's choice, only
  /// falling back to 'Off' when their selected language isn't offered.
  void _reconcileSubtitleSelection(StreamSource source) {
    final labels = source.subtitles.map((t) => t.label).toList();

    if (_firstResolve) {
      _firstResolve = false;
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
  /// the controller. 'Off' clears captions. Guarded by [_subtitleEpoch] so a
  /// stale fetch can't override a newer selection.
  Future<void> _loadSubtitle(String label) async {
    final controller = _controller;
    if (controller == null) return;

    final epoch = ++_subtitleEpoch;

    if (label == 'Off') {
      // Empty caption file = nothing rendered.
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
      if (!mounted || epoch != _subtitleEpoch) return; // superseded
      final captions = WebVTTCaptionFile(res.body);
      await controller.setClosedCaptionFile(Future.value(captions));
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading subtitle "$label": $e');
    }
  }

  Future<void> _initializePlayer() async {
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

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(source.url),
      httpHeaders: source.headers,
    );

    try {
      await _controller!.initialize();
      _controller!.addListener(_videoListener);
      
      // Load saved progress from Isar if exists
      final repo = ref.read(watchProgressRepositoryProvider);
      final savedProgress = await repo.getProgress(widget.animeId);
      if (savedProgress != null && savedProgress.lastWatchedEpisode == widget.episodeNumber) {
        await _controller!.seekTo(Duration(milliseconds: savedProgress.lastWatchedPosition));
      }
      
      await _controller!.play();
      setState(() {
        _initialized = true;
      });
      // A fresh controller starts with no captions — (re)apply the selection.
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
        _triggerAutoNext();
      }
    }
  }

  void _saveWatchProgress(int position, int duration, double percentage) {
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
        ..lastWatchedEpisode = widget.episodeNumber
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
        if (!completed.contains(widget.episodeNumber)) {
          completed.add(widget.episodeNumber);
          progress.completedEpisodes = completed;
        }
        if (widget.totalEpisodes > 0 && progress.completedEpisodes.length >= widget.totalEpisodes) {
          progress.status = 'Completed';
        }
      }

      repo.saveProgress(progress).then((_) {
        // Invalidate provider to update UI
        ref.invalidate(animeProgressProvider(widget.animeId));
        ref.invalidate(continueWatchingProvider);
      });
    });
  }

  void _triggerAutoNext() {
    if (widget.episodeNumber >= widget.totalEpisodes) return;
    
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
    if (widget.episodeNumber < widget.totalEpisodes) {
      context.pushReplacement(
        '/anime/${widget.animeId}/play/${widget.episodeNumber + 1}',
        extra: {
          'malId': widget.malId,
          'romajiTitle': widget.romajiTitle,
          'englishTitle': widget.englishTitle,
          'coverImage': widget.coverImage,
          'bannerImage': widget.bannerImage,
          'totalEpisodes': widget.totalEpisodes,
        },
      );
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
  void dispose() {
    _controlsTimer?.cancel();
    _countdownTimer?.cancel();
    _indicatorTimer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        onVerticalDragUpdate: (details) {
          _handleVerticalDragUpdate(details.delta.dy, size.width, details.localPosition.dx);
        },
        child: Stack(
          children: [
            // Video display
            Center(
              child: _initialized && _controller != null
                  // Render with dynamic aspect ratio fit (Fit, Zoom, Stretch).
                  ? SizedBox.expand(
                      child: FittedBox(
                        fit: _videoFit,
                        clipBehavior: Clip.hardEdge,
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(_controller!),
                        ),
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

            // Subtitle overlay — rebuilds with playback position via the
            // controller's ValueNotifier. Lifts above the seek bar while
            // controls are visible so captions aren't hidden behind them.
            if (_initialized && _controller != null && _activeSubtitle != 'Off')
              Positioned(
                left: 24,
                right: 24,
                bottom: _showControls && !_locked ? 96 : 32,
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Top Gradient overlay
            if (_showControls)
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
            if (_showControls && !_locked)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Color(0xD9000000)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),

            // Floating gesture level indicators
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

            // Overlays & HUD
            if (_showControls) ...[
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
                        onPressed: () => context.pop(),
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
                              'Episode ${widget.episodeNumber} / ${widget.totalEpisodes}',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      // PiP / Chromecast Mock icons
                      IconButton(
                        icon: Icon(_isPipActive ? Icons.picture_in_picture_alt : Icons.picture_in_picture, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _isPipActive = !_isPipActive;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_isPipActive ? 'PiP Mode Activated' : 'PiP Mode Deactivated')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.cast, color: Colors.white),
                        onPressed: () => _showChromecastDialog(),
                      ),
                    ],
                  ),
                ),

              // Lockdown lock button
              Positioned(
                left: 20,
                top: size.height / 2 - 20,
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

              // Central controllers (Play/Pause, Seek forward, rewind)
              if (!_locked)
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                    ],
                  ),
                ),

              // Bottom status bar / seeker
              if (!_locked)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      // Seeker Slider
                      if (_controller != null)
                        Row(
                          children: [
                            Text(
                              _formatDuration(_controller!.value.position),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Expanded(
                              child: Slider(
                                activeColor: const Color(0xFF7C4DFF),
                                inactiveColor: Colors.white24,
                                value: _controller!.value.position.inMilliseconds.toDouble(),
                                min: 0.0,
                                max: _controller!.value.duration.inMilliseconds.toDouble(),
                                onChanged: (val) {
                                  _controller!.seekTo(Duration(milliseconds: val.toInt()));
                                  _startControlsTimer();
                                },
                              ),
                            ),
                            Text(
                              _formatDuration(_controller!.value.duration),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      const SizedBox(height: 4),
                      // Quality / Sub-Dub selector bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.speed, color: Colors.white, size: 16),
                                label: Text('${_playbackSpeed}x', style: const TextStyle(color: Colors.white)),
                                onPressed: () => _showSpeedSelector(),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                icon: const Icon(Icons.aspect_ratio, color: Colors.white, size: 16),
                                label: Text(_getFitLabel(), style: const TextStyle(color: Colors.white)),
                                onPressed: _toggleVideoFit,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.subtitles, color: Colors.white, size: 16),
                                label: Text(_activeSubtitle, style: const TextStyle(color: Colors.white)),
                                onPressed: () => _showSubtitleSelector(),
                              ),
                              const SizedBox(width: 16),
                              TextButton.icon(
                                icon: const Icon(Icons.audiotrack, color: Colors.white, size: 16),
                                label: Text(_isDub ? 'Dub' : 'Sub', style: const TextStyle(color: Colors.white)),
                                onPressed: () => _showAudioSelector(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],

            // Auto next countdown overlay
            if (_showCountdown)
              Container(
                color: Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Up Next',
                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Episode ${widget.episodeNumber + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: _countdownSeconds / 5,
                              color: const Color(0xFF7C4DFF),
                              strokeWidth: 6,
                            ),
                          ),
                          Text(
                            '$_countdownSeconds',
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: _cancelCountdown,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Colors.white30),
                            ),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _playNextEpisode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C4DFF),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Skip'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  /// Shown when the stream can't be resolved or played. Offers a Retry that
  /// re-resolves from the source, and a Back that leaves the player.
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

  void _showAudioSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        const options = [false, true]; // Sub, Dub
        return ListView(
          shrinkWrap: true,
          children: options.map((dub) {
            return ListTile(
              title: Text(dub ? '🇺🇸 English (Dub)' : '🇯🇵 Japanese (Sub)'),
              trailing: _isDub == dub ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
              onTap: () {
                Navigator.pop(context);
                if (_isDub == dub) return;
                setState(() {
                  _isDub = dub;
                  _activeSubtitle = 'Off';
                });
                // Re-resolve the stream for the new audio track.
                _resolveStream();
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
            return ListTile(
              title: Text(label),
              trailing: _activeSubtitle == label ? const Icon(Icons.check, color: Color(0xFF7C4DFF)) : null,
              onTap: () {
                Navigator.pop(context);
                if (_activeSubtitle == label) return;
                setState(() {
                  _activeSubtitle = label;
                });
                _loadSubtitle(label);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showChromecastDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.cast, color: Color(0xFF7C4DFF)),
            SizedBox(width: 10),
            Text('Connect to device'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Living Room TV'),
              subtitle: const Text('Chromecast Ultra'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connected to Living Room TV')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv),
              title: const Text('Bedroom Shield TV'),
              subtitle: const Text('Android TV'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connected to Bedroom Shield TV')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
