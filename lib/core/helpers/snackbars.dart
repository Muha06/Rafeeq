import 'package:flutter/material.dart';
import 'package:rafeeq/core/app_keys.dart';

class AppSnackBar {
  static void showSimple({
    required BuildContext context,
    required String message,
    Color? lightBgColor,
    Color? lightText,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);

    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.clearSnackBars();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        elevation: 3,
        persist: false,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(
          message,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
        duration: duration,
      ),
    );
  }

  static void showAction({
    required BuildContext context,
    bool? isDark,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,

    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.clearSnackBars();
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        shape: const Border(top: BorderSide()),
        persist: false,
        content: Text(
          message,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: cs.surfaceContainerLowest,
          ),
        ),
        action: SnackBarAction(
          label: actionLabel,
          textColor: cs.primary,
          onPressed: onAction,
        ),
        duration: duration,
      ),
    );
  }
}
