import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_status.dart';
import 'package:rafeeq/features/timings/domain/usecases/get_salah_status.dart';
import 'salah_times_providers.dart';

final salahTickerProvider = NotifierProvider<SalahTickerNotifier, DateTime>(
  SalahTickerNotifier.new,
);

class SalahTickerNotifier extends Notifier<DateTime> {
  Timer? _timer;

  @override
  DateTime build() {
    _scheduleNextTick();
    return DateTime.now();
  }

  void _scheduleNextTick() {
    final now = DateTime.now();

    final nextMinute = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 1,
    );

    final delay = nextMinute.difference(now);

    _timer?.cancel();

    //schedule
    _timer = Timer(delay, () {
      state = DateTime.now();

      // reschedule forever
      _scheduleNextTick();
    });

    ref.onDispose(() {
      _timer?.cancel();
    });
  }
}

final salahStatusProvider =
    AsyncNotifierProvider<SalahStatusNotifier, SalahStatusEntity>(
      SalahStatusNotifier.new,
    );

/// combines (today timings + now) -> SalahStatusEntity
class SalahStatusNotifier extends AsyncNotifier<SalahStatusEntity> {
  @override
  Future<SalahStatusEntity> build() async {
    final times = await ref.watch(todaySalahTimesProvider.future);

    final now = ref.watch(salahTickerProvider);

    return computeSalahStatus(times: times, now: now);
  }
}
