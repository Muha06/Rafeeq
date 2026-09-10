import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/local_notifications/providers/general_notifications_provider.dart';
import 'package:rafeeq/core/helpers/app_dialogs.dart';

Future<void> showNotificationPermissionDialog({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final notifier = ref.read(notificationPermissionProvider.notifier);

  await notifier.sync();

  final permissionState = ref.read(notificationPermissionProvider);

  if (!context.mounted || permissionState.notificationsAllowed) {
    debugPrint(
      "No permission dialog: Permission allowed: ${permissionState.notificationsAllowed}",
    );
    return;
  }

  if (permissionState.notifPermanentlyDenied) {
    return;
  }

  final shouldRequest = await AppDialogs.showNotificationPermissionDialog(
    context: context,
  );

  if (shouldRequest != true || !context.mounted) {
    return;
  }
 
  await notifier.requestNotifications();
}
