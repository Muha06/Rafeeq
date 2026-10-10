// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:rafeeq/core/features/local_notifications/repository/local_notifs_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';

class SalahNotifSchedulerService {
  SalahNotifSchedulerService({required this.localNotificationService});

  final LocalNotificationService localNotificationService;

  // Cancel all salah notifications
  Future<void> cancelAllPrayerReminders() async {
    final today = DateUtils.dateOnly(DateTime.now());

    // Generate the ids for each prayer and cancel them
    for (final prayer in SalahPrayer.values) {
      final adhanId = _notificationId(date: today, prayer: prayer);

      await localNotificationService.cancel(adhanId);
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

      debugPrint("Scheduling salah: $_notificationId(date: adhanTime ),");

      await localNotificationService.scheduleSalah(
        id: _notificationId(date: adhanTime, prayer: prayer),
        title: "Salat time - ${prayer.label}",
        body: username.isNotEmpty
            ? '$username, it\'s time for ${prayer.label}.'
            : 'Time for ${prayer.label}.',
        scheduled: adhanTime,
      );
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

  int _notificationId({required DateTime date, required SalahPrayer prayer}) {
    return (date.year * 10000 + date.month * 100 + date.day) * 10 +
        prayer.index;
  }
}
