import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:rafeeq/app/notifications.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';

const kAppNotifsAllowedKey = 'app_notifs_allowed';
const kExactAlarmsAllowedKey = 'exact_alarms_allowed';

final systemNotifAccessProvider =
    NotifierProvider<SystemNotifAccessNotifier, SystemNotifAccessState>(
      SystemNotifAccessNotifier.new,
    );

class SystemNotifAccessState {
  const SystemNotifAccessState({
    required this.notificationsAllowed,
    required this.exactAlarmsAllowed,
    this.notifPermanentlyDenied = false,
    this.isLoading = false,
  });

  final bool notificationsAllowed;
  final bool exactAlarmsAllowed;
  final bool notifPermanentlyDenied;
  final bool isLoading;

  SystemNotifAccessState copyWith({
    bool? notificationsAllowed,
    bool? exactAlarmsAllowed,
    bool? notifPermanentlyDenied,
    bool? isLoading,
  }) {
    return SystemNotifAccessState(
      notificationsAllowed: notificationsAllowed ?? this.notificationsAllowed,
      exactAlarmsAllowed: exactAlarmsAllowed ?? this.exactAlarmsAllowed,
      notifPermanentlyDenied:
          notifPermanentlyDenied ?? this.notifPermanentlyDenied,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SystemNotifAccessNotifier extends Notifier<SystemNotifAccessState> {
  Box get _box => ref.read(settingsBoxProvider);

  @override
  SystemNotifAccessState build() {
    // start from cached values (fast startup)
    final cachedNotifs =
        _box.get(kAppNotifsAllowedKey, defaultValue: false) as bool;
    final cachedExact =
        _box.get(kExactAlarmsAllowedKey, defaultValue: false) as bool;

    return SystemNotifAccessState(
      notificationsAllowed: cachedNotifs,
      exactAlarmsAllowed: cachedExact,
      isLoading: false,
    );
  }

  Future<void> _persist({
    required bool notificationsAllowed,
    required bool exactAlarmsAllowed,
  }) async {
    await _box.put(kAppNotifsAllowedKey, notificationsAllowed);
    await _box.put(kExactAlarmsAllowedKey, exactAlarmsAllowed);
  }

  /// Re-check OS state + persist to Hive
  Future<void> sync() async {
    state = state.copyWith(isLoading: true);

    final notifPerm = await Permission.notification.status;

    final notifGranted = notifPerm.isGranted;
    final permanentlyDenied = notifPerm.isPermanentlyDenied;

    // OS-level enabled toggle
    final notifsEnabled = await NotificationService.instance
        .areNotificationsEnabled();

    final notificationsAllowed = notifGranted && notifsEnabled;

    final exactAlarmsAllowed = await NotificationService.instance
        .canScheduleExactAlarms();

    await _persist(
      notificationsAllowed: notificationsAllowed,
      exactAlarmsAllowed: exactAlarmsAllowed,
    );

    state = state.copyWith(
      notificationsAllowed: notificationsAllowed,
      exactAlarmsAllowed: exactAlarmsAllowed,
      notifPermanentlyDenied: permanentlyDenied,
      isLoading: false,
    );
  }

  /// Ask for notifications permission, then sync.
  /// Returns true if notifications are truly allowed after sync.
  Future<bool> requestNotifications() async {
    state = state.copyWith(isLoading: true);

    final current = await Permission.notification.status;
    if (current.isPermanentlyDenied) {
      state = state.copyWith(isLoading: false);
      return false;
    }

    final res = await Permission.notification.request();

    // If denied, persist false and stop
    if (!res.isGranted) {
      await _persist(
        notificationsAllowed: false,
        exactAlarmsAllowed: state.exactAlarmsAllowed,
      );
      state = state.copyWith(notificationsAllowed: false, isLoading: false);
      return false;
    }

    // granted → sync to include OS toggle check
    await sync();
    return state.notificationsAllowed;
  }

  /// Request exact alarms permission via NotificationService, then sync.
  /// Returns true if exact alarms allowed after sync.
  Future<bool> requestExactAlarms() async {
    state = state.copyWith(isLoading: true);

    final already = await NotificationService.instance.canScheduleExactAlarms();
    if (!already) {
      await NotificationService.instance.requestExactAlarmsPermission();
    }

    await sync();
    return state.exactAlarmsAllowed;
  }

  Future<void> openSettings() async {
    await openAppSettings();
    await sync();
  }

  /// Request notifications, then (optionally) exact alarms.
  /// Updates global state + persists it.
  /// Returns whether the requested requirements are satisfied.
  Future<bool> requestAll({bool includeExactAlarms = true}) async {
    final notifOk = await requestNotifications();

    bool exactOk = false;
    if (includeExactAlarms) {
      // only meaningful if notifications are allowed anyway
      exactOk = notifOk ? await requestExactAlarms() : false;
    }

    // after requesting, sync + persist the truth
    await _persist(notificationsAllowed: notifOk, exactAlarmsAllowed: exactOk);

    return notifOk && exactOk;
  }
}
