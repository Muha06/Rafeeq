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

//Listens to user adhkarsettingsprovider
final adhkarNotificationsControllerProvider = Provider<void>((ref) {
  ref.listen<bool>(adhkarNotifEnabledProvider, (prev, next) async {
    if (!next) {
      debugPrint('Cancelling $next');
      await NotificationService.instance.cancel(morningNotifId);
      await NotificationService.instance.cancel(eveningNotifId);
      return;
    }

    // enabled: schedule both
    await NotificationService.instance.cancel(morningNotifId);
    await NotificationService.instance.cancel(eveningNotifId);

    debugPrint('scheduling adhakr $next');
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
    
  });
});

final adhkarNotifUpdatingProvider = StateProvider<bool>((_) => false);

final salahNotifUpdatingProvider = StateProvider<bool>((_) => false);
