import 'package:flutter/material.dart';
 import 'package:rafeeq/features/quran_goal/data/models/hive/quran_goal_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_goal_type_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_target_unit_hive.dart';

enum QuranGoalType { tilawah, hifz } // Goal Type

enum QuranTargetUnit { ayah, page, juz, surah } // Target unit

class QuranGoal {
  final QuranGoalType type;
  final QuranTargetUnit targetUnit;

  final int dailyTarget;

  final TimeOfDay? remindMeAt;

  final bool isActive;
  final DateTime createdAt;

  const QuranGoal({
    required this.type,
    required this.dailyTarget,
    required this.targetUnit,
    required this.createdAt,
    this.remindMeAt,
    this.isActive = true,
  });

  String get formattedReminderTime {
    if (remindMeAt == null) return 'No reminder set';

    final hour = remindMeAt!.hourOfPeriod == 0 ? 12 : remindMeAt!.hourOfPeriod;
    final minute = remindMeAt!.minute.toString().padLeft(2, '0');
    final period = remindMeAt!.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  QuranGoal copyWith({
    int? dailyTarget,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? remindMeAt,
    bool? isActive,
    QuranGoalType? type,
    QuranTargetUnit? targetUnit,
  }) {
    return QuranGoal(
      dailyTarget: dailyTarget ?? this.dailyTarget,
      targetUnit: targetUnit ?? this.targetUnit,
       remindMeAt: remindMeAt ?? this.remindMeAt,
       isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      createdAt: createdAt,
    );
  }

  QuranGoalHive toHive() {
    return QuranGoalHive(
      dailyTarget: dailyTarget,
       isActive: isActive,
      type: type.toHive,
      targetUnit: targetUnit.toHive,
      createdAt: createdAt,
    );
  }
}

// Extensions
extension QuranGoalTypeX on QuranGoalType {
  String get label => switch (this) {
    QuranGoalType.tilawah => 'Tilawah',
    QuranGoalType.hifz => 'Hifz',
  };
}

extension QuranTargetUnitX on QuranTargetUnit {
  String get label => switch (this) {
    QuranTargetUnit.ayah => 'Ayahs',
    QuranTargetUnit.page => 'Pages',
    QuranTargetUnit.juz => 'Juz',
    QuranTargetUnit.surah => 'Surahs',
  };
}
