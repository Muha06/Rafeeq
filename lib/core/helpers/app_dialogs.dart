import 'package:flutter/material.dart';
import 'package:hugeicons_pro/hugeicons.dart';
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

  static Future<bool?> showNotificationPermissionDialog({
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                HugeIconsStroke.notification01,
                size: 52,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Never miss a reminder  💖',
                textAlign: TextAlign.center,
                style: tt.headlineSmall,
              ),
              const SizedBox(height: 10),

              Text(
                'Allow notifications so Rafeeq can remind you about Salah, '
                'Friday reminders, and other important moments.',
                textAlign: TextAlign.center,
                style: tt.bodyMedium,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => AppNav.pop(dialogContext, true),
                  child: const Text('Allow notifications'),
                ),
              ),
              const SizedBox(height: 24),

              TextButton(
                onPressed: () => AppNav.pop(dialogContext, false),
                child: const Text('Not now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
