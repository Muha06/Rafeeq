import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass_v2/flutter_compass_v2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/features/qibla/presentation/providers/qibla_direction.dart';
import 'package:rafeeq/features/qibla/presentation/widgets/compass_dial_painter.dart';

class QiblaCompass extends ConsumerStatefulWidget {
  const QiblaCompass({
    super.key,
    this.size = 300,
    this.showInstruction = true,
    this.enableHaptics = true,
  });

  final double size;
  final bool showInstruction;
  final bool enableHaptics;

  @override
  ConsumerState<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends ConsumerState<QiblaCompass> {
  bool _wasFacingQibla = false;

  bool isFacingQibla(double direction, double qiblaDirection) {
    final difference = (qiblaDirection - direction).abs();

    final shortestDifference = difference > 180 ? 360 - difference : difference;

    return shortestDifference < 5;
  }

  String getQiblaInstruction(double direction, double qiblaDirection) {
    final difference = (qiblaDirection - direction + 540) % 360 - 180;

    if (difference.abs() <= 5) {
      return "You're facing Qibla 😍";
    }

    return difference > 0
        ? 'Turn right ${difference.abs().toStringAsFixed(0)}°'
        : 'Turn left ${difference.abs().toStringAsFixed(0)}°';
  }

  void _checkQibla(double direction, double qiblaDirection) {
    if (!widget.enableHaptics) return;

    final facing = isFacingQibla(direction, qiblaDirection);

    if (facing && !_wasFacingQibla && widget.enableHaptics) {
      AppHaptics.heavy();
    }

    _wasFacingQibla = facing;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final qiblaDirection = ref.watch(qiblaDirectionProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxAvailableSize = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : widget.size;

        final compassSize = min(widget.size, maxAvailableSize);

        return StreamBuilder<CompassEvent>(
          stream: FlutterCompass.events,
          builder: (context, snapshot) {
            final direction = snapshot.data?.heading;

            final hasCompassData = direction != null;

            // We only check Qibla when we have a real
            // device heading.
            if (hasCompassData) {
              _checkQibla(direction, qiblaDirection);
            }

            final currentDirection = direction ?? 0.0;

            final isFacing =
                hasCompassData &&
                isFacingQibla(currentDirection, qiblaDirection);

            final dialColor = isFacing
                ? Colors.greenAccent
                : cs.surfaceContainerHigh;

            final compass = SizedBox(
              width: compassSize,
              height: compassSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size.square(compassSize),
                    painter: CompassCustomPainter(
                      angle: currentDirection,
                      dialColor: dialColor,
                      shadowColor: cs.shadow,
                      tickColor: cs.surfaceContainerHighest,
                      strongTickColor: cs.surfaceContainerLowest,
                      northColor: cs.error,
                    ),
                  ),

                  // Qibla / Kaaba
                  Transform.rotate(
                    angle: -2 * pi * (currentDirection / 360),
                    child: Transform.rotate(
                      angle: qiblaDirection * pi / 180,
                      child: Image.asset(
                        'assets/images/qibla/prayer-mat.png',
                        width: compassSize * 0.33,
                      ),
                    ),
                  ),

                  // Qibla arrow
                  SizedBox(
                    width: compassSize * 0.82,
                    height: compassSize * 0.82,
                    child: Transform.rotate(
                      angle: -2 * pi * (currentDirection / 360),
                      child: Transform.rotate(
                        angle: qiblaDirection * pi / 180,
                        child: Align(
                          alignment: const Alignment(0, -1.2),
                          child: Icon(
                            Icons.expand_less_outlined,
                            color: cs.error,
                            size: compassSize * 0.13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (!widget.showInstruction) {
              return compass;
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                compass,
                const SizedBox(height: 12),
                Text(
                  getQiblaInstruction(currentDirection, qiblaDirection),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isFacing ? Colors.green : cs.onSurface,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
