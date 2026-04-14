import 'package:flutter/material.dart';
 
class MyChip extends StatelessWidget {
  const MyChip({
    super.key,
    required this.child,
    this.borderRadius = 12,
    this.foregroundColor,
    this.backgroundColor,
  });
  final Widget child;
  final double? borderRadius;
  final Color? foregroundColor;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor ?? cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      child: child,
    );
  }
}
