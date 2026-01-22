import 'package:rafeeq/features/salat-times/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_status.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';

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

    if (!nxtStart.isAfter(curStart)) continue;

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

  // Handle night segment: Isha -> Midnight -> Fajr
  final ishaStart = times.at(SalahPrayer.isha);
  final fajrToday = times.at(SalahPrayer.fajr);
  final fajrTomorrow = fajrToday.add(const Duration(days: 1));

  // Case A: After Isha (today)
  if (!now.isBefore(ishaStart)) {
    final totalSeconds = fajrTomorrow.difference(ishaStart).inSeconds;
    final midnight = ishaStart.add(Duration(seconds: totalSeconds ~/ 2));

    // Isha -> Midnight
    if (now.isBefore(midnight)) {
      final total = midnight.difference(ishaStart).inSeconds;
      final done = now.difference(ishaStart).inSeconds;
      final progress = total <= 0 ? 0.0 : (done / total).clamp(0.0, 1.0);

      return SalahStatusEntity(
        current: SalahPrayer.isha,
        next: SalahPrayer.midnight,
        currentStart: ishaStart,
        nextStart: midnight,
        timeToNext: midnight.difference(now),
        progress: progress,
      );
    }

    // Midnight -> Fajr (tomorrow)
    final total = fajrTomorrow.difference(midnight).inSeconds;
    final done = now.difference(midnight).inSeconds;
    final progress = total <= 0 ? 0.0 : (done / total).clamp(0.0, 1.0);

    return SalahStatusEntity(
      current: SalahPrayer.midnight,
      next: SalahPrayer.fajr,
      currentStart: midnight,
      nextStart: fajrTomorrow,
      timeToNext: fajrTomorrow.difference(now),
      progress: progress,
    );
  }

  // Case B: Before Fajr (after midnight but before fajr, same night)
  // Treat current as "midnight", next as Fajr today.
  final ishaYesterday = ishaStart.subtract(const Duration(days: 1));
  final totalSeconds = fajrToday.difference(ishaYesterday).inSeconds;
  final midnight = ishaYesterday.add(Duration(seconds: totalSeconds ~/ 2));

  // If we're before midnight (rare edge if times mismatch), show Isha -> Midnight
  if (now.isBefore(midnight)) {
    final total = midnight.difference(ishaYesterday).inSeconds;
    final done = now.difference(ishaYesterday).inSeconds;
    final progress = total <= 0 ? 0.0 : (done / total).clamp(0.0, 1.0);

    return SalahStatusEntity(
      current: SalahPrayer.isha,
      next: SalahPrayer.midnight,
      currentStart: ishaYesterday,
      nextStart: midnight,
      timeToNext: midnight.difference(now),
      progress: progress,
    );
  }

  // Midnight -> Fajr today
  final total = fajrToday.difference(midnight).inSeconds;
  final done = now.difference(midnight).inSeconds;
  final progress = total <= 0 ? 0.0 : (done / total).clamp(0.0, 1.0);

  return SalahStatusEntity(
    current: SalahPrayer.midnight,
    next: SalahPrayer.fajr,
    currentStart: midnight,
    nextStart: fajrToday,
    timeToNext: fajrToday.difference(now),
    progress: progress,
  );
}
