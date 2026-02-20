import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = NotifierProvider<ConnectivityNotifier, bool>(
  ConnectivityNotifier.new,
);

class ConnectivityNotifier extends Notifier<bool> {
  @override
  bool build() {
    final connectivity = Connectivity();

    // Initial check
    _checkInitial(connectivity);

    // Listen to changes (v6+ returns List<ConnectivityResult>)
    final sub = connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);

      state = hasConnection;
    });

    ref.onDispose(sub.cancel);

    return true;
  }

  Future<void> _checkInitial(Connectivity connectivity) async {
    final results = await connectivity.checkConnectivity();

    state = results.any((r) => r != ConnectivityResult.none);
  }
}
