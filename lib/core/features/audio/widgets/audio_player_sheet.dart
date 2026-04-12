import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/widgets/seek_bar.dart';

class AdhkarMiniPlayerSheet extends ConsumerWidget {
  const AdhkarMiniPlayerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final audioState = ref.watch(audioControllerProvider);
    final ctrl = ref.read(audioControllerProvider.notifier);

    final isPlaying = audioState.isPlaying;
    final isBuffering = audioState.isBuffering;

    ref.listen(audioControllerProvider, (previous, next) {
      final prevId = previous?.currentId;

      if (next.currentId != prevId) {
        scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      }
    });

    final currentPosition = audioState.position;
    final bufferedPosition = audioState.bufferedPosition;
    final duration = audioState.duration;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(PhosphorIcons.playlist()),
                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    audioState.title ?? 'Now playing',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Progress bar
            AudioSeekBar(
              position: currentPosition,
              buffered: bufferedPosition,
              duration: duration,
              onSeek: (position) => ctrl.seek(position),
            ),
            const SizedBox(height: 8),

            // Controls
            Row(
              children: [
                Text(
                  isBuffering ? 'Buffering…' : 'Tap pause anytime',
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: isBuffering
                      ? null
                      : () => isPlaying ? ctrl.pause() : ctrl.play(),

                  icon: isBuffering
                      ? const CupertinoActivityIndicator()
                      : Icon(
                          isPlaying
                              ? PhosphorIcons.pause()
                              : PhosphorIcons.play(),
                        ),
                ),
                IconButton(
                  onPressed: () async {
                    await ctrl.stop();
                  },

                  icon: Icon(PhosphorIcons.x()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
