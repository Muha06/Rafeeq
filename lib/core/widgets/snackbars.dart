import 'package:flutter/material.dart';
import 'package:rafeeq/core/app_keys.dart';
 import 'package:rafeeq/features/adhkar/presentation/widgets/audio_player_sheet.dart';

class AppSnackBar {
  static void showSimple({
    required BuildContext context,
    required bool isDark,
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
         content: Text(
          message,
          style: theme.textTheme.bodySmall!.copyWith(
            
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
 
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
         shape: const Border(
          top: BorderSide(
           ),
        ),
        persist: false,
        content: Text(
          message,
          style: theme.textTheme.bodySmall!.copyWith(
             fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        action: SnackBarAction(
          label: actionLabel,
           onPressed: onAction,
        ),
        duration: duration,
      ),
    );
  }

  //show player
  static void showPlayer() {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        persist: true,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.all(12),
        content: AdhkarMiniPlayerSheet(),
        dismissDirection: DismissDirection.none,
      ),
    );
  }

  static void hideSnackbars() {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }
}
