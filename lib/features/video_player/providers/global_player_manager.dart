import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

/// Centralized manager ensuring only ONE active [VideoPlayerController]
/// can exist or play at any given time in the app.
class GlobalPlayerManager {
  static VideoPlayerController? _activeController;

  /// Returns the current active controller, if any.
  static VideoPlayerController? get activeController => _activeController;

  /// Registers a new controller as the sole active controller in the app.
  /// If another controller was previously active, it is immediately stopped,
  /// listeners removed, and disposed before registering [controller].
  static Future<void> registerAndDisposePrevious(VideoPlayerController controller) async {
    if (_activeController != null && _activeController != controller) {
      final old = _activeController!;
      _activeController = null;
      try {
        if (old.value.isInitialized) {
          await old.pause();
        }
      } catch (e) {
        debugPrint('[GlobalPlayerManager] Error pausing previous controller: $e');
      }
      try {
        await old.dispose();
      } catch (e) {
        debugPrint('[GlobalPlayerManager] Error disposing previous controller: $e');
      }
    }
    _activeController = controller;
  }

  /// Immediately stops and disposes [controller] if it is currently registered.
  static Future<void> disposeController(VideoPlayerController? controller) async {
    if (controller == null) return;
    if (_activeController == controller) {
      _activeController = null;
    }
    try {
      if (controller.value.isInitialized) {
        await controller.pause();
      }
    } catch (e) {
      debugPrint('[GlobalPlayerManager] Error pausing controller: $e');
    }
    try {
      await controller.dispose();
    } catch (e) {
      debugPrint('[GlobalPlayerManager] Error disposing controller: $e');
    }
  }

  /// Disposes any active player currently registered in the system.
  static Future<void> disposeAnyActive() async {
    if (_activeController != null) {
      final old = _activeController!;
      _activeController = null;
      try {
        if (old.value.isInitialized) {
          await old.pause();
        }
      } catch (e) {
        debugPrint('[GlobalPlayerManager] Error pausing active controller: $e');
      }
      try {
        await old.dispose();
      } catch (e) {
        debugPrint('[GlobalPlayerManager] Error disposing active controller: $e');
      }
    }
  }
}
