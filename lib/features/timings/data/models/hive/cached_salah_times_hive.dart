import 'package:hive/hive.dart';

part 'cached_salah_times_hive.g.dart';

@HiveType(typeId: 41)
class CachedSalahTimesHive extends HiveObject {
  @HiveField(0)
  final DateTime date; // ✅ date for the timings (normalized to midnight)

  @HiveField(1)
  final String city;

  @HiveField(2)
  final String country;

  @HiveField(3)
  final int method;

  @HiveField(4)
  final String timezone;

  @HiveField(5)
  final DateTime fajr;

  @HiveField(6)
  final DateTime sunrise;

  @HiveField(7)
  final DateTime dhuha;

  @HiveField(8)
  final DateTime dhuhr;

  @HiveField(9)
  final DateTime asr;

  @HiveField(10)
  final DateTime maghrib;

  @HiveField(11)
  final DateTime isha;

  @HiveField(12)
  final DateTime tahajjud;

  @HiveField(13)
  final DateTime cachedAt;

  CachedSalahTimesHive({
    required this.date,
    required this.city,
    required this.country,
    required this.method,
    required this.timezone,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.dhuha,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.tahajjud,
    required this.cachedAt,
  });

  /// Normalize to midnight so comparisons are easy
  static DateTime normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Use a stable string key for Hive storage
  static String cachedKey({
    required DateTime date,
    required String city,
    required String country,
    required int method,
  }) {
    final n = normalizeDate(date);
    final yyyy = n.year.toString().padLeft(4, '0');
    final mm = n.month.toString().padLeft(2, '0');
    final dd = n.day.toString().padLeft(2, '0');

    return '$yyyy-$mm-$dd|${city.toLowerCase()}|${country.toLowerCase()}|$method';
  }
}
