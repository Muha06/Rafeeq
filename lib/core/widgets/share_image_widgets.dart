// core/widgets/share_card_parts.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/app_assets.dart';

/// Tiled 8-point star (two overlapping squares).
class StarPatternPainter extends CustomPainter {
  StarPatternPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const cell = 72.0;
    const r = cell * 0.36;

    for (double y = 0; y <= size.height + cell; y += cell) {
      for (double x = 0; x <= size.width + cell; x += cell) {
        final c = Offset(x, y);
        canvas.drawRect(Rect.fromCircle(center: c, radius: r), paint);

        canvas.save();
        canvas.translate(c.dx, c.dy);
        canvas.rotate(math.pi / 4);
        canvas.drawRect(Rect.fromCircle(center: Offset.zero, radius: r), paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant StarPatternPainter old) => old.color != color;
}

class OrnamentDivider extends StatelessWidget {
  const OrnamentDivider({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget line() => Expanded(
      child: Container(height: 1, color: color.withValues(alpha: 0.5)),
    );

    return Row(
      children: [
        const SizedBox(width: 40),
        line(),
        const SizedBox(width: 12),
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(width: 10, height: 10, color: color),
        ),
        const SizedBox(width: 12),
        line(),
        const SizedBox(width: 40),
      ],
    );
  }
}

class ShareCardFooter extends StatelessWidget {
  const ShareCardFooter({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(AppAssets.appIcon, height: 30, width: 30),
            ),
            const SizedBox(width: 8),
            Text(
              'Rafeeq',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Your Islamic companion',
          style: TextStyle(fontSize: 14, color: color.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}
