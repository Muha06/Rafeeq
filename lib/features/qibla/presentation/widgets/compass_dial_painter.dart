import 'dart:math';
import 'package:flutter/material.dart';

class CompassCustomPainter extends CustomPainter {
  final double angle;
  final Color dialColor;
  final Color shadowColor;
  final Color tickColor;
  final Color strongTickColor;
  final Color northColor;

  const CompassCustomPainter({
    required this.angle,
    this.dialColor = Colors.white,
    this.shadowColor = const Color.fromRGBO(158, 158, 158, 0.2),
    this.tickColor = Colors.grey,
    this.strongTickColor = const Color(0xFF616161),
    this.northColor = Colors.red,
  });

  // Keeps rotating the North Red Triangle
  double get rotation => -angle * pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    // We scale all geometry from the actual widget size so the compass stays
    // proportionate whether it's shown on the full page or in a compact card.
    final outerRadius = size.width * 0.45;
    final outerShadowRadius = outerRadius + size.width * 0.03;
    final innerRadius = size.width * 0.32;
    final innerShadowRadius = innerRadius + size.width * 0.02;
    final lineInnerRadius = size.width * 0.26;
    final lineOuterRadius = size.width * 0.34;

    // Move the drawing origin to the center of the square canvas.
    // After this, positions are drawn relative to the center point.
    canvas.translate(size.width / 2, size.height / 2);

    // Base colors used for the compass body.
    final circle = Paint()
      ..strokeWidth = 2
      ..color = dialColor
      ..style = PaintingStyle.fill;

    final shadowCircle = Paint()
      ..strokeWidth = 2
      ..color = shadowColor
      ..style = PaintingStyle.fill;

    // Outer ring: a subtle shadow behind the main white dial.
    canvas.drawCircle(Offset.zero, outerShadowRadius, shadowCircle);
    canvas.drawCircle(Offset.zero, outerRadius, circle);

    // The main marks are drawn as radial lines from the center.
    final darkIndexLine = Paint()
      ..color = strongTickColor
      ..strokeWidth = max(2.0, size.width * 0.06)
      ..strokeCap = StrokeCap.round;

    final lightIndexLine = Paint()
      ..color = tickColor
      ..strokeWidth = max(1.0, size.width * 0.03)
      ..strokeCap = StrokeCap.round;

    // Red marker pointing to north.
    final northRedBrush = Paint()
      ..color = northColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = max(2.0, size.width * 0.04);

    // Rotate the canvas so the 0° reference line
    // aligns with the top of the dial.
    canvas.rotate(-pi / 2);

    // Light tick marks: 16 evenly spaced markers around the compass.
    for (int i = 1; i <= 16; i++) {
      final a = -(angle + 22.5 * i) * pi / 180;
      canvas.drawLine(
        Offset.fromDirection(a, lineInnerRadius),
        Offset.fromDirection(a, lineOuterRadius),
        lightIndexLine,
      );
    }

    // Stronger landmarks: 4 main directions, spaced 90° apart.
    for (int i = 1; i <= 3; i++) {
      final a = -(angle + 90 * i) * pi / 180;
      canvas.drawLine(
        Offset.fromDirection(a, lineInnerRadius),
        Offset.fromDirection(a, lineOuterRadius),
        darkIndexLine,
      );
    }

    // The red line is the actual north indicator. The `rotation` getter converts
    // the device heading into a visual angle on the dial.
    canvas.drawLine(
      Offset.fromDirection(rotation, lineInnerRadius),
      Offset.fromDirection(rotation, lineOuterRadius),
      northRedBrush,
    );

    // Inner circle to give a clean layered dial look.
    canvas.drawCircle(Offset.zero, innerShadowRadius, shadowCircle);
    canvas.drawCircle(Offset.zero, innerRadius, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
