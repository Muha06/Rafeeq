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
      return QuranGoal(dailyTarget: 50, createdAt: DateTime.now());
    }
  }

  void setGoal(int target) {
    final goal = QuranGoal(dailyTarget: target, createdAt: DateTime.now());
    state = goal;

    // Save to Hive using Hive model
    final hiveGoal = mapDomainGoal(goal);

    box.put('goal', hiveGoal);
  }
}
