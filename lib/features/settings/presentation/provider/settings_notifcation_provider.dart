import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/user/presentation/providers/user_provider.dart';
import 'package:riverpod/legacy.dart';

import 'package:hive/hive.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/notiffications_controller.dart';

const kAdhkarEnabled =
    'adhkar_notif_enabled'; //a setting inside hive (For user settings)
const kSalahEnabled = 'salah_notif_enabled'; //a setting inside hive

const fajrNotifId = 101;
const dhuhrNotifId = 102;
const asrNotifId = 103;
const maghribNotifId = 104;
const ishaNotifId = 105;

const morningNotifId = 205;
const eveningNotifId = 206;

const kmorningAdhkarTime = TimeOfDay(hour: 6, minute: 00);
const keveningAdhkarTime = TimeOfDay(hour: 17, minute: 30);

final settingsBoxProvider = Provider<Box>((ref) => Hive.box('settingsBox'));

//Listens to user adhkarsettingsprovider
final adhkarNotificationsControllerProvider = Provider<void>((ref) async {
  final localNotifService = ref.read(localNotificationServiceProvider);

  Future<void> schedule() async {
    debugPrint('cancelling  ');
    await localNotifService.cancel(morningNotifId);
    await localNotifService.cancel(eveningNotifId);

    final username = ref.read(userNameProvider);

    await localNotifService.scheduleDaily(
      id: morningNotifId,
      title: 'Morning Adhkār ☀️',
      body: username.isNotEmpty
          ? '$username, take 2 minutes for your morning adhkār.'
          : 'Take 2 minutes for your morning adhkār.',
      time: kmorningAdhkarTime,
    );

    await localNotifService.scheduleDaily(
      id: eveningNotifId,
      title: 'Evening Adhkār 🌙',
      body: username.isNotEmpty
          ? '$username, don’t miss your evening adhkār.'
          : 'Don’t miss your evening adhkār.',
      time: keveningAdhkarTime,
    );
  }

  final enabled = ref.read(adhkarNotifControllerProvider);

  if (enabled) {
    await schedule();
  }

  // then react to usser settings changes
  ref.listen<bool>(adhkarNotifControllerProvider, (prev, next) async {
    //if disabled -> only cancel
    if (!next) {
      await localNotifService.cancel(morningNotifId);
      await localNotifService.cancel(eveningNotifId);
      return;
    }

    await schedule();
  });
});

final adhkarNotifUpdatingProvider = StateProvider<bool>((_) => false);

final salahNotifUpdatingProvider = StateProvider<bool>((_) => false);
