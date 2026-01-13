import 'package:flutter/material.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';

class AppSnackBar {
  static void showSimple({
    required BuildContext context,
    required bool isDark,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    final darkBg = AppLightColors.lightSurface;
    final lightBg = AppDarkColors.darkSurface;
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 3,
        backgroundColor: isDark ? darkBg : lightBg,
        content: Text(
          message,
          style: theme.textTheme.bodySmall!.copyWith(
            color: isDark
                ? AppLightColors.textPrimary
                : AppDarkColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        duration: duration,
      ),
    );
  }

  static void showAction({
    required BuildContext context,
    required bool isDark,
    required String message,
    required String actionLabel,
    required VoidCallback onAction,

    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    final darkBg = AppLightColors.lightSurface;
    final lightBg = AppDarkColors.darkSurface;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isDark ? darkBg : lightBg,
        persist: false,
        content: Text(
          message,
          style: theme.textTheme.bodySmall!.copyWith(
            color: isDark ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        action: SnackBarAction(
          label: actionLabel,
          textColor: AppDarkColors.iconSuccess,
          onPressed: onAction,
        ),
        duration: duration,
      ),
    );
  }
}
