import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';

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

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 16, top: 6),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TOP ROW
            Row(
              children: [
                const Icon(Icons.graphic_eq, size: 18),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    audioState.title ?? 'Now playing',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

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

                //stop
                IconButton(
                  onPressed: () => ctrl.stop(),
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
