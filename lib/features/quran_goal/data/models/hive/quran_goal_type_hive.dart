import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
part 'quran_goal_type_hive.g.dart';

@HiveType(typeId: 14)
enum QuranGoalTypeHive {
  @HiveField(0)
  tilawah,

  @HiveField(1)
  hifz,
}

extension QuranGoalTypeHiveX on QuranGoalTypeHive {
  QuranGoalType get toDomain {
    switch (this) {
      case QuranGoalTypeHive.tilawah:
        return QuranGoalType.tilawah;
      case QuranGoalTypeHive.hifz:
        return QuranGoalType.hifz;
    }
  }
}

extension QuranGoalTypeX on QuranGoalType {
  QuranGoalTypeHive get toHive {
    switch (this) {
      case QuranGoalType.tilawah:
        return QuranGoalTypeHive.tilawah;
      case QuranGoalType.hifz:
        return QuranGoalTypeHive.hifz;
    }
  }
}
