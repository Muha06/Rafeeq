import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/adhkar/presentation/widgets/adhkar_reminder_card.dart';
import 'package:rafeeq/features/home/presentation/widgets/friday_reminder_card.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';

final homeRemindersProvider = Provider<List<Widget>>((ref) {
  final now = DateTime.now();
  final reminders = <Widget>[];

  bool isFriday = now.weekday == DateTime.friday;

  int hm(int h, int m) => h * 60 + m;

  bool isInWindow(DateTime now, int startMin, int endMin) {
    final m = now.hour * 60 + now.minute;

    if (startMin <= endMin) return m >= startMin && m < endMin;
    return m >= startMin || m < endMin;
  }

  const morningTime = kmorningAdhkarTime;
  const eveningTime = keveningAdhkarTime;

  final isMorning = isInWindow(
    now,
    hm(morningTime.hour, morningTime.minute),
    hm(11, 30),
  );

  final isEvening = isInWindow(
    now,
    hm(eveningTime.hour, eveningTime.minute),
    hm(22, 30),
  );

  // 🌅 Morning Adhkar
  if (isMorning) {
    reminders.add(const AdhkarReminderCard(isMorning: true));
  }

  // 🕌 Friday
  if (isFriday) {
    reminders.add(const FridayReminderCard());
  }

  // 🌇 Evening Adhkar
  if (isEvening) {
    reminders.add(const AdhkarReminderCard(isMorning: false));
  }

  return reminders;
});
