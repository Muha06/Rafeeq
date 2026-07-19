import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
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

  void createGoal(QuranGoal goal) {
    state = goal;
    _save(goal);
  }

  void deleteGoal() {
    box.delete(_goalKey);
    state = null;
  }

  void _save(QuranGoal? goal) {
    if (goal == null) return;

    box.put(_goalKey, goal.toHive());
  }
}
