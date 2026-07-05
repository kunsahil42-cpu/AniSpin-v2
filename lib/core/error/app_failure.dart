import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

/// The kind of failure, used to decide which UI to show.
enum AppFailureType {
  /// No/unreliable internet connection (socket / host-lookup failures).
  network,

  /// The server was reached but responded with an error.
  server,

  /// The request succeeded but the requested item does not exist.
  notFound,

  /// Anything we could not classify.
  unknown,
}

/// A user-safe failure.
///
/// This is the ONLY error type the UI ever sees. It carries a clean [title]
/// and [message] — never a raw `OperationException`, `SocketException`,
/// stack trace or `package:http` error. Raw exceptions are logged in debug
/// mode only (see [_logRaw]).
@immutable
class AppFailure implements Exception {
  const AppFailure(this.type, this.title, this.message);

  final AppFailureType type;
  final String title;
  final String message;

  bool get isNetwork => type == AppFailureType.network;

  factory AppFailure.network() => const AppFailure(
        AppFailureType.network,
        "We're having trouble connecting!",
        "Try again in a moment, or check your internet connection.",
      );

  factory AppFailure.server() => const AppFailure(
        AppFailureType.server,
        "Something went wrong",
        "Please try again later.",
      );

  factory AppFailure.notFound([String? message]) => AppFailure(
        AppFailureType.notFound,
        "Not found",
        message ?? "We couldn't find what you were looking for.",
      );

  /// Substrings that reliably indicate a connectivity failure across
  /// platforms (dart:io on mobile/desktop, package:http on web).
  static const List<String> _networkMarkers = [
    'SocketException',
    'Failed host lookup',
    'Network is unreachable',
    'Connection refused',
    'Connection closed',
    'Connection reset',
    'Connection timed out',
    'timed out',
    'TimeoutException',
    'No stream event',
    'ClientException',
    'XMLHttpRequest',
    'HandshakeException',
  ];

  static bool _looksLikeNetwork(String text) {
    return _networkMarkers.any(text.contains);
  }

  /// Classifies a graphql_flutter [OperationException].
  static AppFailure fromOperation(OperationException? exception) {
    _logRaw(exception);

    if (exception == null) return AppFailure.server();

    final link = exception.linkException;
    if (link != null) {
      // The socket/host-lookup error is carried on `originalException`.
      final raw = '${link.originalException ?? ''} $link';
      if (_looksLikeNetwork(raw)) return AppFailure.network();
      // A LinkException that isn't a network problem = a bad/failed response.
      return AppFailure.server();
    }

    if (exception.graphqlErrors.isNotEmpty) return AppFailure.server();

    // No link error and no graphql errors, but still flagged as an exception.
    return _looksLikeNetwork(exception.toString())
        ? AppFailure.network()
        : AppFailure.server();
  }

  /// Classifies any thrown error into an [AppFailure].
  ///
  /// Passes existing [AppFailure]s through untouched; classifies raw
  /// [OperationException]s; string-matches everything else.
  static AppFailure from(Object? error) {
    if (error is AppFailure) return error;
    if (error is OperationException) return AppFailure.fromOperation(error);

    _logRaw(error);
    return _looksLikeNetwork(error?.toString() ?? '')
        ? AppFailure.network()
        : AppFailure.server();
  }

  static void _logRaw(Object? error) {
    if (kDebugMode && error != null) {
      debugPrint('[AppFailure] classified raw error: $error');
    }
  }

  @override
  String toString() => 'AppFailure($type): $title — $message';
}
