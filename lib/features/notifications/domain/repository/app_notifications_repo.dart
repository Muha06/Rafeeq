import 'package:rafeeq/features/notifications/domain/entities/app_notification.dart';

abstract class NotificationRepository {
  Future<AppNotification> getNotificationById(String id);
  Future<List<AppNotification>> getAllNotifications();

  Future<void> markAsRead(String id);
  bool isRead(String id);
}
