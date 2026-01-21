import 'package:rafeeq/features/salat-times/domain/entities/salah_status.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';
import '../entities/salah_prayer.dart';

/* 
accepts times & now() then computes current salah, next & previous

*/
SalahStatusEntity computeSalahStatus({
  required SalahTimesEntity times,
  required DateTime now,
}) {
  final order = const [
    SalahPrayer.fajr,
    SalahPrayer.dhuhr,
    SalahPrayer.asr,
    SalahPrayer.maghrib,
    SalahPrayer.isha,
  ];

  // Normal intervals: [prayer_i, prayer_(i+1))
  for (var i = 0; i < order.length - 1; i++) {
    final cur = order[i]; //current salah
    final nxt = order[i + 1]; //next

    //times of the salat
    final curStart = times.at(cur); // current salah times
    final nxtStart = times.at(nxt); //next salah times

    // Guard against bad ordering
    if (!nxtStart.isAfter(curStart)) continue;

    if (!now.isBefore(curStart) && now.isBefore(nxtStart)) {
      final differenceBtwn2Salahs = nxtStart
          .difference(curStart)
          .inSeconds; //differences btwn the 2 salahs in seconds

      final timePassedFromPrev = now.difference(curStart).inSeconds;

      final progress = differenceBtwn2Salahs <= 0
          ? 0.0
          : (timePassedFromPrev / differenceBtwn2Salahs).clamp(0.0, 1.0);

      return SalahStatusEntity(
        current: cur,
        next: nxt,
        currentStart: curStart,
        nextStart: nxtStart,
        timeToNext: nxtStart.difference(now), //for the counter
        progress: progress,
      );
    }
  }

  // After Isha: next is Fajr tomorrow
  final ishaStart = times.at(SalahPrayer.isha);
  final fajrTomorrow = times.at(SalahPrayer.fajr).add(const Duration(days: 1));

  if (!now.isBefore(ishaStart)) {
    final differenceBtwn2Salahs = fajrTomorrow.difference(ishaStart).inSeconds;
    final timePassedFromIsha = now.difference(ishaStart).inSeconds;

    final progress = differenceBtwn2Salahs <= 0
        ? 0.0
        : (timePassedFromIsha / differenceBtwn2Salahs).clamp(0.0, 1.0);

    return SalahStatusEntity(
      current: SalahPrayer.isha,
      next: SalahPrayer.fajr,
      currentStart: ishaStart,
      nextStart: fajrTomorrow,
      timeToNext: fajrTomorrow.difference(now),
      progress: progress,
    );
  }

  // Before Fajr: current treated as Isha (yesterday), next is Fajr today
  final ishaYesterday = times
      .at(SalahPrayer.isha)
      .subtract(const Duration(days: 1));
  final fajrToday = times.at(SalahPrayer.fajr);

  final differencesBtwn2Salahs = ishaYesterday.difference(fajrToday).inSeconds;

  final timePassedFromIsha = now.isBefore(ishaYesterday)
      ? 0
      : now.difference(ishaYesterday).inSeconds;

  final progress = (timePassedFromIsha / differencesBtwn2Salahs).clamp(
    0.0,
    1.0,
  );

  return SalahStatusEntity(
    current: SalahPrayer.isha,
    next: SalahPrayer.fajr,
    currentStart: ishaYesterday,
    nextStart: fajrToday,
    timeToNext: fajrToday.difference(now),
    progress: progress,
  );
}
