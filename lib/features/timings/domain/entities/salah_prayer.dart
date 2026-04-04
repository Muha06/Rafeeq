import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

enum SalahPrayer {
  fajr,
  sunrise,
  dhuha,
  dhuhr,
  asr,
  maghrib,
  isha,
  midnight,
  tahajjud,
}

//extra method on enum SalahPrayer that returns label(String) for every salah in the enum
extension SalahPrayerX on SalahPrayer {
  String get label => switch (this) {
    SalahPrayer.fajr => 'Fajr',
    SalahPrayer.sunrise => 'Sunrise',
    SalahPrayer.dhuha => 'Dhuha',
    SalahPrayer.dhuhr => 'Dhuhr',
    SalahPrayer.asr => 'Asr',
    SalahPrayer.maghrib => 'Maghrib',
    SalahPrayer.isha => 'Isha',
    SalahPrayer.midnight => 'Midnight',
    SalahPrayer.tahajjud => 'Tahajjud',
  };
}

extension SalahPrayerUi on SalahPrayer {
  IconData get icon {
    switch (this) {
      case SalahPrayer.fajr:
        return PhosphorIcons.moonStars(); // calm night prayer vibe

      case SalahPrayer.sunrise:
        return PhosphorIcons.sunHorizon(); // sunrise moment

      case SalahPrayer.dhuha:
        return PhosphorIcons.sun(); // mid-morning sun

      case SalahPrayer.dhuhr:
        return PhosphorIcons.sun(); // strong noon sun

      case SalahPrayer.asr:
        return PhosphorIcons.sunDim(); // softer afternoon light

      case SalahPrayer.maghrib:
        return PhosphorIcons.sunHorizon(); // sunset transition

      case SalahPrayer.isha:
        return PhosphorIcons.moon(); // night

      case SalahPrayer.midnight:
        return PhosphorIcons.clock(); // time-based neutral

      case SalahPrayer.tahajjud:
        return PhosphorIcons.starFour(); // spiritual night energy
    }
  }
}
