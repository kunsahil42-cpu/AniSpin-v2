import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/connectivity_service.dart';

/// Singleton [ConnectivityService] for the whole app.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(service.dispose);
  return service;
});

/// Live online/offline status (interface up AND server reachable).
///
/// Watched by [AsyncNetworkView] to auto-recover error screens the moment
/// connectivity returns.
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).onlineStream();
});
