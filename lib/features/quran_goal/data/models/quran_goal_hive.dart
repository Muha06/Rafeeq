import 'package:hive/hive.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';

part 'quran_goal_hive.g.dart';

@HiveType(typeId: 10)
class QuranHiveGoal extends HiveObject {
  @HiveField(0)
  int dailyTarget;

  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  bool isActive;

  QuranHiveGoal({
    required this.dailyTarget,
    required this.createdAt,
    required this.isActive,
  });
}

// Hive → Domain
QuranGoal mapHiveGoal(QuranHiveGoal hiveGoal) {
  return QuranGoal(
    dailyTarget: hiveGoal.dailyTarget,
    createdAt: hiveGoal.createdAt,
    isActive: hiveGoal.isActive,
  );
}

// Domain → Hive
QuranHiveGoal mapDomainGoal(QuranGoal goal) {
  return QuranHiveGoal(
    dailyTarget: goal.dailyTarget,
    createdAt: goal.createdAt,
    isActive: goal.isActive,
  );
}
