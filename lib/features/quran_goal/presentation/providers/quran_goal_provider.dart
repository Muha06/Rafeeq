import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
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

  void updateGoal({
    int? target,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? remindMeAt,
    QuranGoalType? type,
    QuranTargetUnit? targetUnit,
    bool? isActive,
  }) {
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
  }

  void createGoal(QuranGoal goal) async {
    state = goal;
    _save(goal);

    await ref
        .read(localNotificationServiceProvider)
        .showNow(
          id: 1002,
          title: 'Goal Created',
          body:
              'Your Quran goal has been created successfully. Stay consistent and may Allah bless your journey with the Quran.',
        );
  }

  void deleteGoal() async {
    box.delete(_goalKey);
    state = null;

    await ref
        .read(localNotificationServiceProvider)
        .showNow(
          id: 1002,
          title: 'Goal Deleted',
          body:
              'Your Quran goal has been deleted successfully. You can create a new goal anytime.',
        );
  }

  void _save(QuranGoal? goal) {
    if (goal == null) return;

    box.put(_goalKey, goal.toHive());
  }
}
