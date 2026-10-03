import 'package:hive/hive.dart';

class NotificationLocalDataSource {
  final Box box;

  NotificationLocalDataSource(this.box);

  Future<void> markAsRead(String id) async {
    await box.put(id, true);
  }

  bool isRead(String id) {
    return box.get(id, defaultValue: false);
  }
}
