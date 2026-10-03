import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';

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
    final maxWidth = 86.0;

    return AppPressableScale(
      scale: 0.8,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: 250.ms,
                  height: 64,
                  decoration: BoxDecoration(
                    color: bgColor ?? cs.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Icon(
                        iconData,
                        size: 32,
                        color: fgColor ?? cs.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                SizedBox(
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
        ),
      ),
    );
  }
}
