// notifications_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/local_notifications/providers/general_notifications_provider.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';

/// ---------------- Salah Notif Controller ----------------
/// Manages Salah reminder state + Hive persistence + permission handling
class SalahNotifController extends Notifier<bool> {
  @override
  bool build() {
    // Initial state: read from Hive and check system notifications
    final box = ref.read(settingsBoxProvider);
    final allowed = ref
        .read(notificationPermissionProvider)
        .notificationsAllowed;
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
      final access = ref.read(notificationPermissionProvider);
      final sys = ref.read(notificationPermissionProvider.notifier);
      final box = ref.read(settingsBoxProvider);

      // DISABLE
      if (!enabled) {
        await box.put(kSalahEnabled, false);
        state = false; // update provider state for UI
        RafeeqAnalytics.logFeature("disable_salah_reminders");
        return;
      }

      // ENABLE: check system permissions first
      final notifDisabled = !access.notificationsAllowed;
      final exactDisabled = !access.exactAlarmsAllowed;

      if (notifDisabled || exactDisabled) {
        // Request permissions
        final allAllowed = await sys.requestAll(includeExactAlarms: true);

        // Permission denied, keep OFF
        final stillDisabled = !allAllowed;

        if (stillDisabled) {
          await box.put(kSalahEnabled, false);
          state = false;
          debugPrint('Permissions not granted not toggling salah reminders on');

          if (!context.mounted) return;

          if (showSnack == false) return;

          AppToast.showCompact(
            context: context,
            message: 'Notification permissions denied.',
          );

          return;
        }
      }

      // Permission allowed -> enable
      await box.put(kSalahEnabled, true);
      state = true; // update UI
      RafeeqAnalytics.logFeature("enable_salah_reminders");
      if (!context.mounted) return;

      if (showSnack == true) {
        AppToast.showCompact(
          context: context,
          message: 'Scheduling Salah reminders',
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
    final allowed = ref
        .read(notificationPermissionProvider)
        .notificationsAllowed;
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
      final access = ref.read(notificationPermissionProvider);
      final sys = ref.read(notificationPermissionProvider.notifier);
      final box = ref.read(settingsBoxProvider);

      // DISABLE
      if (!enabled) {
        await box.put(kAdhkarEnabled, false);
        state = false;
        RafeeqAnalytics.logFeature("disable_adhkar_reminders");
        return;
      }

      // ENABLE: check system permissions
      if (!access.notificationsAllowed || !access.exactAlarmsAllowed) {
        final allAllowed = await sys.requestAll(includeExactAlarms: true);
        if (!allAllowed) {
          await box.put(kAdhkarEnabled, false);
          state = false;

          if (showSnack && context.mounted) {
            AppToast.showCompact(
              context: context,
              message: 'Notification permissions denied.',
            );
          }
          return;
        }
      }

      // Permission allowed -> enable
      await box.put(kAdhkarEnabled, true);
      state = true;
      RafeeqAnalytics.logFeature("enable_adhkar_reminders");

      if (showSnack && context.mounted) {
        AppToast.showCompact(
          context: context,
          message: 'Turning on Adhkar reminders...',
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
