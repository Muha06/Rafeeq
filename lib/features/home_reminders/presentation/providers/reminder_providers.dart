import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/home_reminders/presentation/widgets/friday_virtues_sheet.dart';
import 'package:rafeeq/features/home_reminders/presentation/widgets/home_reminder.dart';

final homeRemindersProvider = Provider.family<List<Widget>, BuildContext>((
  ref,
  context,
) {
  final now = DateTime.now();
  final reminders = <Widget>[];

  bool isFriday = now.weekday == DateTime.friday;

  // 🕌 Friday
  if (!isFriday) {
    reminders.add(
      HomeReminderCard(
        title: "View Friday Virtues",
        onTap: () => showFridayVirtuesSheet(context),
      ),
    );
  }

  return reminders;
});
