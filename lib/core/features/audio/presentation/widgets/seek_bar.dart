import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/is_seeking_provider.dart';

class AudioSeekBar extends ConsumerStatefulWidget {
  const AudioSeekBar({
    super.key,
    this.showDurations = true,
    this.baseTrackColor,
    this.bufferedTrackColor,
    this.playedTrackColor,
    this.durationColor,
  });

  final bool? showDurations;
  final Color? baseTrackColor;
  final Color? bufferedTrackColor;
  final Color? playedTrackColor;
  final Color? durationColor;

  @override
  ConsumerState<AudioSeekBar> createState() => _AudioSeekBarState();
}

class _AudioSeekBarState extends ConsumerState<AudioSeekBar> {
  double? _dragValueMs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final ctrl = ref.read(audioControllerProvider.notifier);

    final position = ref.watch(
      audioControllerProvider.select((s) => s.position),
    );
    final buffered = ref.watch(
      audioControllerProvider.select((s) => s.bufferedPosition),
    );

    final duration = ref.watch(
      audioControllerProvider.select((s) => s.duration),
    );

    // Avoid divide-by-zero and give Slider a valid non-zero max.
    final totalMs = duration.inMilliseconds <= 0
        ? 1.0
        : duration.inMilliseconds.toDouble();

    // While dragging, we render the temporary thumb position immediately
    // instead of waiting for the audio engine to report the new position back.
    final effectivePositionMs =
        (_dragValueMs ?? position.inMilliseconds.toDouble()).clamp(
          0.0,
          totalMs,
        );

    // The buffered track is rendered separately behind the slider so it remains
    // visible instead of being painted over by the Slider's built-in track.
    final bufferedMs = buffered.inMilliseconds.toDouble().clamp(0.0, totalMs);

    final playedFraction = effectivePositionMs / totalMs;
    final bufferedFraction = bufferedMs / totalMs;

    final durationsStyle = theme.textTheme.bodySmall?.copyWith(
      color: widget.durationColor ?? cs.onSurface,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Base track for the full media duration.
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color:
                      widget.baseTrackColor ??
                      cs.onSurfaceVariant.withAlpha(100),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),

              // Buffered track shows how much data is ready to play ahead.
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: bufferedFraction.clamp(0.0, 1.0),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                          widget.bufferedTrackColor ??
                          cs.onSurface.withAlpha(80),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),

              // Played track sits on top so playback progress is always clear.
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: playedFraction.clamp(0.0, 1.0),
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: widget.playedTrackColor ?? cs.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),

              // The Slider is used only for thumb + drag interaction.
              // Its tracks are transparent because we already paint them above.
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  secondaryActiveTrackColor: Colors.transparent,
                  overlayColor: cs.primary.withAlpha(35),
                  thumbColor: cs.primary,
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 0,
                    elevation: 0,
                    pressedElevation: 0,
                    disabledThumbRadius: 0,
                  ),
                ),
                child: Slider(
                  value: effectivePositionMs.clamp(0.0, totalMs),
                  min: 0,
                  max: totalMs,
                  onChangeStart: (value) {
                    setState(() {
                      _dragValueMs = value;
                    });

                    /// Update local provider instead of AudioState to prevent
                    /// repeated calling the provider & API
                    ref.read(isSeekingAudioProvider.notifier).state = true;
                  },
                  // Update the thumb immediately while the user drags.
                  onChanged: (value) {
                    setState(() {
                      _dragValueMs = value;
                    });
                  },
                  // Commit the seek once the user releases the thumb.
                  onChangeEnd: (value) {
                    setState(() {
                      _dragValueMs = null;
                    });

                    ref.read(isSeekingAudioProvider.notifier).state = false;
                    ctrl.seek(Duration(milliseconds: value.round()));
                  },
                ),
              ),
            ],
          ),
        ),

        if (widget.showDurations == true) ...[
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // While dragging, show the temporary position to match the thumb.
              Text(
                _format(Duration(milliseconds: effectivePositionMs.round())),
                style: durationsStyle,
              ),
              Text(_format(duration), style: durationsStyle),
            ],
          ),
        ],
      ],
    );
  }

  String _format(Duration d) {
    final totalSeconds = d.inSeconds;
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    // Switch to hh:mm:ss automatically for longer audio.
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
