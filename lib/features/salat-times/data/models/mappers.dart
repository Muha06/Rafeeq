import 'package:rafeeq/core/helpers/salat_times.dart';
import 'package:rafeeq/features/salat-times/data/models/hive/cached_salah_times_hive.dart';
import 'package:rafeeq/features/salat-times/data/models/salah_times_model.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';
import '../../domain/entities/salah_prayer.dart';

/* 
MODEL -> ENTITY 
*/

extension AladhanTimingsModelMapper on AladhanTimingsModel {
  //Method that returns entity model

  SalahTimesEntity toEntity() {
 
   final sunriseDT = parseAladhanTime(raw: sunrise, date: date);

    return SalahTimesEntity(
      date: date,
      timezone: timezone,
      times: {
        SalahPrayer.fajr: parseAladhanTime(raw: fajr, date: date),
        SalahPrayer.sunrise: sunriseDT,
        SalahPrayer.dhuha: sunriseDT.add(const Duration(minutes: 20)),
        SalahPrayer.dhuhr: parseAladhanTime(raw: dhuhr, date: date),
        SalahPrayer.asr: parseAladhanTime(raw: asr, date: date),
        SalahPrayer.maghrib: parseAladhanTime(raw: maghrib, date: date),
        SalahPrayer.isha: parseAladhanTime(raw: isha, date: date),
        SalahPrayer.tahajjud: parseAladhanTime(raw: tahajjud, date: date),
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
        SalahPrayer.sunrise: sunrise,
        SalahPrayer.dhuha: dhuha,
        SalahPrayer.dhuhr: dhuhr,
        SalahPrayer.asr: asr,
        SalahPrayer.maghrib: maghrib,
        SalahPrayer.isha: isha,
        SalahPrayer.tahajjud: tahajjud,
      },
    );
  }

  //ENTITY -> HIVE MODEL
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
      sunrise: entity.at(SalahPrayer.sunrise),
      dhuha: entity.at(SalahPrayer.dhuha),
      dhuhr: entity.at(SalahPrayer.dhuhr),
      asr: entity.at(SalahPrayer.asr),
      maghrib: entity.at(SalahPrayer.maghrib),
      isha: entity.at(SalahPrayer.isha),
      tahajjud: entity.at(SalahPrayer.tahajjud),
      cachedAt: DateTime.now(),
    );
  }
}
