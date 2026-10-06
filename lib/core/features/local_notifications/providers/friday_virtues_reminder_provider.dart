import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/local_notifications/providers/general_notifications_provider.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/features/user/presentation/providers/user_provider.dart';

final fridayVirtuesReminderProvider =
    NotifierProvider<FridayVirtuesReminderNotifier, void>(
      FridayVirtuesReminderNotifier.new,
    );

class FridayVirtuesReminderNotifier extends Notifier<void> {
  @override
  void build() {}

  void schedule() {
    final username = ref.read(userNameProvider);
    if (!ref.read(notificationPermissionProvider).notificationsAllowed) {
      return;
    }

    ref
        .read(localNotificationServiceProvider)
        .scheduleFridayVirtuesReminder(username: username);
  }
}
