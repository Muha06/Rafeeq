import 'package:flutter/material.dart';

class AudioSeekBar extends StatefulWidget {
  const AudioSeekBar({
    super.key,
    required this.position,
    required this.buffered,
    required this.duration,
    required this.onSeek,
  });

  final Duration position;
  final Duration buffered;
  final Duration duration;
  final void Function(Duration position) onSeek;

  @override
  State<AudioSeekBar> createState() => _AudioSeekBarState();
}

class _AudioSeekBarState extends State<AudioSeekBar> {
  double? _dragValueMs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Avoid divide-by-zero and give Slider a valid non-zero max.
    final totalMs = widget.duration.inMilliseconds <= 0
        ? 1.0
        : widget.duration.inMilliseconds.toDouble();

    // While dragging, we render the temporary thumb position immediately
    // instead of waiting for the audio engine to report the new position back.
    final effectivePositionMs =
        (_dragValueMs ?? widget.position.inMilliseconds.toDouble()).clamp(
          0.0,
          totalMs,
        );

    // The buffered track is rendered separately behind the slider so it remains
    // visible instead of being painted over by the Slider's built-in track.
    final bufferedMs = widget.buffered.inMilliseconds.toDouble().clamp(
      0.0,
      totalMs,
    );

    final playedFraction = effectivePositionMs / totalMs;
    final bufferedFraction = bufferedMs / totalMs;

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
                  color: cs.onSurfaceVariant.withAlpha(100),
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
                      color: cs.onSurface.withAlpha(80),
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
                      color: cs.primary,
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
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 7.5,
                    elevation: 0,
                    pressedElevation: 0,
                    disabledThumbRadius: 4,
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
                    widget.onSeek(Duration(milliseconds: value.round()));
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // While dragging, show the temporary position to match the thumb.
            Text(
              _format(Duration(milliseconds: effectivePositionMs.round())),
              style: theme.textTheme.bodySmall,
            ),
            Text(_format(widget.duration), style: theme.textTheme.bodySmall),
          ],
        ),
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
