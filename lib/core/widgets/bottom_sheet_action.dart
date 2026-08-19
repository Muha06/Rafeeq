import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    const width = 64.0;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      alignment: Alignment.topCenter,
      child: GestureDetector(
        onTap: onPressed,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: 250.ms,
              height: 64,
              width: width,
              decoration: BoxDecoration(
                color: bgColor ?? cs.surfaceContainerHigh,
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

            const SizedBox(height: 6),

            SizedBox(
              width: width + 12,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
