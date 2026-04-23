import 'package:flutter/widgets.dart';
import 'package:rafeeq/features/notifications/data/models/app_notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationRemoteDataSource {
  final SupabaseClient supabase;

  NotificationRemoteDataSource(this.supabase);

  Future<List<AppNotificationModel>> getAllNotifications() async {
    try {
      final res = await supabase
          .from('notifications')
          .select()
          .order('created_at', ascending: false);

      return (res as List)
          .map((e) => AppNotificationModel.fromJson(e))
          .toList();
    } on Exception catch (e, st) {
      debugPrint('Error fetching notifications: $e, $st');
      rethrow;
    }
  }

  Future<AppNotificationModel> getNotificationById(String id) async {
    try {
      final res = await supabase
          .from('notifications')
          .select()
          .eq('id', id)
          .single();

      return AppNotificationModel.fromJson(res);
    } on Exception catch (e, st) {
      debugPrint('Error fetching notification: $e, $st');
      rethrow;
    }
  }
}
