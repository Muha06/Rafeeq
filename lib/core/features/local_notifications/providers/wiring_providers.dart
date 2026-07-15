 import 'package:rafeeq/core/features/local_notifications/repository/local_notifs_service.dart';
import 'package:riverpod/riverpod.dart';

final localNotificationServiceProvider = Provider(
  (_) => LocalNotificationService(),
);

