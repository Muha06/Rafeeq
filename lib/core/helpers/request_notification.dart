import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/local_notifications/providers/general_notifications_provider.dart';
import 'package:rafeeq/core/helpers/app_dialogs.dart';

Future<void> checkNotificationPermission({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final notifier = ref.read(notificationPermissionProvider.notifier);

  await notifier.sync();

  final permissionState = ref.read(notificationPermissionProvider);

  if (!context.mounted || permissionState.notificationsAllowed) {
    return;
  }

  // Permission was permanently denied.
  if (permissionState.notifPermanentlyDenied) {
    final openSettings = await AppDialogs.showNotificationSettingsDialog(
      context: context,
    );

    if (openSettings == true) {
      await notifier.openSettings();
    }

    return;
  }

  // Permission can still be requested.
  final shouldRequest = await AppDialogs.showNotificationPermissionDialog(
    context: context,
  );

  if (shouldRequest == true) {
    await notifier.requestNotifications();
  }
}
