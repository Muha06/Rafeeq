import 'package:rafeeq/core/functions/parse_aladhan_timings.dart';
import 'package:rafeeq/salat-times/data/models/salah_times_model.dart';
import 'package:rafeeq/salat-times/domain/entities/salah_times.dart';
import '../../domain/entities/salah_prayer.dart'; 

/* 
This extension to the timings model converts model -> entity 

*/
extension AladhanTimingsModelMapper on AladhanTimingsModel {
  //Method that returns entity model

  SalahTimesEntity toEntity() {
    return SalahTimesEntity(
      date: date, //salat times date
      timezone: timezone, //timezone
      times: {
        SalahPrayer.fajr: parseAladhanTime(raw: fajr, date: date),
        SalahPrayer.dhuhr: parseAladhanTime(raw: dhuhr, date: date),
        SalahPrayer.asr: parseAladhanTime(raw: asr, date: date),
        SalahPrayer.maghrib: parseAladhanTime(raw: maghrib, date: date),
        SalahPrayer.isha: parseAladhanTime(raw: isha, date: date),
      },
    );
  }
}

