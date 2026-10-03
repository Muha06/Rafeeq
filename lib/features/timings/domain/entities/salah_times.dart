import 'salah_prayer.dart';

class SalahTimesEntity {
  final DateTime date; //date for the timings
  final String timezone;
  final Map<SalahPrayer, DateTime> times; //timings

  const SalahTimesEntity({
    required this.date,
    required this.timezone,
    required this.times,
  });

  DateTime at(SalahPrayer prayer) => times[prayer]!;
}
