import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rafeeq/app/notifications.dart';
import 'package:riverpod/legacy.dart';

const kAdhkarEnabled = 'adhkar_notif_enabled'; //a setting inside hive

const morningNotifId = 200;
const eveningNotifId = 201;

const kmorningAdhkarTime = TimeOfDay(hour: 7, minute: 30);
const keveningAdhkarTime = TimeOfDay(hour: 18, minute: 30);

final settingsBoxProvider = Provider<Box>((ref) => Hive.box('settingsBox'));

final adhkarNotifEnabledProvider = StateProvider<bool>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return box.get(kAdhkarEnabled, defaultValue: true) as bool;
});

//-----------set notifications------------------
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
