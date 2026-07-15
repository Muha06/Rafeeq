import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/features/Ramadan/data/datasources/local_ramadan_refections.dart';
import '../../domain/ramadan_reflection.dart';

final ramadanReflectionsProvider = Provider<List<RamadanReflection>>((ref) {
  return kRamadanReflections;
});
const ramadhanNotifId = 301;

final ramadanReflectionByDayProvider =
    FutureProvider.family<RamadanReflection?, HijriDate>((ref, hijri) async {
      final month = hijri.hMonth;
      if (month != 9) return null; // not ramadan

      final day = hijri.hDay;

      final list = ref.watch(ramadanReflectionsProvider);

      final match = list.firstWhere((r) => day == r.day);

      final notifService = ref.read(localNotificationServiceProvider);

      // Example: Schedule reminder here asynchronously
      await notifService.scheduleDaily(
        id: ramadhanNotifId,
        title: 'Ramadan Reflection',
        body: 'Take a moment for today’s reflection.',
        time: const TimeOfDay(hour: 12, minute: 15),
      );

      return match;
    });
