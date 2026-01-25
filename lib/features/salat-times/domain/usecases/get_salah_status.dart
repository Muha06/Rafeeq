import 'package:rafeeq/features/salat-times/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_status.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';

SalahStatusEntity computeSalahStatus({
  required SalahTimesEntity times,
  required DateTime now,
}) {
  SalahStatusEntity buildStatus({
    required SalahPrayer current,
    required SalahPrayer next,
    required DateTime currentStart,
    required DateTime nextStart,
  }) {
    final total = nextStart.difference(currentStart).inSeconds;
    final done = now.difference(currentStart).inSeconds;
    final progress = total <= 0 ? 0.0 : (done / total).clamp(0.0, 1.0);

    return SalahStatusEntity(
      current: current,
      next: next,
      currentStart: currentStart,
      nextStart: nextStart,
      timeToNext: nextStart.difference(now),
      progress: progress,
    );
  }

  // ---------- DAY MODE ----------
  final fajrToday = times.at(SalahPrayer.fajr);
  final ishaToday = times.at(SalahPrayer.isha);

  final dayOrder = const [
    SalahPrayer.fajr,
    SalahPrayer.sunrise,
    SalahPrayer.dhuha,
    SalahPrayer.dhuhr,
    SalahPrayer.asr,
    SalahPrayer.maghrib,
    SalahPrayer.isha,
  ];

  // If we're between Fajr and Isha, normal loop works
  if (!now.isBefore(fajrToday) && now.isBefore(ishaToday)) {
    for (var i = 0; i < dayOrder.length - 1; i++) {
      final cur = dayOrder[i];
      final nxt = dayOrder[i + 1];

      final curStart = times.at(cur);
      final nxtStart = times.at(nxt);

      if (now.isBefore(curStart) || !now.isBefore(nxtStart)) continue;

      return buildStatus(
        current: cur,
        next: nxt,
        currentStart: curStart,
        nextStart: nxtStart,
      );
    }
  }

  // ---------- NIGHT MODE HELPERS ----------
  DateTime computeMidnight(DateTime ishaStart, DateTime fajrStart) {
    final totalSeconds = fajrStart.difference(ishaStart).inSeconds;
    return ishaStart.add(Duration(seconds: totalSeconds ~/ 2));
  }

  DateTime alignTahajjudToNight({
    required DateTime ishaStart,
    required DateTime midnight,
    required DateTime tahajjudRaw,
    required DateTime fajrStart,
  }) {
    var t = tahajjudRaw;

    // If tahajjud time is earlier than isha, it's after midnight -> next day
    if (t.isBefore(ishaStart)) t = t.add(const Duration(days: 1));

    // Safety: ensure it's inside the night window and after midnight
    if (t.isBefore(midnight)) t = midnight;
    if (!t.isBefore(fajrStart)) {
      t = fajrStart.subtract(const Duration(minutes: 1));
    }

    return t;
  }

  // ---------- NIGHT MODE A: AFTER ISHA ----------
  if (!now.isBefore(ishaToday)) {
    final fajrTomorrow = fajrToday.add(const Duration(days: 1));

    final midnight = computeMidnight(ishaToday, fajrTomorrow);

    final tahajjudRaw = times.at(SalahPrayer.tahajjud);
    final tahajjud = alignTahajjudToNight(
      tahajjudRaw: tahajjudRaw,
      ishaStart: ishaToday,
      fajrStart: fajrTomorrow,
      midnight: midnight,
    );

    // Isha -> Midnight
    if (now.isBefore(midnight)) {
      return buildStatus(
        current: SalahPrayer.isha,
        next: SalahPrayer.midnight,
        currentStart: ishaToday,
        nextStart: midnight,
      );
    }

    // Midnight -> Tahajjud
    if (now.isBefore(tahajjud)) {
      return buildStatus(
        current: SalahPrayer.midnight,
        next: SalahPrayer.tahajjud,
        currentStart: midnight,
        nextStart: tahajjud,
      );
    }

    // Tahajjud -> Fajr (tomorrow)
    return buildStatus(
      current: SalahPrayer.tahajjud,
      next: SalahPrayer.fajr,
      currentStart: tahajjud,
      nextStart: fajrTomorrow,
    );
  }

  // ---------- NIGHT MODE B: BEFORE FAJR ----------
  // now < fajrToday here (since we didn't return in day mode)
  final ishaYesterday = ishaToday.subtract(const Duration(days: 1));
  final midnight = computeMidnight(ishaYesterday, fajrToday);

  final tahajjudRaw = times.at(SalahPrayer.tahajjud); // e.g. today 02:30
  final tahajjud = alignTahajjudToNight(
    tahajjudRaw: tahajjudRaw,
    ishaStart: ishaYesterday,
    fajrStart: fajrToday,
    midnight: midnight,
  );

  // Isha -> Midnight (rare edge)
  if (now.isBefore(midnight)) {
    return buildStatus(
      current: SalahPrayer.isha,
      next: SalahPrayer.midnight,
      currentStart: ishaYesterday,
      nextStart: midnight,
    );
  }

  // Midnight -> Tahajjud
  if (now.isBefore(tahajjud)) {
    return buildStatus(
      current: SalahPrayer.midnight,
      next: SalahPrayer.tahajjud,
      currentStart: midnight,
      nextStart: tahajjud,
    );
  }

  // Tahajjud -> Fajr (today)
  return buildStatus(
    current: SalahPrayer.tahajjud,
    next: SalahPrayer.fajr,
    currentStart: tahajjud,
    nextStart: fajrToday,
  );
}
