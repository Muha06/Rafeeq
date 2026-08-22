import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';

class AppSheets {
  AppSheets._();

  // ---------------------------
  // BASE BOTTOM SHEET
  // ---------------------------
  static Future<T?> showBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool useSafeArea = true,
    double borderRadius = 24,
    Duration? animationDuration = const Duration(milliseconds: 300),
    Duration? reverseAnimationDuration = const Duration(milliseconds: 400),
    Clip? clipBehavior = Clip.hardEdge,
  }) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: useSafeArea,
      isScrollControlled: isScrollControlled,
      showDragHandle: false,
      enableDrag: true,
      clipBehavior: clipBehavior,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
        duration: animationDuration,
        reverseDuration: reverseAnimationDuration,
      ),
      isDismissible: true,
      builder: (context) {
        return child;
      },
    );
  }

  // ---------------------------
  // CONFIRMATION SHEET
  // ---------------------------
  static Future<void> showConfirmSheet({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onConfirm,
    bool useSafeArea = true,
    String confirmText = "Confirm",
    String cancelText = "Cancel",
    bool destructive = false,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return showModalBottomSheet(
      useSafeArea: useSafeArea,
      context: context,
      useRootNavigator: false,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(22),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: destructive ? cs.error : cs.onSurfaceVariant,
                  size: 48,
                ),

                const SizedBox(height: 8),
              ],

              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: theme.filledButtonTheme.style?.copyWith(
                        backgroundColor: WidgetStatePropertyAll(
                          destructive ? cs.error : cs.primary,
                        ),
                      ),
                      onPressed: () {
                        onConfirm();
                      },
                      child: Text(
                        confirmText,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: destructive ? cs.onError : cs.onPrimary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => AppNav.pop(context),
                      child: Text(cancelText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------
  // MINIMAL CENTER DIALOG
  // ---------------------------
  static Future<void> showDialogBox({
    required BuildContext context,
    required String title,
    required String description,
    String buttonText = "OK",
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> showErrorDialog({
    required BuildContext context,
    String? title,
    required String message,
    String buttonText = "OK",
    final bool useRootNavigator = true,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: cs.error, size: 40),

              const SizedBox(height: 12),

              if (title != null)
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
              const SizedBox(height: 12),

              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => AppNav.pop(context),
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
