import 'package:hive/hive.dart';
import 'package:rafeeq/features/quran_reading_plan/domain/entities/quran_log.dart';

part 'quran_log_hive.g.dart';

@HiveType(typeId: 11)
class QuranHiveLog extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  int ayahsRead;

  QuranHiveLog({required this.date, required this.ayahsRead});
}

QuranLog mapHiveLog(QuranHiveLog hiveLog) {
  return QuranLog(date: hiveLog.date, ayahsRead: hiveLog.ayahsRead);
}

QuranHiveLog mapDomainLog(QuranLog log) {
  return QuranHiveLog(date: log.date, ayahsRead: log.ayahsRead);
}
