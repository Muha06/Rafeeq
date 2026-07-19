import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';

part 'generated/quran_target_unit_hive.g.dart';

@HiveType(typeId: 13)
enum QuranTargetUnitHive {
  @HiveField(0)
  ayah,

  @HiveField(1)
  page,

  @HiveField(2)
  juz,

  @HiveField(3)
  surah,
}

extension QuranTargetUnitHiveX on QuranTargetUnitHive {
  QuranTargetUnit get toDomain {
    switch (this) {
      case QuranTargetUnitHive.ayah:
        return QuranTargetUnit.ayah;
      case QuranTargetUnitHive.page:
        return QuranTargetUnit.page;
      case QuranTargetUnitHive.juz:
        return QuranTargetUnit.juz;
      case QuranTargetUnitHive.surah:
        return QuranTargetUnit.surah;
    }
  }
}

extension QuranTargetUnitX on QuranTargetUnit {
  QuranTargetUnitHive get toHive {
    switch (this) {
      case QuranTargetUnit.ayah:
        return QuranTargetUnitHive.ayah;
      case QuranTargetUnit.page:
        return QuranTargetUnitHive.page;
      case QuranTargetUnit.juz:
        return QuranTargetUnitHive.juz;
      case QuranTargetUnit.surah:
        return QuranTargetUnitHive.surah;
    }
  }
}
