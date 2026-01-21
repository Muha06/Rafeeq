import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rafeeq/app/notifications.dart';
import 'package:rafeeq/app/salat_notifications.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';
import 'package:rafeeq/features/salat-times/presentation/riverpod/salah_times_providers.dart';
import 'package:riverpod/legacy.dart';

const kAdhkarEnabled = 'adhkar_notif_enabled'; //a setting inside hive
const kSalahEnabled = 'salah_notif_enabled'; //a setting inside hive

const fajrNotifId = 101;
const dhuhrNotifId = 102;
const asrNotifId = 103;
const maghribNotifId = 104;
const ishaNotifId = 105;

const morningNotifId = 200;
const eveningNotifId = 201;

const kmorningAdhkarTime = TimeOfDay(hour: 7, minute: 30);
const keveningAdhkarTime = TimeOfDay(hour: 18, minute: 30);

final settingsBoxProvider = Provider<Box>((ref) => Hive.box('settingsBox'));

final adhkarNotifEnabledProvider = StateProvider<bool>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return box.get(kAdhkarEnabled, defaultValue: true) as bool;
});

final salahNotifEnabledProvider = StateProvider<bool>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return box.get(kSalahEnabled, defaultValue: true) as bool;
});
Future<void> setSalahNotif(WidgetRef ref, bool enabled) async {
  final isUpdating = ref.read(salahNotifUpdatingProvider);
  if (isUpdating) return;

  ref.read(salahNotifUpdatingProvider.notifier).state = true;

  try {
    final box = ref.read(settingsBoxProvider);

    await box.put(kSalahEnabled, enabled);
    ref.read(salahNotifEnabledProvider.notifier).state = enabled;

    // always reset schedules cleanly
    await NotificationService.instance.cancel(fajrNotifId);
    await NotificationService.instance.cancel(dhuhrNotifId);
    await NotificationService.instance.cancel(asrNotifId);
    await NotificationService.instance.cancel(maghribNotifId);
    await NotificationService.instance.cancel(ishaNotifId);

    if (!enabled) return;

    // ✅ fetch today times (from cache or remote)
    final times = await ref.read(todaySalahTimesProvider.future);

    // ✅ schedule salah for today
    await SalahNotifications.instance.scheduleForToday(
      times: times,
      remindBeforeMinutes: 0,
    );
  } finally {
    ref.read(salahNotifUpdatingProvider.notifier).state = false;
  }
}

final salahNotifUpdatingProvider = StateProvider<bool>((_) => false);

//---------------------Set notifications------------------
Future<void> setAdhkarNotif(WidgetRef ref, bool enabled) async {
  final isUpdating = ref.read(adhkarNotifUpdatingProvider);
  if (isUpdating) return;

  ref.read(adhkarNotifUpdatingProvider.notifier).state = true; //loading

  try {
    final box = ref.read(settingsBoxProvider);

    await box.put(kAdhkarEnabled, enabled);
    ref.read(adhkarNotifEnabledProvider.notifier).state = enabled;

    // always reset schedules cleanly
    await NotificationService.instance.cancel(morningNotifId);
    await NotificationService.instance.cancel(eveningNotifId);

    if (enabled) {
      await NotificationService.instance.scheduleDaily(
        id: morningNotifId,
        title: 'Morning Adhkār ☀️',
        body: 'Take 2 minutes for your morning adhkār.',
        time: kmorningAdhkarTime,
      );

      await NotificationService.instance.scheduleDaily(
        id: eveningNotifId,
        title: 'Evening Adhkār 🌙',
        body: 'Don’t miss your evening adhkār.',
        time: keveningAdhkarTime,
      );
    }
  } finally {
    ref.read(adhkarNotifUpdatingProvider.notifier).state = false;
  }
}

final adhkarNotifUpdatingProvider = StateProvider<bool>((_) => false);


final salahDailyReschedulerProvider = Provider<void>((ref) {
  final box = ref.read(settingsBoxProvider);
  final enabled = box.get(kSalahEnabled, defaultValue: true) as bool;
  if (!enabled) return;

  // listen once when timings load
  ref.listen<AsyncValue<SalahTimesEntity>>(todaySalahTimesProvider, (
    prev,
    next,
  ) {
    next.whenData((times) async {
      await SalahNotifications.instance.scheduleForToday(
        times: times,
        remindBeforeMinutes: 0,
      );
    });
  });
});
