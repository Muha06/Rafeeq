import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/connectivity_plus/conectivity_plus_provider.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AppWrapper extends ConsumerWidget {
  final Widget child;
  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for connectivity changes
    ref.listen<bool>(connectivityProvider, (previous, next) {
      if (previous == true && next == false) {
        // Went offline
        AppSnackBar.showSimple(
          context: context,
          isDark: ref.read(isDarkProvider),
          message: 'You are offline',
          duration: const Duration(seconds: 7),
        );
      } else if (previous == false && next == true) {
        // Back online
        AppSnackBar.showSimple(
          context: context,
          isDark: ref.read(isDarkProvider),
          message: 'Back online 🎉',
          duration: const Duration(seconds: 7),
        );
      }
    });

    return Stack(children: [child]);
  }
}
