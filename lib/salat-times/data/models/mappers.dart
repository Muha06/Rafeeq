import 'package:rafeeq/core/functions/parse_aladhan_timings.dart';
import 'package:rafeeq/salat-times/data/models/cached_salah_times_hive.dart';
import 'package:rafeeq/salat-times/data/models/salah_times_model.dart';
import 'package:rafeeq/salat-times/domain/entities/salah_times.dart';
import '../../domain/entities/salah_prayer.dart';

/* 
This extension to the timings model converts REMOTE model -> entity 
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

//HIVE MODEL -> ENTITY
extension CachedSalahTimesHiveX on CachedSalahTimesHive {
  SalahTimesEntity toEntity() {
    return SalahTimesEntity(
      date: date,
      timezone: timezone,
      times: {
        SalahPrayer.fajr: fajr,
        SalahPrayer.dhuhr: dhuhr,
        SalahPrayer.asr: asr,
        SalahPrayer.maghrib: maghrib,
        SalahPrayer.isha: isha,
      },
    );
  }

  static CachedSalahTimesHive fromEntity({
    required SalahTimesEntity entity,
    required String city,
    required String country,
    required int method,
  }) {
    return CachedSalahTimesHive(
      date: CachedSalahTimesHive.normalizeDate(entity.date),
      city: city,
      country: country,
      method: method,
      timezone: entity.timezone,
      fajr: entity.at(SalahPrayer.fajr),
      dhuhr: entity.at(SalahPrayer.dhuhr),
      asr: entity.at(SalahPrayer.asr),
      maghrib: entity.at(SalahPrayer.maghrib),
      isha: entity.at(SalahPrayer.isha),
      cachedAt: DateTime.now(),
    );
  }
}
