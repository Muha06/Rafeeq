import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_goal_hive.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';

final quranGoalProvider = NotifierProvider<QuranGoalNotifier, QuranGoal>(
  QuranGoalNotifier.new,
);

class QuranGoalNotifier extends Notifier<QuranGoal> {
  late Box<QuranHiveGoal> box;

  @override
  QuranGoal build() {
    box = Hive.box<QuranHiveGoal>('quran_goal');
    final hiveGoal = box.get('goal');
    if (hiveGoal != null) {
      return mapHiveGoal(hiveGoal);
    } else {
      return QuranGoal(
        dailyTarget: 50,
        createdAt: DateTime.now(),
        isActive: true,
      );
    }
  }

  /// Sets a new daily target (and auto-activates if target > 0)
  void setGoal(int target) {
    final active = target > 0; // 0 target → inactive
    
    final goal = QuranGoal(
      dailyTarget: target,
      createdAt: DateTime.now(),
      isActive: active,
    );

    state = goal;

    // Save to Hive
    final hiveGoal = mapDomainGoal(goal);
    box.put('goal', hiveGoal);
  }

  /// Toggle the goal's active state
  void toggleGoalActivity() {
    final toggled = state.copyWith(isActive: !state.isActive);

    state = toggled;
    debugPrint(state.isActive.toString());

    // Save to Hive
    final hiveGoal = mapDomainGoal(toggled);
    box.put('goal', hiveGoal);
  }
}
