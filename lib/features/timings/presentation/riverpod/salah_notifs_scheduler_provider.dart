import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/timings/domain/entities/prayer_calculation_method.dart';
import 'package:rafeeq/features/timings/domain/usecases/salat_notifications_scheduler.dart';
import 'package:rafeeq/features/settings/presentation/provider/notiffications_controller.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/calculation_methods_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/disable_salah_reminders_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/fetch_salah_times_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/wiring_provider.dart';
import 'package:rafeeq/features/user/presentation/providers/user_provider.dart';

// //SINGLE SALAT NOTIFICATIONS SCHEDULER PROVIDER
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
      ref.read(disabledSalahPrayersProvider);

  @override
  void build() {
    _listenToSalahTimes(); // listen salah times
    _listenToNotificationToggle(); // listen user settings
    _listenToDisabledPrayers(); // listen disabled salah
    _listenToCalculationMethods();
  }

  // listen to salah times updates
  void _listenToSalahTimes() {
    ref.listen(fetchSalahTimesProvider(DateTime.now()), (_, next) {
      debugPrint("Salah times changed!");

      _onSalahTimesChanged();
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

      _onDisabledPrayersChanged();
    });
  }

  // listen to calculation methods
  void _listenToCalculationMethods() {
    ref.listen(selectedCalculationMethodProvider, (_, newMethod) {
      debugPrint("Calculation Methods changed !");

      _onCalculationMethodChanged(newMethod);
    });
  }

  // On Calculation method changed
  Future<void> _onCalculationMethodChanged(
    PrayerCalculationMethod newMethod,
  ) async {
    if (!_notificationsEnabled) {
      await _cancelAllPrayerReminders();
      return;
    }

    // Schedule
    await _cancelAllPrayerReminders();
    await _schedule();
  }

  // On salah times changed
  Future<void> _onSalahTimesChanged() async {
    if (!_notificationsEnabled) {
      await _cancelAllPrayerReminders();
      return;
    }

    // Schedule
    await _schedule();
  }

  // On salah times changed
  Future<void> _onNotificationToggle(bool enabled) async {
    if (!enabled) {
      // If just disabled => cancel all salah notifications
      await _cancelAllPrayerReminders();
      return;
    }

    await _schedule();
  }

  Future<void> _onDisabledPrayersChanged() async {
    if (!_notificationsEnabled) return;

    await _cancelAllPrayerReminders();
    await _schedule();
  }

  // Helper
  // Should schedule notifs for 3 days
  Future<void> _schedule() async {
    debugPrint("Scheduling Salah notifications for 3 days...");

    final today = DateUtils.dateOnly(DateTime.now());

    final times = await ref.read(fetchSalahTimesProvider(today).future);

    await salahNotifsService.scheduleForDay(
      times: times,
      username: ref.read(userNameProvider),
      disabled: _disabledPrayers,
    );
  }

  Future<void> _cancelAllPrayerReminders() =>
      salahNotifsService.cancelAllPrayerReminders();
}
