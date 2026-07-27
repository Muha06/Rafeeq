import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/presentation/widgets/seek_bar.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/show_audio_controls_bar_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';

class QuranAudioControlsBar extends ConsumerWidget {
  const QuranAudioControlsBar({
    super.key,
    required this.currentId,
    required this.onStart,
    required this.onPause,
    required this.autoOn,
    required this.onExit,
    required this.showSpeedControls,
  });
  final VoidCallback onStart;
  final String currentId;
  final VoidCallback onPause;
  final VoidCallback onExit;
  final bool showSpeedControls;
  final bool autoOn;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAudioControls = ref.watch(showAudioControlsProvider);

    return SafeArea(
      top: false,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        child: AudioControlsBarColorWrapper(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Audio
              const AudioControlsSection(),

              //show controls conditionally
              if (showSpeedControls) ...[
                if (showSpeedControls && showAudioControls)
                  const SizedBox(height: 8),

                AutoScrollControlsSection(
                  onStart: onStart,
                  onPause: onPause,
                  autoOn: autoOn,
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

    final isRepeatEnabled = audioState.isRepeatEnabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    audioState.title ?? '—',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
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
              icon: const Icon(HugeIconsSolid.previous),
            ),

            //Play/pause button
            IconButton(
              onPressed: audioState.isBuffering
                  ? null
                  : () => audioState.isPlaying ? ctrl.pause() : ctrl.play(),
              icon: Icon(
                audioState.isPlaying
                    ? HugeIconsStroke.pause
                    : HugeIconsStroke.play,
              ),
            ),

            //Repeat mode
            IconButton(
              onPressed: () {
                ctrl.toggleRepeatMode();

                AppSnackBar.showSimple(
                  context: context,
                  message: isRepeatEnabled
                      ? 'Repeat surah disabled'
                      : 'Repeat surah enabled',
                );
              },
              icon: Icon(
                HugeIconsStroke.repeat,
                color: isRepeatEnabled ? cs.primary : null,
              ),
            ),

            //Stop button
            IconButton(
              onPressed: () async {
                ref.read(showAudioControlsProvider.notifier).state = false;
                ctrl.stop();
              },
              icon: const Icon(PhosphorIcons.x),
            ),
            IconButton(
              onPressed: () async {
                await ctrl.next();
              },
              icon: const Icon(HugeIconsSolid.next),
            ),
          ],
        ),

        const SizedBox(height: 8),

        AudioSeekBar(
          position: audioState.position,
          buffered: audioState.bufferedPosition,
          duration: audioState.duration,
          onSeek: ctrl.seek,
        ),
      ],
    );
  }
}

class AutoScrollControlsSection extends ConsumerWidget {
  const AutoScrollControlsSection({
    super.key,
    required this.autoOn,
    required this.onStart,
    required this.onPause,
    required this.onExit,
  });

  final bool autoOn;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(surahSettingsProvider).autoScrollSpeed;
    final notifier = ref.read(surahSettingsProvider.notifier);

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
          onPressed: autoOn ? onPause : onStart,
          icon: Icon(autoOn ? Icons.pause : Icons.play_arrow),
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

    final gradientColors = [
      cs.surfaceContainerHighest.withAlpha(220),
      cs.surfaceContainerHighest.withAlpha(180),
      cs.surfaceContainerHighest.withAlpha(150),
      cs.surfaceContainerHighest.withAlpha(120),
      cs.surfaceContainerHighest.withAlpha(100),
      cs.surfaceContainerHighest.withAlpha(20),
      cs.surfaceContainerHighest.withAlpha(10),
    ];

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: child,
      ),
    );
  }
}
