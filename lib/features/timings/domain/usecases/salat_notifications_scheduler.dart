import 'package:flutter/material.dart';
import 'package:rafeeq/core/features/local_notifications/repository/local_notifs_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';

class SalahNotifSchedulerService {
  SalahNotifSchedulerService({required this.localNotificationService});

  final LocalNotificationService localNotificationService;

  static const _scheduleDays = 3;

  Future<void> cancelAll() async {
    // Cancel notifications for the scheduling window

    final today = DateUtils.dateOnly(DateTime.now());

    for (int i = 0; i < _scheduleDays; i++) {
      final date = today.add(Duration(days: i));

      // Generate the ids for each prayer and cancel them
      for (final prayer in SalahPrayer.values) {
        final adhanId = _notificationId(
          date: date,
          prayer: prayer,
          isReminder: false,
        );

        final reminderId = _notificationId(
          date: date,
          prayer: prayer,
          isReminder: true,
        );

        await localNotificationService.cancel(adhanId);
        await localNotificationService.cancel(reminderId);
      }
    }
  }

  Future<void> scheduleForDay({
    required SalahTimesEntity times,
    required String username,
    Set<SalahPrayer> disabled = const {},
  }) async {
    for (final prayer in SalahPrayer.values) {
      // Skip if disabled
      if (disabled.contains(prayer)) continue;

      var adhanTime = tz.TZDateTime.from(times.at(prayer), tz.local);

      await localNotificationService.scheduleSalah(
        id: _notificationId(date: adhanTime, prayer: prayer, isReminder: false),
        title: "Salat time - ${prayer.label}",
        body: username.isNotEmpty
            ? '$username, it\'s time for ${prayer.label}.'
            : 'Time for ${prayer.label}.',
        scheduled: adhanTime,
      );
    }

    final pending = await localNotificationService.plugin
        .pendingNotificationRequests();

    debugPrint('🕌 Pending Salat TOTAL: ${pending.length}');
    for (final p in pending) {
      debugPrint('• id=${p.id}, title=${p.title}');
    }
  }

  Future<void> testAdhanNow() async {
    final exactAllowed = await localNotificationService
        .canScheduleExactAlarms();

    final notifAllowed = await localNotificationService
        .areNotificationsEnabled();

    debugPrint(
      "Exact allowed: $exactAllowed \n Notifications allowed: $notifAllowed",
    );
    await localNotificationService.testAdhanNow();
  }

  int _notificationId({
    required DateTime date,
    required SalahPrayer prayer,
    required bool isReminder,
  }) {
    final dateKey = date.year * 10000 + date.month * 100 + date.day;
    final prayerKey = prayer.index + 1;
    final typeKey = isReminder ? 2 : 1;

    return dateKey * 100 + prayerKey * 10 + typeKey;
  }
}
