import 'package:rafeeq/salat-times/domain/entities/salah_status.dart';
import 'package:rafeeq/salat-times/domain/entities/salah_times.dart';

import '../entities/salah_prayer.dart'; 
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
    final cur = order[i];
    final nxt = order[i + 1];

    final curStart = times.at(cur);
    final nxtStart = times.at(nxt);

    if (!now.isBefore(curStart) && now.isBefore(nxtStart)) {
      final total = nxtStart.difference(curStart).inSeconds;
      final done = now.difference(curStart).inSeconds;
      final progress = total <= 0 ? 0.0 : (done / total).clamp(0.0, 1.0);

      return SalahStatusEntity(
        current: cur,
        next: nxt,
        currentStart: curStart,
        nextStart: nxtStart,
        timeToNext: nxtStart.difference(now),
        progress: progress,
      );
    }
  }

  // After Isha: next is Fajr tomorrow
  final ishaStart = times.at(SalahPrayer.isha);
  final fajrTomorrow = times.at(SalahPrayer.fajr).add(const Duration(days: 1));

  if (!now.isBefore(ishaStart)) {
    final total = fajrTomorrow.difference(ishaStart).inSeconds;
    final done = now.difference(ishaStart).inSeconds;
    final progress = total <= 0 ? 0.0 : (done / total).clamp(0.0, 1.0);

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
  final fajrToday = times.at(SalahPrayer.fajr);
  return SalahStatusEntity(
    current: SalahPrayer.isha,
    next: SalahPrayer.fajr,
    currentStart: fajrToday.subtract(const Duration(hours: 6)), // placeholder
    nextStart: fajrToday,
    timeToNext: fajrToday.difference(now),
    progress: 0.0,
  );
}
