import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AppStateView extends StatelessWidget {
  final PhosphorIconData? icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onPressed;
  final Color? foregroundColor;

  const AppStateView({
    super.key,
    this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.foregroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fg = foregroundColor ?? colors.onSurface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 Icon
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: PhosphorIcon(
                  icon!,
                  size: 32,
                  color: colors.onSurfaceVariant,
                ),
              ),

            const SizedBox(height: 20),

            //  Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: fg,
              ),
            ),

            const SizedBox(height: 8),

            // 🔥 Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: fg),
            ),

            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 20),

              // 🔥 Action Button
              FilledButton(onPressed: onPressed, child: Text(buttonText!)),
            ],
          ],
        ),
      ),
    );
  }
}
