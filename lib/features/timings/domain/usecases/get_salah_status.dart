import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_status.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';

SalahStatusEntity computeSalahStatus({
  required SalahTimesEntity times,
  required DateTime now,
}) {
  SalahStatusEntity buildStatus({
    required SalahPrayer current, // eg dhuhr
    required SalahPrayer next, // eg asr
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
  final isAfterFajr = !now.isBefore(fajrToday);
  final isBeforeIsha = now.isBefore(ishaToday);

  if (isAfterFajr && isBeforeIsha) {
    for (var i = 0; i < dayOrder.length - 1; i++) {
      final currentSalah = dayOrder[i];
      final nextSalah = dayOrder[i + 1];

      final currentStart = times.at(currentSalah);
      final nextStart = times.at(nextSalah);

      if (now.isBefore(currentStart) || !now.isBefore(nextStart)) {
        continue;
      } // skip if we're not in this window

      return buildStatus(
        current: currentSalah,
        currentStart: currentStart,
        next: nextSalah,
        nextStart: nextStart,
      );
    }
  }

  // ---------- NIGHT MODE HELPERS ----------
  DateTime computeMidnight(DateTime ishaStart, DateTime fajrStart) {
    final totalSeconds = fajrStart.difference(ishaStart).inSeconds;
    final halfSeconds = totalSeconds ~/ 2;

    return ishaStart.add(Duration(seconds: halfSeconds));
  }

  // Aligns tahajjud to the night window,
  //ensuring it's after isha and before fajr
  DateTime alignTahajjudToNight({
    required DateTime ishaStart,
    required DateTime midnight,
    required DateTime tahajjud,
    required DateTime fajrStart,
  }) {
    // If tahajjud time is earlier than isha, it's after midnight -> next day
    if (tahajjud.isBefore(ishaStart)) {
      tahajjud = tahajjud.add(const Duration(days: 1));
    }

    // Safety: ensure it's inside the night window and after midnight
    if (tahajjud.isBefore(midnight)) tahajjud = midnight;
    if (!tahajjud.isBefore(fajrStart)) {
      tahajjud = fajrStart.subtract(const Duration(minutes: 1));
    }

    return tahajjud;
  }

  // ---------- NIGHT MODE A: AFTER ISHA ----------
  if (!now.isBefore(ishaToday)) {
    final fajrTomorrow = fajrToday.add(const Duration(days: 1));

    final midnight = computeMidnight(ishaToday, fajrTomorrow);

    final tahajjudRaw = times.at(SalahPrayer.tahajjud);
    final tahajjud = alignTahajjudToNight(
      tahajjud: tahajjudRaw,
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
    tahajjud: tahajjudRaw,
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
