import 'package:flutter/cupertino.dart';
import 'package:rafeeq/app/notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';

class SalahNotifications {
  SalahNotifications._();
  static final instance = SalahNotifications._();

  // stable ids so updates replace previous schedules
  static const _ids = {
    SalahPrayer.fajr: 101,
    SalahPrayer.dhuhr: 102,
    SalahPrayer.asr: 103,
    SalahPrayer.maghrib: 104,
    SalahPrayer.isha: 105,
  };

  Future<void> cancelAll() async {
    for (final id in _ids.values) {
      await NotificationService.instance.cancel(id);
    }
  }

  Future<void> scheduleForToday({
    required SalahTimesEntity times,
    int remindBeforeMinutes = 0, // 0 = at adhan time, 10 = 10 mins before
  }) async {
    final plugin = NotificationService.instance.plugin;

    // clear old first (prevents duplicates)
    for (final id in _ids.values) {
      await plugin.cancel(id);
    }

    const androidDetails = AndroidNotificationDetails(
      'rafeeq_salah',
      'Ṣalāh Times',
      channelDescription: 'Prayer time notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final exactAllowed = await NotificationService.instance
        .ensureExactAlarmsAllowed();

    final now = tz.TZDateTime.now(tz.local);
    debugPrint(now.toString());

    for (final prayer in _ids.keys) {
      final raw = times.at(prayer);

      // apply reminder offset if needed
      final target = raw.subtract(Duration(minutes: remindBeforeMinutes));

      // timezone-aware
      final scheduled = tz.TZDateTime.from(target, tz.local);

      // don’t schedule past times
      if (!scheduled.isAfter(now)) continue;

      await plugin.zonedSchedule(
        _ids[prayer]!,
        remindBeforeMinutes > 0
            ? '${prayer.label} in $remindBeforeMinutes min'
            : '${prayer.label} time',
        remindBeforeMinutes > 0
            ? 'Get ready for ${prayer.label}.'
            : 'It’s time for ${prayer.label}.',
        scheduled,
        details,
        androidScheduleMode: exactAllowed
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
      );
      final pending = await plugin.pendingNotificationRequests();
      debugPrint('🔔 Pending notifications: ${pending.length}');
      for (final p in pending) {
        debugPrint(
          '• id=${p.id}, title=${p.title}, body=${p.body}, payload=${p.payload}',
        );
      }
    }
  }
}
