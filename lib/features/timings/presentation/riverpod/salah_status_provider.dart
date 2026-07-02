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
  bool _didRegisterDispose = false;

  @override
  DateTime build() {
    if (!_didRegisterDispose) {
      ref.onDispose(() {
        _timer?.cancel();
      });
      _didRegisterDispose = true;
    }

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

    // schedule
    // Wait until the next minute starts, 
    // then update the state to trigger a rebuild
    _timer = Timer(delay, () {
      // After the delay, update the state
      state = DateTime.now();

      _scheduleNextTick();
    });
  }
}

final salahStatusProvider =
    AsyncNotifierProvider<SalahStatusNotifier, SalahStatusEntity>(
      SalahStatusNotifier.new,
    );

/// combines (today timings + now) -> SalahStatusEntity
class SalahStatusNotifier extends AsyncNotifier<SalahStatusEntity> {
  Timer? _boundaryTimer;
  bool _didRegisterDispose = false;

  @override
  Future<SalahStatusEntity> build() async {
    if (!_didRegisterDispose) {
      ref.onDispose(() {
        _boundaryTimer?.cancel();
      });
      _didRegisterDispose = true;
    }

    final times = await ref.watch(todaySalahTimesProvider.future);
    final status = computeSalahStatus(times: times, now: DateTime.now());

    _scheduleNextStatusRefresh(status.nextStart);

    return status;
  }

  void _scheduleNextStatusRefresh(DateTime nextStart) {
    final now = DateTime.now();
    final delay = nextStart.difference(now);

    _boundaryTimer?.cancel();
    _boundaryTimer = Timer(delay.isNegative ? Duration.zero : delay, () {
      ref.invalidateSelf();
    });
  }
}

final salahTimeToNextProvider = Provider<AsyncValue<Duration>>((ref) {
  final status = ref.watch(salahStatusProvider);
  final now = ref.watch(salahTickerProvider);

  return status.whenData((value) => value.nextStart.difference(now));
});
