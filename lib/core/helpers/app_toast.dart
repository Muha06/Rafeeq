import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  AppToast._();

  static void showCompact({
    required BuildContext context,
    required String message,
    Alignment alignment = Alignment.topCenter,
    Color? backgroundColor,
    Color? foregroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    toastification.dismissAll();

    toastification.showCustom(
      context: context,
      alignment: alignment,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 250),
      builder: (context, holder) {
        return SafeArea(
          child: Center(
            child: IntrinsicWidth(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? cs.onSurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: foregroundColor ?? cs.surface,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Alignment alignment = Alignment.topCenter,
    Color? backgroundColor,
    Color? foregroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    toastification.dismissAll();

    toastification.showCustom(
      context: context,
      alignment: alignment,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 250),
      builder: (context, holder) {
        return SafeArea(
          child: Center(
            child: IntrinsicWidth(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? cs.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: foregroundColor ?? cs.onSurface,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    Alignment alignment = Alignment.topCenter,
    Color? backgroundColor,
    Color? foregroundColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    toastification.dismissAll();

    toastification.showCustom(
      context: context,
      alignment: alignment,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 250),
      builder: (context, holder) {
        return SafeArea(
          child: Center(
            child: IntrinsicWidth(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? Colors.green,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: foregroundColor ?? cs.onError,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
