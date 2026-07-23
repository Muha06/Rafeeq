import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_goal_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_goal_type_hive.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_target_unit_hive.dart';

enum QuranGoalType { tilawah, hifz }

enum QuranTargetUnit { ayah, page, juz, surah }

class QuranGoal {
  final QuranGoalType type;
  final QuranTargetUnit targetUnit;

  final int target;

  final DateTime startDate;
  final DateTime endDate;

  final TimeOfDay? remindMeAt;

  final bool isActive;
  final DateTime createdAt;

  const QuranGoal({
    required this.type,
    required this.target,
    required this.targetUnit,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.remindMeAt,
    this.isActive = true,
  });

  //helper to void get formatted start date
  String get formattedStartDate => DateFormat('d MMMM yyyy').format(startDate);
  String get formattedEndDate => DateFormat('d MMMM yyyy').format(endDate);
  String get formattedReminderTime {
    if (remindMeAt == null) return 'No reminder';

    final hour = remindMeAt!.hourOfPeriod == 0 ? 12 : remindMeAt!.hourOfPeriod;
    final minute = remindMeAt!.minute.toString().padLeft(2, '0');
    final period = remindMeAt!.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  QuranGoal copyWith({
    int? target,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? remindMeAt,
    bool? isActive,
    QuranGoalType? type,
    QuranTargetUnit? targetUnit,
  }) {
    return QuranGoal(
      target: target ?? this.target,
      targetUnit: targetUnit ?? this.targetUnit,
      endDate: endDate ?? this.endDate,
      remindMeAt: remindMeAt ?? this.remindMeAt,
      startDate: startDate ?? this.startDate,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      createdAt: createdAt,
    );
  }

  QuranGoalHive toHive() {
    return QuranGoalHive(
      target: target,
      startDate: startDate,
      endDate: endDate,
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
