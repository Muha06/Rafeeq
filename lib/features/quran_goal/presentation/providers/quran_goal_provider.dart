import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/core/features/local_notifications/repository/local_notifs_service.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_goal_hive.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';

final quranGoalProvider = NotifierProvider<QuranGoalNotifier, QuranGoal?>(
  QuranGoalNotifier.new,
);

class QuranGoalNotifier extends Notifier<QuranGoal?> {
  late Box<QuranGoalHive> box;
  static const _goalKey = 'quran_goal';
  static const _boxName = 'quran_goal';

  @override
  QuranGoal? build() {
    box = Hive.box<QuranGoalHive>(_boxName);

    final hiveGoal = box.get(_goalKey);
    return hiveGoal?.toDomain();
  }

  static const nowNotificationId = 1000;
  static const dailyReminderNotificationId = 1001;

  LocalNotificationService get notifications =>
      ref.read(localNotificationServiceProvider);

  void updateGoal({
    int? target,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? remindMeAt,
    QuranGoalType? type,
    QuranTargetUnit? targetUnit,
    bool? isActive,
  }) async {
    final goal = state;
    if (goal == null) return;

    final updated = goal.copyWith(
      target: target,
      startDate: startDate,
      endDate: endDate,
      remindMeAt: remindMeAt,
      type: type,
      targetUnit: targetUnit,
      isActive: isActive,
    );

    state = updated;
    _save(updated);

    await notifications.showNow(
      id: nowNotificationId,
      title: 'Goal Updated',
      body: 'Your Quran goal has been updated successfully.',
    );

    // re-schedule daily reminder alarm
    if (updated.remindMeAt != null) {
      await _scheduleReminder(updated);
    } else {
      await notifications.cancel(dailyReminderNotificationId);
    }

    RafeeqAnalytics.logFeature(
      'update-quran-goal',
      parameters: {
        'start_date': goal.startDate.toIso8601String(),
        'end_date': goal.endDate.toIso8601String(),
        'target': updated.target,
      },
    );
  }

  void createGoal(QuranGoal goal) async {
    state = goal;
    _save(goal);
    // await notifications.cancel(dailyReminderNotificationId);

    await notifications.showNow(
      id: nowNotificationId,
      title: 'Goal Created',
      body:
          'Your Quran goal has been created successfully. Stay consistent and may Allah bless your journey with the Quran.',
    );

    // Schedule daily reminder
    if (goal.remindMeAt != null) {
      _scheduleReminder(goal);
    }

    RafeeqAnalytics.logFeature(
      'create_quran_goal',
      parameters: {
        'goal_type': goal.type.name, // tilawah / hifz
        'start_date': goal.startDate.toIso8601String(),
        'end_date': goal.endDate.toIso8601String(),
        'target': goal.target,
      },
    );
  }

  Future<void> deleteGoal() async {
    final goal = state;
    if (goal == null) return;

    box.delete(_goalKey);
    state = null;

    await notifications.cancel(dailyReminderNotificationId);

    await notifications.showNow(
      id: nowNotificationId,
      title: 'Goal Deleted',
      body:
          'Your Quran goal has been deleted successfully. You can create a new goal anytime.',
    );

    RafeeqAnalytics.logFeature(
      'delete_quran_goal',
      parameters: {
        'goal_type': goal.type.name,
        'target': goal.target,
        'days_since_created': DateTime.now().difference(goal.createdAt).inDays,
      },
    );
  }

  void _save(QuranGoal? goal) {
    if (goal == null) return;

    box.put(_goalKey, goal.toHive());
  }

  Future<void> _scheduleReminder(QuranGoal goal) async {
    await notifications.scheduleQuranGoalReminder(
      id: dailyReminderNotificationId,
      title: 'Time for Your Quran Goal',
      body:
          'Continue your Quran journey today and make progress toward your goal.',
      time: goal.remindMeAt!,
    );
  }
}
