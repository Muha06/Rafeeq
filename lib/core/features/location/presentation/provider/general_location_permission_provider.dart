import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart'; // settingsBoxProvider

const kLocationAllowedKey = 'location_allowed';
const kLocationServiceEnabledKey = 'location_service_enabled';
const kLocationPermanentlyDeniedKey = 'location_perm_denied_forever';

final systemLocationAccessProvider =
    NotifierProvider<SystemLocationAccessNotifier, SystemLocationAccessState>(
      SystemLocationAccessNotifier.new,
    );

class SystemLocationAccessState {
  const SystemLocationAccessState({
    required this.locationAllowed,
    required this.serviceEnabled,
    required this.permanentlyDenied,
    this.isLoading = false,
  });

  /// True if you can actually use GPS now.
  final bool locationAllowed;

  /// Whether OS Location Services toggle is ON.
  final bool serviceEnabled;

  /// Permission == deniedForever.
  final bool permanentlyDenied;

  final bool isLoading;

  SystemLocationAccessState copyWith({
    bool? locationAllowed,
    bool? serviceEnabled,
    bool? permanentlyDenied,
    bool? isLoading,
  }) {
    return SystemLocationAccessState(
      locationAllowed: locationAllowed ?? this.locationAllowed,
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      permanentlyDenied: permanentlyDenied ?? this.permanentlyDenied,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SystemLocationAccessNotifier extends Notifier<SystemLocationAccessState> {
  Box get _box => ref.read(settingsBoxProvider);

  @override
  SystemLocationAccessState build() {
    // cached values for fast startup
    final cachedAllowed =
        _box.get(kLocationAllowedKey, defaultValue: false) as bool;
    final cachedService =
        _box.get(kLocationServiceEnabledKey, defaultValue: false) as bool;
    final cachedDeniedForever =
        _box.get(kLocationPermanentlyDeniedKey, defaultValue: false) as bool;

    return SystemLocationAccessState(
      locationAllowed: cachedAllowed,
      serviceEnabled: cachedService,
      permanentlyDenied: cachedDeniedForever,
      isLoading: false,
    );
  }

  Future<void> _persist({
    required bool locationAllowed,
    required bool serviceEnabled,
    required bool permanentlyDenied,
  }) async {
    await _box.put(kLocationAllowedKey, locationAllowed);
    await _box.put(kLocationServiceEnabledKey, serviceEnabled);
    await _box.put(kLocationPermanentlyDeniedKey, permanentlyDenied);
  }

  bool _isGranted(LocationPermission p) =>
      p == LocationPermission.whileInUse || p == LocationPermission.always;

  /// Re-check OS state + persist to Hive
  Future<void> sync() async {
    state = state.copyWith(isLoading: true);

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final perm = await Geolocator.checkPermission();

    final permanentlyDenied = perm == LocationPermission.deniedForever;
    final granted = _isGranted(perm);

    final locationAllowed = serviceEnabled && granted;

    await _persist(
      locationAllowed: locationAllowed,
      serviceEnabled: serviceEnabled,
      permanentlyDenied: permanentlyDenied,
    );

    state = state.copyWith(
      locationAllowed: locationAllowed,
      serviceEnabled: serviceEnabled,
      permanentlyDenied: permanentlyDenied,
      isLoading: false,
    );
  }

  /// Ask for location permission, then sync.
  /// Returns true if location is truly allowed after sync.
  Future<bool> requestLocation() async {
    state = state.copyWith(isLoading: true);

    // 1) SERVICES
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();

      final enabledNow = await Geolocator.isLocationServiceEnabled();
      if (!enabledNow) {
        await _persist(
          serviceEnabled: false,
          locationAllowed: false,
          permanentlyDenied: state.permanentlyDenied,
        );
        state = state.copyWith(
          serviceEnabled: false,
          locationAllowed: false,
          isLoading: false,
        );
        return false;
      }

      await _persist(
        serviceEnabled: true,
        locationAllowed: false,
        permanentlyDenied: state.permanentlyDenied,
      );
      state = state.copyWith(serviceEnabled: true, locationAllowed: false);
    }

    // 2) PERMISSIONS
    var perm = await Geolocator.checkPermission();

    if (perm == LocationPermission.deniedForever) {
      await _persist(
        locationAllowed: false,
        serviceEnabled: true,
        permanentlyDenied: true,
      );
      state = state.copyWith(
        locationAllowed: false,
        permanentlyDenied: true,
        isLoading: false,
      );
      return false;
    }

    if (!_isGranted(perm)) {
      perm = await Geolocator.requestPermission();
      if (!_isGranted(perm)) {
        final deniedForever = perm == LocationPermission.deniedForever;
        await _persist(
          locationAllowed: false,
          serviceEnabled: true,
          permanentlyDenied: deniedForever,
        );
        state = state.copyWith(
          locationAllowed: false,
          permanentlyDenied: deniedForever,
          isLoading: false,
        );
        return false;
      }
    }

    await sync();
    return state.locationAllowed;
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
    await sync();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
    await sync();
  }
}
