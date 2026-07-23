import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';

class AyahNotificationScheduler extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // nothing to expose
  }

  Future<void> schedule() async {
    final ayah = await ref.read(ayahOfTheDayProvider.future);
    if (ayah == null) return;

    final notifications = ref.read(localNotificationServiceProvider);

 
    await notifications.scheduleDaily(
      id: 0402,
      title: '📖 Ayah of the Day',
      body: ayah.textEnglish,
      time: const TimeOfDay(hour: 11, minute: 00),
    );
  }

  Future<void> cancel() async {
    await ref.read(localNotificationServiceProvider).cancel(0402);
  }
}

final ayahNotificationSchedulerProvider =
    AsyncNotifierProvider<AyahNotificationScheduler, void>(
      AyahNotificationScheduler.new,
    );
