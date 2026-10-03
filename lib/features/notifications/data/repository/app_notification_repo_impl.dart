import 'package:rafeeq/features/notifications/data/datasources/app_notifications_remote_ds.dart';
import 'package:rafeeq/features/notifications/data/datasources/notifications_local_ds.dart';
import 'package:rafeeq/features/notifications/domain/entities/app_notification.dart';
import 'package:rafeeq/features/notifications/domain/repository/app_notifications_repo.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;
  final NotificationLocalDataSource local;

  NotificationRepositoryImpl({required this.remote, required this.local});

  @override
  Future<AppNotification> getNotificationById(String id) async {
    final remoteNotif = await remote.getNotificationById(id);

    return _mapWithRead(remoteNotif);
  }

  @override
  Future<List<AppNotification>> getAllNotifications() async {
    final remoteNotifs = await remote.getAllNotifications();

    return remoteNotifs.map((notif) {
      return _mapWithRead(notif);
    }).toList();
  }

  //Local
  @override
  Future<void> markAsRead(String id) {
    return local.markAsRead(id);
  }

  @override
  bool isRead(String id) {
    return local.isRead(id);
  }

  AppNotification _mapWithRead(AppNotification notif) {
    return notif.copyWith(isRead: local.isRead(notif.id));
  }
}
