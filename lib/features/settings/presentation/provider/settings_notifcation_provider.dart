import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rafeeq/app/notifications.dart';
import 'package:riverpod/legacy.dart';

const kAdhkarEnabled = 'adhkar_notif_enabled'; //a setting inside hive
const kSalahEnabled = 'salah_notif_enabled'; //a setting inside hive

const fajrNotifId = 101;
const dhuhrNotifId = 102;
const asrNotifId = 103;
const maghribNotifId = 104;
const ishaNotifId = 105;

const morningNotifId = 205;
const eveningNotifId = 206;

const kmorningAdhkarTime = TimeOfDay(hour: 6, minute: 00);
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

//Listens to user adhkarsettingsprovider
final adhkarNotificationsControllerProvider = Provider<void>((ref) async {
  Future<void> schedule() async {
    debugPrint('cancelling  ');
    await NotificationService.instance.cancel(morningNotifId);
    await NotificationService.instance.cancel(eveningNotifId);

    debugPrint('Scheduling  ');

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

  final enabled = ref.read(adhkarNotifEnabledProvider);

  if (enabled) {
    await schedule();
  }

  // then react to changes
  ref.listen<bool>(adhkarNotifEnabledProvider, (prev, next) async {
    //if disabled -> only cancel
    if (!next) {
      await NotificationService.instance.cancel(morningNotifId);
      await NotificationService.instance.cancel(eveningNotifId);
      return;
    }
    //else -> schedule
    await schedule();
  });
});

final adhkarNotifUpdatingProvider = StateProvider<bool>((_) => false);

final salahNotifUpdatingProvider = StateProvider<bool>((_) => false);
