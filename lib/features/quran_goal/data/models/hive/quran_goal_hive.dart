import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_goal_type_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_target_unit_hive.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';

part 'quran_goal_hive.g.dart';

@HiveType(typeId: 10)
class QuranGoalHive extends HiveObject {
  @HiveField(0)
  int target;

  @HiveField(1)
  DateTime startDate;

  @HiveField(2)
  DateTime endDate;

  @HiveField(3)
  bool isActive;

  @HiveField(4)
  QuranGoalTypeHive type;

  @HiveField(5)
  int? reminderHour;

  @HiveField(6)
  int? reminderMinute;

  @HiveField(7)
  QuranTargetUnitHive targetUnit;

  @HiveField(8)
  DateTime createdAt;

  QuranGoalHive({
    required this.target,
    required this.startDate,
    required this.endDate,
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
      target: target,
      startDate: startDate,
      endDate: endDate,
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
      target: goal.target,
      startDate: goal.startDate,
      endDate: goal.endDate,
      isActive: goal.isActive,
      type: goal.type.toHive,
      targetUnit: goal.targetUnit.toHive,
      reminderHour: goal.remindMeAt?.hour,
      reminderMinute: goal.remindMeAt?.minute,
      createdAt: goal.createdAt,
    );
  }
}
