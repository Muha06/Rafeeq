import 'package:hive/hive.dart';
import 'package:rafeeq/features/quran_reading_plan/domain/entities/quran_goal.dart';

part 'quran_reading_plan_hive.g.dart';

@HiveType(typeId: 10)
class QuranReadingPlanHive extends HiveObject {
  @HiveField(0)
  int dailyTarget;

  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  bool isActive;

  QuranReadingPlanHive({
    required this.dailyTarget,
    required this.createdAt,
    required this.isActive,
  });
}

// Hive → Domain
QuranReadingPlan mapHiveGoal(QuranReadingPlanHive hiveReadingPlan) {
  return QuranReadingPlan(
    dailyTarget: hiveReadingPlan.dailyTarget,
    createdAt: hiveReadingPlan.createdAt,
    isActive: hiveReadingPlan.isActive,
  );
}

// Domain → Hive
QuranReadingPlanHive mapDomainGoal(QuranReadingPlan plan) {
  return QuranReadingPlanHive(
    dailyTarget: plan.dailyTarget,
    createdAt: plan.createdAt,
    isActive: plan.isActive,
  );
}
