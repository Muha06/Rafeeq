import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/local_notifications/providers/general_notifications_provider.dart';
import 'package:rafeeq/features/onboarding/presentation/widgets/permission_cta.dart';
import 'package:rafeeq/features/settings/presentation/provider/notiffications_controller.dart';

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
    Future.microtask(
      () => ref.read(notificationPermissionProvider.notifier).sync(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final perm = ref.watch(notificationPermissionProvider);
    final notifier = ref.read(notificationPermissionProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    // ✅ Already granted
    if (perm.notificationsAllowed) {
      return const PermissionCta(
        icon: Icon(Icons.check_circle_rounded, color: Colors.green),
        title: 'Notifications Enabled',
        subtitle: "You'll receive Salah and other reminders",
        onTap: null,
      );
    }

    // 🚫 Permanently denied
    if (perm.notifPermanentlyDenied) {
      return PermissionCta(
        icon: Icon(Icons.notifications_paused, color: cs.primary),
        title: 'Enable notifications in Settings',
        subtitle: "Allow notifications to receive salah and adhkar reminders.",
        onTap: () async => notifier.openSettings(),
      );
    }

    // 🙏 Requestable denied / not yet asked
    return PermissionCta(
      icon: const Icon(Icons.notifications_active_rounded),
      title: perm.isLoading ? 'Enabling…' : 'Enable Notifications',
      subtitle: "Never miss salah reminders and important updates.",
      onTap: perm.isLoading
          ? null
          : () async {
              final permitted = await ref
                  .read(notificationPermissionProvider.notifier)
                  .requestAll(includeExactAlarms: true);

              //Auto toggle reminders
              final controller = ref.read(
                salahNotifControllerProvider.notifier,
              );
              final adhkarController = ref.read(
                adhkarNotifControllerProvider.notifier,
              );

              if (permitted) {
                await controller.toggleSalahReminders(
                  true,
                  showSnack: false,
                  context,
                );
                await adhkarController.toggleAdhkarReminders(
                  true,
                  showSnack: false,
                  context,
                );
              }
            },
    );
  }
}
