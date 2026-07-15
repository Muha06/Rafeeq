import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/timings/domain/usecases/salat_notifications_repo.dart';
import 'package:rafeeq/features/settings/presentation/provider/notiffications_controller.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/disable_salah_reminders_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/fetch_salah_times_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/wiring_provider.dart';

// //SINGLE SALAT NOTIFICATIONS SCHEDULER    PROVIDER
// //LISTENS TO 2 PROVIDERS: TIMESPROVIDER & USER SET SETTINGS
final salahNotifSchedulerProvider =
    NotifierProvider<SalahNotificationsController, void>(
      SalahNotificationsController.new,
    );

class SalahNotificationsController extends Notifier<void> {
  SalahNotifSchedulerService get salahNotifsService =>
      ref.read(salahNotifSchedulerServiceProvider);
  bool get _notificationsEnabled => ref.read(salahNotifControllerProvider);

  Set<SalahPrayer> get _disabledPrayers =>
      ref.watch(disabledSalahPrayersProvider);

  @override
  void build() {
    _listenToSalahTimes(); // listen salah times
    _listenToNotificationToggle(); // listen user settings
    _listenToDisabledPrayers(); // listen disabled salah
  }

  // listen to salah times updates
  void _listenToSalahTimes() {
    ref.listen(fetchTodaySalahTimesProvider, (_, next) {
      debugPrint("Satah times changed!");
      next.whenData(_onSalahTimesChanged);
    });
  }

  // listen to user settings
  void _listenToNotificationToggle() {
    ref.listen(salahNotifControllerProvider, (_, enabled) {
      debugPrint("Toggled Salah notifications!");

      _onNotificationToggle(enabled);
    });
  }

  // listen to Disabled times updates
  void _listenToDisabledPrayers() {
    ref.listen(disabledSalahPrayersProvider, (_, disabled) {
      debugPrint("Disabled salahs changed !");
      debugPrint("$disabled");

      _onDisabledPrayersChanged(disabled);
    });
  }

  // On salah times changed
  Future<void> _onSalahTimesChanged(SalahTimesEntity times) async {
    if (!_notificationsEnabled) {
      await _cancelAll();
      return;
    }

    // Schedule
    await _schedule(times);
  }

  // On salah times changed
  Future<void> _onNotificationToggle(bool enabled) async {
    if (!enabled) {
      await _cancelAll();
      return;
    }

    final times = await ref.read(fetchTodaySalahTimesProvider.future);
    await _schedule(times);
  }

  Future<void> _onDisabledPrayersChanged(Set<SalahPrayer> disabled) async {
    if (!_notificationsEnabled) return;

    final times = await ref.read(fetchTodaySalahTimesProvider.future);

    await salahNotifsService.scheduleForToday(times: times, disabled: disabled);
  }

  // Helper
  Future<void> _schedule(SalahTimesEntity times) async {
    await salahNotifsService.scheduleForToday(
      times: times,
      disabled: _disabledPrayers,
    );
  }

  Future<void> _cancelAll() => salahNotifsService.cancelAll();
}
