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

    // Move the drawing origin to the center of the square canvas.
    // After this, positions are drawn relative to the center point.
    canvas.translate(size.width / 2, size.height / 2);

    // Rotate the canvas so the 0° reference line
    // aligns with the top of the dial.
    canvas.rotate(-pi / 2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
