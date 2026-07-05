import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/app_failure.dart';
import '../providers/connectivity_provider.dart';
import 'states/error_state.dart';
import 'states/loading_state.dart';
import 'states/network_error_widget.dart';

/// The single funnel every network-backed screen uses to render an
/// [AsyncValue]. It encapsulates, once and for all:
///
///  * mapping any raw error to a user-safe [AppFailure] (never shows raw text);
///  * the beautiful [NetworkErrorWidget] for connectivity failures and a clean
///    generic error otherwise;
///  * a connectivity-aware **TRY AGAIN** (offline → SnackBar, no API call;
///    online → [onRetry]);
///  * **auto-recovery** — when connectivity returns while a network error is on
///    screen, [onRetry] fires automatically.
///
/// Screens just supply their provider's value, a data builder and an
/// `onRetry` (usually `() => ref.invalidate(theProvider)`). No per-screen
/// error/retry/connectivity code.
class AsyncNetworkView<T> extends ConsumerStatefulWidget {
  const AsyncNetworkView({
    super.key,
    required this.value,
    required this.data,
    required this.onRetry,
    this.loading,
    this.compact = false,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;

  /// Re-runs the failed request. Typically `() => ref.invalidate(provider)`.
  final VoidCallback onRetry;

  /// Optional custom loading widget (e.g. a skeleton). Defaults to [LoadingState].
  final Widget Function()? loading;

  /// Smaller error/loading layout for inline sections.
  final bool compact;

  @override
  ConsumerState<AsyncNetworkView<T>> createState() =>
      _AsyncNetworkViewState<T>();
}

class _AsyncNetworkViewState<T> extends ConsumerState<AsyncNetworkView<T>> {
  bool get _showingNetworkError {
    final v = widget.value;
    return v.hasError && AppFailure.from(v.error).isNetwork;
  }

  Future<void> _tryAgain() async {
    final online = await ref.read(connectivityServiceProvider).isOnline();
    if (!online) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              "No internet connection. Please check your network.",
            ),
          ),
        );
      return;
    }
    widget.onRetry();
  }

  @override
  Widget build(BuildContext context) {
    // Auto-recovery: retry automatically the moment connectivity returns while
    // a connectivity error is showing.
    ref.listen<AsyncValue<bool>>(connectivityStatusProvider, (prev, next) {
      final cameOnline = (prev?.value ?? false) == false && next.value == true;
      if (cameOnline && _showingNetworkError) {
        widget.onRetry();
      }
    });

    return widget.value.when(
      loading: () => widget.loading?.call() ?? const LoadingState(),
      data: widget.data,
      error: (error, _) {
        final failure = AppFailure.from(error);
        if (failure.isNetwork) {
          return NetworkErrorWidget(
            failure: failure,
            onTryAgain: _tryAgain,
            compact: widget.compact,
          );
        }
        // Generic (server/unknown/local) error — still clean, never raw.
        return ErrorState(
          message: failure.message,
          onRetry: _tryAgain,
        );
      },
    );
  }
}
