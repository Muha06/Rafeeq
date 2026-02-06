import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rafeeq/core/location/presentation/provider/user_location_provider.dart';

final locationPermissionProvider =
    NotifierProvider<LocationPermissionNotifier, LocationPermissionState>(
      LocationPermissionNotifier.new,
    );

class LocationPermissionState {
  const LocationPermissionState({
    required this.status,
    this.isLoading = false,
    this.servicesEnabled = true,
  });

  final PermissionStatus status;
  final bool isLoading;
  final bool servicesEnabled;

  bool get isGranted => status.isGranted;
  bool get isDenied => status.isDenied;
  bool get isPermanentlyDenied => status.isPermanentlyDenied;

  LocationPermissionState copyWith({
    PermissionStatus? status,
    bool? isLoading,
    bool? servicesEnabled,
  }) {
    return LocationPermissionState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      servicesEnabled: servicesEnabled ?? this.servicesEnabled,
    );
  }
}

class LocationPermissionNotifier extends Notifier<LocationPermissionState> {
  @override
  LocationPermissionState build() {
    return const LocationPermissionState(
      status: PermissionStatus.denied,
      servicesEnabled: true,
    );
  }

  Future<void> refresh() async {
    final status = await Permission.locationWhenInUse.status;
    final enabled = await Geolocator.isLocationServiceEnabled();
    state = state.copyWith(status: status, servicesEnabled: enabled);
  }

  Future<void> _ensureServicesOn() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (enabled) {
      state = state.copyWith(servicesEnabled: true);
      return;
    }

    state = state.copyWith(servicesEnabled: false);

    // Open system settings so user can toggle it on
    await Geolocator.openLocationSettings();

    // Re-check after returning
    final enabledAfter = await Geolocator.isLocationServiceEnabled();
    state = state.copyWith(servicesEnabled: enabledAfter);
  }

  Future<PermissionStatus> request() async {
    state = state.copyWith(isLoading: true);

    // 1) Ask permission
    final result = await Permission.locationWhenInUse.request();
    state = state.copyWith(status: result);

    if (!result.isGranted) {
      state = state.copyWith(isLoading: false);
      return result;
    }

    // 2) Ensure services are ON
    await _ensureServicesOn();

    // 3) Only fetch/store location if services are actually enabled
    if (state.servicesEnabled) {
      await ref.read(userLocationProvider.notifier).setAuto();
    }

    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<void> openSettings() async {
    await openAppSettings();
    await refresh();
  }
}
