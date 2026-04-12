import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/widgets/seek_bar.dart';
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
    required this.showAudioControls,
    required this.showSpeedControls,
  });
  final VoidCallback onStart;
  final String currentId;
  final VoidCallback onPause;
  final VoidCallback onExit;
  final bool showAudioControls;
  final bool showSpeedControls;
  final bool autoOn;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final gradientColors = [
      cs.surfaceContainerHighest.withAlpha(220),
      cs.surfaceContainerHighest.withAlpha(180),
      cs.surfaceContainerHighest.withAlpha(150),
      cs.surfaceContainerHighest.withAlpha(120),
      cs.surfaceContainerHighest.withAlpha(100),
      cs.surfaceContainerHighest.withAlpha(20),
      cs.surfaceContainerHighest.withAlpha(10),
    ];

    final audioState = ref.watch(audioControllerProvider);
    final ctrl = ref.read(audioControllerProvider.notifier);
    final buffering = audioState.isBuffering;
    final isRepeatEnabled = audioState.isRepeatEnabled;

    // final isCurrent = audioState.currentId == currentId;
    final isPlaying = audioState.isPlaying;

    final currentPosition = audioState.position;
    final bufferedPosition = audioState.bufferedPosition;
    final duration = audioState.duration;

    final selectedReciter = ref.watch(selectedReciterProvider);

    return SafeArea(
      top: false,
      child: Container(
        // height: 72,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showAudioControls) ...[
              //Audio
              Row(
                children: [
                  /// Surah Info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          audioState.title ?? '—',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedReciter.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Play / Pause Button
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: buffering
                        ? null
                        : () {
                            isPlaying ? ctrl.pause() : ctrl.play();
                          },

                    icon: Icon(
                      isPlaying
                          ? PhosphorIcons.pause(PhosphorIconsStyle.light)
                          : PhosphorIcons.play(PhosphorIconsStyle.light),
                    ),
                  ),

                  /// Repeat Button
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
                      PhosphorIcons.repeat(PhosphorIconsStyle.light),
                      color: isRepeatEnabled ? cs.primary : null,
                    ),
                    tooltip: isRepeatEnabled
                        ? 'Repeat surah is on'
                        : 'Repeat surah is off',
                  ),

                  /// Close Button
                  IconButton(
                    onPressed: () async {
                      //hide bar
                      ref.read(showAudioControlsProvider.notifier).state =
                          false;

                      // stop + close
                      await ctrl.stop();
                    },
                    icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.light)),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              //seek bar
              AudioSeekBar(
                position: currentPosition,
                buffered: bufferedPosition,
                duration: duration,
                onSeek: (position) => ctrl.seek(position),
              ),

              const SizedBox(height: 4),
            ],

            //show controls conditionally
            if (showSpeedControls) ...[
              if (showSpeedControls && showAudioControls)
                const SizedBox(height: 8),

              AutoScrollBar(
                onStart: onStart,
                onPause: onPause,
                autoOn: autoOn,
                onExit: onExit,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AutoScrollBar extends ConsumerWidget {
  const AutoScrollBar({
    super.key,
    required this.onStart,
    required this.onPause,
    required this.autoOn,
    required this.onExit,
  });

  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onExit;
  final bool autoOn;
  @override
  Widget build(BuildContext context, ref) {
    final speed = ref.watch(surahSettingsProvider).autoScrollSpeed;
    final surahSettingsNotifier = ref.watch(surahSettingsProvider.notifier);

    final fontSize = 20.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //exit speed
        IconButton(
          onPressed: onExit,
          icon: PhosphorIcon(PhosphorIcons.x(), size: fontSize),
        ),

        Expanded(
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //reduce speed
                IconButton(
                  onPressed: () {
                    surahSettingsNotifier.decreaseSpeed();
                  },
                  icon: PhosphorIcon(PhosphorIcons.minus(), size: fontSize),
                ),

                const SizedBox(width: 8),

                Text('${speed.toStringAsFixed(1)}x'),

                const SizedBox(width: 8),

                //increase speed
                IconButton(
                  onPressed: () {
                    surahSettingsNotifier.increaseSpeed();
                  },
                  icon: PhosphorIcon(PhosphorIcons.plus(), size: fontSize),
                ),
              ],
            ),
          ),
        ),

        //pause
        IconButton(
          onPressed: autoOn ? onPause : onStart,
          icon: PhosphorIcon(
            autoOn ? PhosphorIcons.pause() : PhosphorIcons.play(),
            size: fontSize,
          ),
        ),
      ],
    );
  }
}
