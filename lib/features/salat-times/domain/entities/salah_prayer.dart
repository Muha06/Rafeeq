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
