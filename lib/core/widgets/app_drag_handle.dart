import 'package:flutter/material.dart';

class AppDragHandle extends StatelessWidget {
  const AppDragHandle({
    super.key,
    this.width = 40,
    this.height = 5,
    this.margin = const EdgeInsets.symmetric(vertical: 12),
    this.color,
    this.radius = 999,
  });

  final double width;
  final double height;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? theme.colorScheme.onSurface.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
