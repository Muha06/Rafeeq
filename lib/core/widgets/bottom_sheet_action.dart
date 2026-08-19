import 'package:flutter/material.dart';

class BottomSheetActionBtn extends StatelessWidget {
  const BottomSheetActionBtn({
    super.key,
    this.bgColor,
    this.fgColor,
    required this.iconData,
    required this.label,
    required this.onPressed,
  });

  final Color? bgColor;
  final Color? fgColor;
  final IconData iconData;
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Icon(
                  iconData,
                  size: 32,
                  color: fgColor ?? cs.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface),
        ),
      ],
    );
  }
}
