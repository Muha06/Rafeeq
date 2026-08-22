import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';

/// Draws a circular progress indicator using the Canvas.
class QuranProgressPainter extends CustomPainter {
  /// Progress from 0.0 to 1.0
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final String? label;
  final TextStyle? labelStyle;
  final double? strokeWidth;
  final double? progressWidth;

  QuranProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    this.strokeWidth,
    this.progressWidth,
    this.label,
    this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Paint object describes HOW we draw.
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth ?? 8
      ..style = PaintingStyle
          .stroke // fill bg?
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color =
          progressColor // Rafeeq brand colour
      ..strokeWidth = progressWidth ?? 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Center of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    // Radius with padding so stroke doesn't get clipped.
    final radius = size.width / 2 - 10;

    // Rectangle that contains our circle.
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw the full background circle.
    canvas.drawArc(rect, 0, math.pi * 2, false, backgroundPaint);

    // Flutter starts drawing at 3 o'clock.
    // We subtract 90° so it starts from the top.
    const startAngle = -math.pi / 2;

    // Convert progress (0-1) into radians.
    final sweepAngle = progress * math.pi * 2;

    // Draw the coloured progress.
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);

    if (label != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style:
              labelStyle ??
              const TextStyle(
                fontFamily: AppStrings.displayFont,
                fontSize: 22,
                height: 1,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final textOffset = Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      );

      textPainter.paint(canvas, textOffset);
    }
  }

  @override
  bool shouldRepaint(covariant QuranProgressPainter oldDelegate) {
    // Repaint only when progress changes.
    return oldDelegate.progress != progress;
  }
}
