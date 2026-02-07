import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/general_notifications_provider.dart';

class NotificationsPermissionCta extends ConsumerStatefulWidget {
  const NotificationsPermissionCta({super.key});

  @override
  ConsumerState<NotificationsPermissionCta> createState() =>
      _NotificationsPermissionCtaState();
}

class _NotificationsPermissionCtaState
    extends ConsumerState<NotificationsPermissionCta> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(systemNotifAccessProvider.notifier).sync());
  }

  @override
  Widget build(BuildContext context) {
    final perm = ref.watch(systemNotifAccessProvider);
    final notifier = ref.watch(systemNotifAccessProvider.notifier);

    // ✅ Already granted
    if (perm.notificationsAllowed) {
      return ElevatedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_circle_rounded),
        label: const Text('Notifications Enabled'),
      );
    }

    // 🚫 Permanently denied
    if (perm.notifPermanentlyDenied) {
      return Column(
        children: [
          ElevatedButton.icon(
            onPressed: () async => notifier.openSettings(),
            icon: const Icon(Icons.settings_rounded),
            label: const Text('Open Settings'),
          ),
          const SizedBox(height: 8),
          Text(
            'Enable notifications in Settings to receive reminders.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withAlpha(120)),
          ),
        ],
      );
    }

    // 🙏 Requestable denied / not yet asked
    return ElevatedButton.icon(
      onPressed: perm.isLoading
          ? null
          : () async {
              await ref
                  .read(systemNotifAccessProvider.notifier)
                  .requestAll(includeExactAlarms: true);
            },

      icon: perm.isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.notifications_active_rounded),
      label: Text(perm.isLoading ? 'Enabling…' : 'Enable Notifications'),
    );
  }
}
