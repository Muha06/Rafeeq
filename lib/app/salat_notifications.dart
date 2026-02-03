import 'package:flutter/material.dart';
import 'package:rafeeq/app/notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rafeeq/features/salat-times/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';

class SalahNotifications {
  SalahNotifications._();
  static final instance = SalahNotifications._();

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
      await NotificationService.instance.cancel(id);
    }
    for (final id in _reminderIds.values) {
      await NotificationService.instance.cancel(id);
    }
  }

  Future<void> scheduleForToday({required SalahTimesEntity times}) async {
    // clear old first (prevents duplicates)
    await cancelAll();

    final now = tz.TZDateTime.now(tz.local);

    for (final prayer in _adhanIds.keys) {
      final salatTime = times.at(prayer);

      // Convert to TZDateTime safely
      var adhanTime = tz.TZDateTime.from(salatTime, tz.local);

      // time passed -> take it tomorrow
      if (!adhanTime.isAfter(now)) {
        adhanTime = adhanTime.add(const Duration(days: 1));
      }

      // 1) MAIN: Adhan at prayer time
      await NotificationService.instance.scheduleSalah(
        id: _adhanIds[prayer]!,
        title: '${prayer.label} time',
        body: 'It’s time for ${prayer.label}.',
        scheduled: adhanTime,
        isFajr: prayer == SalahPrayer.fajr,
      );
    }
    //Then debug print
    final pending = await NotificationService.instance.plugin
        .pendingNotificationRequests();

    debugPrint('🕌 Pending Salat TOTAL: ${pending.length}');
    for (final p in pending) {
      debugPrint('• id=${p.id}, title=${p.title}');
    }
  }
}
