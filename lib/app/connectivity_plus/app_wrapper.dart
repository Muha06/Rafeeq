import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/connectivity_plus/conectivity_plus_provider.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';

class AppWrapper extends ConsumerWidget {
  final Widget child;
  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for connectivity changes
    ref.listen<bool>(hasInternetConnection, (previous, next) {
      if (previous == true && next == false) {
        // Went offline
        AppToast.showCompact(
          context: context,
          message: 'You are offline',
          duration: const Duration(seconds: 3),
        );
      } else if (previous == false && next == true) {
        // Back online
        AppToast.showCompact(
          context: context,
          message: 'Back online 🎉',
          duration: const Duration(seconds: 3),
        );
      }
    });

    return Scaffold(body: Stack(children: [child]));
  }
}
