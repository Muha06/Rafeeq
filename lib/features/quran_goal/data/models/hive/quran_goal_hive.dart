import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_goal_type_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_target_unit_hive.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';

part 'quran_goal_hive.g.dart';

@HiveType(typeId: 10)
class QuranGoalHive extends HiveObject {
  @HiveField(0)
  int dailyTarget;

  @HiveField(1)
  bool isActive;

  @HiveField(2)
  QuranGoalTypeHive type;

  @HiveField(3)
  int? reminderHour;

  @HiveField(4)
  int? reminderMinute;

  @HiveField(5)
  QuranTargetUnitHive targetUnit;

  @HiveField(6)
  DateTime createdAt;

  QuranGoalHive({
    required this.dailyTarget,
    required this.createdAt,
    required this.isActive,
    required this.type,
    required this.targetUnit,
    this.reminderHour,
    this.reminderMinute,
  });

  /// Hive → Domain
  QuranGoal toDomain() {
    return QuranGoal(
      dailyTarget: dailyTarget,
      isActive: isActive,
      type: type.toDomain,
      targetUnit: targetUnit.toDomain,
      remindMeAt: reminderHour == null || reminderMinute == null
          ? null
          : TimeOfDay(hour: reminderHour!, minute: reminderMinute!),
      createdAt: createdAt,
    );
  }

  /// Domain → Hive
  QuranGoalHive toHive(QuranGoal goal) {
    return QuranGoalHive(
      dailyTarget: goal.dailyTarget,
      isActive: goal.isActive,
      type: goal.type.toHive,
      targetUnit: goal.targetUnit.toHive,
      reminderHour: goal.remindMeAt?.hour,
      reminderMinute: goal.remindMeAt?.minute,
      createdAt: goal.createdAt,
    );
  }
}
