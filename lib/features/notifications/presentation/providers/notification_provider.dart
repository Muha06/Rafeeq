import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/notifications/domain/entities/app_notification.dart';
import 'package:rafeeq/features/notifications/presentation/providers/wiring_providers.dart';

class NotificationsController extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final repo = ref.read(notificationRepoProvider);
    return repo.getAllNotifications();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(notificationRepoProvider);
      return repo.getAllNotifications();
    });
  }

  Future<void> markAsRead(String id) async {
    final repo = ref.read(notificationRepoProvider);

    // 1. persist locally (Hive)
    await repo.markAsRead(id);

    // 2. update UI state instantly (NO REFETCH)
    if (state.value == null) return;

    final updated = state.value!.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    state = AsyncData(updated);
  }
}

final allNotificationsProvider =
    AsyncNotifierProvider.autoDispose<
      NotificationsController,
      List<AppNotification>
    >(NotificationsController.new);

final notificationByIdProvider = FutureProvider.family<AppNotification, String>(
  (ref, id) async {
    final repo = ref.read(notificationRepoProvider);
    return repo.getNotificationById(id);
  },
);
