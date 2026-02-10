import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_status.dart';
import 'package:rafeeq/features/timings/domain/usecases/get_salah_status.dart';

import 'salah_times_providers.dart';

/// emits DateTime.now() every second
final salahTickerProvider = StreamProvider<DateTime>((ref) {
  final controller = StreamController<DateTime>();

  // emit immediately
  controller.add(DateTime.now());

  //Timer that emits after every 1 second
  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    controller.add(DateTime.now()); //emit
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

/// combines (today timings + now) -> SalahStatusEntity
final salahStatusProvider = Provider<AsyncValue<SalahStatusEntity>>((ref) {
  final timesAsync = ref.watch(
    todaySalahTimesProvider,
  ); //salahTimesEntity (times)

  final nowAsync = ref.watch(salahTickerProvider); //stream of datetime.now()

  return timesAsync.when(
    loading: () => const AsyncLoading(),
    error: (e, st) => AsyncError(e, st),
    data: (times) => nowAsync.when(
      //times -> SalahTimesEntity
      loading: () => const AsyncLoading(),
      error: (e, st) => AsyncError(e, st),
      data: (now) =>
          AsyncData(computeSalahStatus(times: times, now: now)), //return
    ),
  );
});
