import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/wiring_providers.dart';
import 'package:rafeeq/features/notifications/data/datasources/app_notifications_remote_ds.dart';
import 'package:rafeeq/features/notifications/data/datasources/notifications_local_ds.dart';
import 'package:rafeeq/features/notifications/data/repository/app_notification_repo_impl.dart';
import 'package:rafeeq/features/notifications/domain/entities/app_notification.dart';
import 'package:rafeeq/features/notifications/domain/repository/app_notifications_repo.dart';

final notificationRemoteDsProvider = Provider<NotificationRemoteDataSource>((
  ref,
) {
  final supabase = ref.watch(supabaseClientProvider);
  return NotificationRemoteDataSource(supabase);
});

final notificationBoxProvider = Provider<Box>((ref) {
  return Hive.box('read_notifications');
});

final notificationLocalDsProvider = Provider((ref) {
  final box = ref.watch(notificationBoxProvider);
  return NotificationLocalDataSource(box);
});
final notificationRepoProvider = Provider<NotificationRepository>((ref) {
  final remoteDs = ref.watch(notificationRemoteDsProvider);
  final localDs = ref.watch(notificationLocalDsProvider);

  return NotificationRepositoryImpl(remote: remoteDs, local: localDs);
});

final notificationProvider = FutureProvider.family<AppNotification, String>((
  ref,
  id,
) async {
  final repo = ref.watch(notificationRepoProvider);

  return repo.getNotificationById(id);
});
