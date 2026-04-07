import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/quran_reading_plan/data/models/quran_reading_plan_hive.dart';
import 'package:rafeeq/features/quran_reading_plan/domain/entities/quran_goal.dart';

final quranReadingPlanProvider =
    NotifierProvider<QuranReadingPlanNotifier, QuranReadingPlan>(
      QuranReadingPlanNotifier.new,
    );

class QuranReadingPlanNotifier extends Notifier<QuranReadingPlan> {
  late Box<QuranReadingPlanHive> box;

  @override
  QuranReadingPlan build() {
    box = Hive.box<QuranReadingPlanHive>('quran_reading_plan');
    final hiveReadingPlan = box.get('reading_plan');

    if (hiveReadingPlan != null) {
      return mapHiveGoal(hiveReadingPlan);
    } else {
      return QuranReadingPlan(
        dailyTarget: 50,
        createdAt: DateTime.now(),
        isActive: true,
      );
    }
  }

  /// Sets a new daily target (and auto-activates if target > 0)
  void setTarget(int target) {
    final active = target > 0; // 0 target → inactive

    final plan = QuranReadingPlan(
      dailyTarget: target,
      createdAt: DateTime.now(),
      isActive: active,
    );

    state = plan;

    // Save to Hive
    final hiveReadingPlan = mapDomainGoal(plan);
    box.put('readingPlan', hiveReadingPlan);
  }

  /// Toggle the goal's active state
  void toggleReadingPlanActivity() {
    final toggled = state.copyWith(isActive: !state.isActive);

    state = toggled;

    // Save to Hive
    final hiveReadingPlan = mapDomainGoal(toggled);
    box.put('readingPlan', hiveReadingPlan);
  }
}
