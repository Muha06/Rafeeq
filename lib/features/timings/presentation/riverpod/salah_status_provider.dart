import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_status.dart';
import 'package:rafeeq/features/timings/domain/usecases/get_salah_status.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/fetch_salah_times_provider.dart';

final nowProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
});

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
    debugPrint("SalahStatusNotifier.build() called");
    
    if (!_didRegisterDispose) {
      ref.onDispose(() {
        _boundaryTimer?.cancel();
      });
      _didRegisterDispose = true;
    }

    final times = await ref.watch(fetchTodaySalahTimesProvider.future);
    final status = computeSalahStatus(times: times, now: DateTime.now());

    _scheduleNextStatusRefresh(status.nextStart);

    return status;
  }

  // Refreshes the SalahStatusEntity when the next Salah time is reached
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
  final now = ref.watch(nowProvider).value ?? DateTime.now();

  return status.whenData((status) => status.nextStart.difference(now));
});
