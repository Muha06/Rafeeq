import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/presentation/widgets/seek_bar.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/log_ayah_bottomsheet.dart';

class QuranAudioControlsBar extends ConsumerWidget {
  const QuranAudioControlsBar({
    super.key,
    required this.currentId,
    required this.onStart,
    required this.onPause,
    required this.onExit,
  });
  final VoidCallback onStart;
  final String currentId;
  final VoidCallback onPause;
  final VoidCallback onExit;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAudioControls = ref
        .watch(surahSettingsProvider)
        .showAudioControls;

    final showAutoScrollControls = ref
        .watch(surahSettingsProvider)
        .showAutoScrollControls;

    return SafeArea(
      top: false,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        child: AudioControlsBarColorWrapper(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Audio
              if (showAudioControls) const AudioControlsSection(),

              //show controls conditionally
              if (showAutoScrollControls) ...[
                const SizedBox(height: 8),

                AutoScrollControlsSection(
                  onStart: onStart,
                  onPause: onPause,
                  onExit: onExit,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AudioControlsSection extends ConsumerWidget {
  const AudioControlsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final audioState = ref.watch(audioControllerProvider);
    final ctrl = ref.read(audioControllerProvider.notifier);
    final selectedReciter = ref.watch(selectedReciterProvider);

    final prevNextIconSize = 24.0;
    final prevNextIconColor = cs.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            // stop btn
            GestureDetector(
              onTap: () async {
                ref
                    .read(surahSettingsProvider.notifier)
                    .showAudioControls(false);
                ctrl.stop();
              },
              child: const Icon(HugeIconsStroke.cancel01, size: 18),
              // visualDensity: VisualDensity.compact,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audioState.title ?? '—',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.onSurface,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    selectedReciter.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () async {
                await ctrl.previous();
              },
              icon: Icon(
                HugeIconsStroke.previous,
                size: prevNextIconSize,
                color: prevNextIconColor,
              ),
            ),

            //Play/pause button
            CircleIconButton(
              onPressed: audioState.isBuffering
                  ? null
                  : () => audioState.isPlaying ? ctrl.pause() : ctrl.play(),
              icon: audioState.isPlaying
                  ? HugeIconsStroke.pause
                  : HugeIconsStroke.play,
            ),

            IconButton(
              onPressed: () async {
                await ctrl.next();
              },
              icon: Icon(
                HugeIconsStroke.next,
                size: prevNextIconSize,
                color: prevNextIconColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        AudioSeekBar(onSeek: ctrl.seek, showDurations: false),
      ],
    );
  }
}

class AutoScrollControlsSection extends ConsumerWidget {
  const AutoScrollControlsSection({
    super.key,
    required this.onStart,
    required this.onPause,
    required this.onExit,
  });

  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(surahSettingsProvider).autoScrollSpeed;
    final notifier = ref.read(surahSettingsProvider.notifier);
    final isAutoScrolling = ref.watch(surahSettingsProvider).isAutoScrolling;

    return Row(
      children: [
        IconButton(onPressed: onExit, icon: const Icon(Icons.close)),

        const Spacer(),

        IconButton(
          onPressed: notifier.decreaseSpeed,
          icon: const Icon(Icons.remove),
        ),

        Text('${speed.toStringAsFixed(1)}x'),

        IconButton(
          onPressed: notifier.increaseSpeed,
          icon: const Icon(Icons.add),
        ),

        const Spacer(),

        IconButton(
          onPressed: isAutoScrolling ? onPause : onStart,
          icon: Icon(isAutoScrolling ? Icons.pause : Icons.play_arrow),
        ),
      ],
    );
  }
}

class AudioControlsBarColorWrapper extends StatelessWidget {
  const AudioControlsBarColorWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: child,
      ),
    );
  }
}
