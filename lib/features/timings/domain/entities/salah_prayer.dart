import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        return FontAwesomeIcons.cloudMoon;
      case SalahPrayer.sunrise:
        return FontAwesomeIcons.solidSun;
      case SalahPrayer.dhuha:
        return FontAwesomeIcons.sun;
      case SalahPrayer.dhuhr:
        return FontAwesomeIcons.solidSun;
      case SalahPrayer.asr:
        return FontAwesomeIcons.cloudSun;
      case SalahPrayer.maghrib:
        return FontAwesomeIcons.solidMoon;  
      case SalahPrayer.isha:
        return FontAwesomeIcons.moon;
      case SalahPrayer.midnight:
        return FontAwesomeIcons.clock;  
      case SalahPrayer.tahajjud:
        return FontAwesomeIcons.starAndCrescent;
    }
  }
}
