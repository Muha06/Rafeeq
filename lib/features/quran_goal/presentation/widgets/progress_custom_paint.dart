import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Draws a circular progress indicator using the Canvas.
class QuranProgressPainter extends CustomPainter {
  /// Progress from 0.0 to 1.0
  final double progress;

  QuranProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Paint object describes HOW we draw.
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color =
          const Color(0xFF27687E) // Rafeeq brand colour
      ..strokeWidth = 10
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
  }

  @override
  bool shouldRepaint(covariant QuranProgressPainter oldDelegate) {
    // Repaint only when progress changes.
    return oldDelegate.progress != progress;
  }
}
