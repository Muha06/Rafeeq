import 'package:flutter/material.dart';
import 'package:rafeeq/core/features/local_notifications/repository/local_notifs_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';

class SalahNotifSchedulerService {
  SalahNotifSchedulerService({required this.localNotificationService});

  final LocalNotificationService localNotificationService;
  // Adhan IDs (stable)
  static const _adhanIds = {
    SalahPrayer.fajr: 101,
    SalahPrayer.dhuhr: 102,
    SalahPrayer.asr: 103,
    SalahPrayer.maghrib: 104,
    SalahPrayer.isha: 105,
  };

  // Reminder-before IDs (separate so they don't overwrite adhan)
  static const _reminderIds = {
    SalahPrayer.fajr: 201,
    SalahPrayer.dhuhr: 202,
    SalahPrayer.asr: 203,
    SalahPrayer.maghrib: 204,
    SalahPrayer.isha: 205,
  };

  Future<void> cancelAll() async {
    for (final id in _adhanIds.values) {
      await localNotificationService.cancel(id);
    }
    for (final id in _reminderIds.values) {
      await localNotificationService.cancel(id);
    }
  }

  Future<void> scheduleForToday({
    required SalahTimesEntity times,
    Set<SalahPrayer> disabled = const {},
  }) async {
    await cancelAll();

    final now = tz.TZDateTime.now(tz.local);

    for (final prayer in _adhanIds.keys) {
      if (disabled.contains(prayer)) continue;

      var adhanTime = tz.TZDateTime.from(times.at(prayer), tz.local);

      if (!adhanTime.isAfter(now)) {
        adhanTime = adhanTime.add(const Duration(days: 1));
      }

      await LocalNotificationService().scheduleSalah(
        id: _adhanIds[prayer]!,
        title: "Salat time -${prayer.label}",
        body: 'Time for ${prayer.label}',
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
}
