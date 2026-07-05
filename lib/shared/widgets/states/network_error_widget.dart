import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/error/app_failure.dart';

/// The production-quality "no internet / something went wrong" screen.
///
/// Illustration is a themed animated icon (no asset files): a wifi-off glyph
/// inside a gradient circle that fades and gently pulses in. Shows the
/// [AppFailure]'s clean title/message and a single TRY AGAIN button — never a
/// raw exception.
class NetworkErrorWidget extends StatelessWidget {
  const NetworkErrorWidget({
    super.key,
    required this.failure,
    required this.onTryAgain,
    this.compact = false,
  });

  final AppFailure failure;

  /// Connectivity-aware retry (see [AsyncNetworkView]).
  final Future<void> Function() onTryAgain;

  /// Smaller variant for inline sections (e.g. Home's horizontal rows).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNetwork = failure.isNetwork;
    final double circleSize = compact ? 84 : 132;
    final double iconSize = compact ? 40 : 64;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(compact ? 16 : 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Illustration -------------------------------------------
            Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF7C4DFF), // primary purple
                    Color(0xFF00E5FF), // secondary cyan
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C4DFF).withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                isNetwork
                    ? Icons.wifi_off_rounded
                    : Icons.error_outline_rounded,
                size: iconSize,
                color: Colors.white,
              ),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.06, 1.06),
                  duration: 1200.ms,
                  curve: Curves.easeInOut,
                )
                .animate() // separate one-shot entrance
                .fadeIn(duration: 450.ms)
                .slideY(begin: .12, end: 0, duration: 450.ms),

            SizedBox(height: compact ? 16 : 28),

            // --- Title --------------------------------------------------
            Text(
              failure.title,
              textAlign: TextAlign.center,
              style: (compact
                      ? theme.textTheme.titleMedium
                      : theme.textTheme.headlineSmall)
                  ?.copyWith(fontWeight: FontWeight.bold),
            ).animate().fadeIn(delay: 120.ms, duration: 400.ms),

            const SizedBox(height: 10),

            // --- Subtitle -----------------------------------------------
            Text(
              failure.message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            SizedBox(height: compact ? 18 : 28),

            // --- Action -------------------------------------------------
            FilledButton.icon(
              onPressed: onTryAgain,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("TRY AGAIN"),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 20 : 28,
                  vertical: compact ? 10 : 14,
                ),
              ),
            ).animate().fadeIn(delay: 280.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
