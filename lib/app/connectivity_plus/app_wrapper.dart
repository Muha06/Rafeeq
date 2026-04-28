import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/connectivity_plus/conectivity_plus_provider.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/widgets/global_mini_player.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';

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
          message: 'You are offline',
          duration: const Duration(seconds: 7),
        );
      } else if (previous == false && next == true) {
        // Back online
        AppSnackBar.showSimple(
          context: context,
          message: 'Back online 🎉',
          duration: const Duration(seconds: 7),
        );
      }
    });

    final s = ref.watch(audioControllerProvider);
    final miniPlayer = AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: s.currentId != null
          ? const GLobalMiniPlayerSheet()
          : const SizedBox.shrink(),
    );

    return Scaffold(
      body: Stack(
        children: [
          child,

          //Mini player
          Positioned(left: 0, right: 0, bottom: 72, child: miniPlayer),
        ],
      ),
    );
  }
}
