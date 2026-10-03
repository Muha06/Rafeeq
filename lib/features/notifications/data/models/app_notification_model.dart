import 'package:rafeeq/features/notifications/domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  AppNotificationModel({
    required super.id,
    required super.title,
    required super.body,
    super.imageUrl,
    required super.createdAt,
  });
  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
