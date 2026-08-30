import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';

class AppDialogs {
  AppDialogs._();

  static Future<bool?> showConfirmDialog({
    required BuildContext context,
    String? title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) {
    final theme = Theme.of(context);

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
              ],

              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => AppNav.pop(dialogContext, true),
                  child: Text(confirmText),
                ),
              ),
              const SizedBox(height: 20),

              TextButton(
                onPressed: () => AppNav.pop(dialogContext, false),
                child: Text(cancelText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
