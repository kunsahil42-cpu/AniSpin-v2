import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

/// Global connectivity + real reachability.
///
/// [connectivity_plus] only tells us whether a network *interface* is up
/// (wifi/mobile). That is not the same as "the internet works" — a captive
/// portal or a dead link both report an active interface. So on top of the
/// interface check we run a lightweight reachability probe against a couple of
/// fast, reliable endpoints before reporting `online == true`.
class ConnectivityService {
  ConnectivityService({http.Client? client})
      : _client = client ?? http.Client();

  final Connectivity _connectivity = Connectivity();
  final http.Client _client;

  /// Endpoints used to confirm real internet access. The first is a tiny
  /// 204-no-content endpoint; the second is the actual API host as a fallback.
  static const List<String> _probeUrls = [
    'https://www.gstatic.com/generate_204',
    'https://graphql.anilist.co',
  ];

  static const Duration _probeTimeout = Duration(seconds: 4);

  /// True only when an interface is up AND a probe endpoint is reachable.
  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    if (_hasNoInterface(results)) return false;
    return _hasRealInternet();
  }

  /// Emits the current status immediately, then re-probes whenever the
  /// network interface changes (connect/disconnect/switch).
  Stream<bool> onlineStream() async* {
    yield await isOnline();
    await for (final results in _connectivity.onConnectivityChanged) {
      if (_hasNoInterface(results)) {
        yield false;
      } else {
        yield await _hasRealInternet();
      }
    }
  }

  bool _hasNoInterface(List<ConnectivityResult> results) {
    return results.isEmpty || results.every((r) => r == ConnectivityResult.none);
  }

  Future<bool> _hasRealInternet() async {
    for (final url in _probeUrls) {
      try {
        final response =
            await _client.get(Uri.parse(url)).timeout(_probeTimeout);
        // Any non-server-error response means we reached the internet.
        if (response.statusCode < 500) return true;
      } catch (_) {
        // Try the next probe URL.
      }
    }
    return false;
  }

  void dispose() => _client.close();
}
