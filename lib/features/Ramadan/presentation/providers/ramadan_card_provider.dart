import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/Ramadan/domain/ramadan_times_entity.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/salah_times_providers.dart';

final ramadanTimesProvider = Provider<AsyncValue<RamadanTimesEntity>>((ref) {
  final timesAsync = ref.watch(todaySalahTimesProvider); //fetch timings

  return timesAsync.whenData((times) {
    final map = times.times;

    final suhurEnd = map[SalahPrayer.fajr];
    final iftar = map[SalahPrayer.maghrib];

    if (suhurEnd == null || iftar == null) {
      throw StateError('Missing Fajr or Maghrib in today times.');
    }

    return RamadanTimesEntity(suhurEnd: suhurEnd, iftar: iftar);
  });
});
