import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  AppToast._();

  static void showSimple({
    required BuildContext context,
    required String message,
    Alignment? alignment = Alignment.topCenter,

    Color? backgroundColor,
    Color? foregroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    toastification.dismissAll();

    toastification.show(
      context: context,
      alignment: alignment,
      autoCloseDuration: duration,
      showProgressBar: false,
      dragToClose: true,
      animationDuration: const Duration(milliseconds: 250),
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide.none,
      showIcon: false,
      backgroundColor: backgroundColor ?? cs.surfaceContainerHighest,
      foregroundColor: foregroundColor ?? cs.onSurface,
      title: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: foregroundColor ?? cs.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

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
                    vertical: 12,
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
    Alignment alignment = Alignment.center,
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
                    color: backgroundColor ?? cs.errorContainer,
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
