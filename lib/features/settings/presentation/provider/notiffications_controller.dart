// notifications_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/general_notifications_provider.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

/// ---------------- Salah Notif Controller ----------------
/// Manages Salah reminder state + Hive persistence + permission handling
class SalahNotifController extends Notifier<bool> {
  @override
  bool build() {
    // Initial state: read from Hive and check system notifications
    final box = ref.read(settingsBoxProvider);
    final allowed = ref.read(systemNotifAccessProvider).notificationsAllowed;
    if (!allowed) return false;
    return box.get(kSalahEnabled, defaultValue: false) as bool;
  }

  /// Enable or disable Salah notifications
  Future<void> toggleSalahReminders(
    bool enabled,
    BuildContext context, {
    bool? showSnack = true,
  }) async {
    final updating = ref.read(salahNotifUpdatingProvider);
    if (updating) return; // prevent double taps

    ref.read(salahNotifUpdatingProvider.notifier).state = true;

    try {
      final access = ref.read(systemNotifAccessProvider);
      final sys = ref.read(systemNotifAccessProvider.notifier);
      final box = ref.read(settingsBoxProvider);

      // DISABLE
      if (!enabled) {
        await box.put(kSalahEnabled, false);
        state = false; // update provider state for UI
        return;
      }

      // ENABLE: check system permissions
      if (!access.notificationsAllowed || !access.exactAlarmsAllowed) {
        final allAllowed = await sys.requestAll(includeExactAlarms: true);
        if (!allAllowed) {
          // Permission denied, keep OFF
          await box.put(kSalahEnabled, false);
          state = false;

          if (showSnack != null && showSnack) {
            AppSnackBar.showSimple(
              context: context,
              isDark: ref.read(isDarkProvider),
              message: 'Notification permissions denied.',
            );
          }
          return;
        }
      }

      // Permission ok -> enable
      await box.put(kSalahEnabled, true);
      state = true; // update UI

      if (showSnack != null && showSnack) {
        AppSnackBar.showSimple(
          context: context,
          isDark: ref.read(isDarkProvider),
          message: 'Scheduling Salah reminders...',
        );
      }
    } finally {
      ref.read(salahNotifUpdatingProvider.notifier).state = false;
    }
  }
}

/// Provider for UI to watch Salah reminder state
final salahNotifControllerProvider =
    NotifierProvider<SalahNotifController, bool>(SalahNotifController.new);

/// ---------------- Adhkar Notif Controller ----------------
/// Manages Adhkar reminders (morning + evening)
class AdhkarNotifController extends Notifier<bool> {
  @override
  bool build() {
    final box = ref.read(settingsBoxProvider);
    final allowed = ref.read(systemNotifAccessProvider).notificationsAllowed;
    if (!allowed) return false;
    return box.get(kAdhkarEnabled, defaultValue: false) as bool;
  }

  /// Enable or disable Adhkar reminders
  Future<void> toggleAdhkarReminders(
    bool enabled,
    BuildContext context, {
    bool showSnack = true,
  }) async {
    final updating = ref.read(adhkarNotifUpdatingProvider);
    if (updating) return;

    ref.read(adhkarNotifUpdatingProvider.notifier).state = true;

    try {
      final access = ref.read(systemNotifAccessProvider);
      final sys = ref.read(systemNotifAccessProvider.notifier);
      final box = ref.read(settingsBoxProvider);

      // DISABLE
      if (!enabled) {
        await box.put(kAdhkarEnabled, false);
        state = false;
        return;
      }

      // ENABLE: check system permissions
      if (!access.notificationsAllowed || !access.exactAlarmsAllowed) {
        final allAllowed = await sys.requestAll(includeExactAlarms: true);
        if (!allAllowed) {
          await box.put(kAdhkarEnabled, false);
          state = false;

          if (showSnack) {
            AppSnackBar.showSimple(
              context: context,
              isDark: ref.read(isDarkProvider),
              message: 'Notification permissions denied.',
            );
          }
          return;
        }
      }

      // Permission ok -> enable
      await box.put(kAdhkarEnabled, true);
      state = true;

      if (showSnack) {
        AppSnackBar.showSimple(
          context: context,
          isDark: ref.read(isDarkProvider),
          message: '✅ Turning on Adhkar reminders...',
        );
      }
    } finally {
      ref.read(adhkarNotifUpdatingProvider.notifier).state = false;
    }
  }
}

/// Provider for UI to watch Adhkar reminder state
final adhkarNotifControllerProvider =
    NotifierProvider<AdhkarNotifController, bool>(AdhkarNotifController.new);
