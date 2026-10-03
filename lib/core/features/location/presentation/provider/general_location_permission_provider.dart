import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

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
  @override
  SystemLocationAccessState build() {
    Future.microtask(sync);

    return const SystemLocationAccessState(
      locationAllowed: false,
      serviceEnabled: false,
      permanentlyDenied: false,
      isLoading: true,
    );
  }

  bool _isGranted(LocationPermission p) =>
      p == LocationPermission.whileInUse || p == LocationPermission.always;

  /// Re-check OS state
  Future<void> sync() async {
    state = state.copyWith(isLoading: true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final perm = await Geolocator.checkPermission(); //  loc permission

      final permanentlyDenied = perm == LocationPermission.deniedForever;
      final granted = _isGranted(perm);

      final locationAllowed = serviceEnabled && granted;

      state = state.copyWith(
        locationAllowed: locationAllowed,
        serviceEnabled: serviceEnabled,
        permanentlyDenied: permanentlyDenied,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  /// Ask for location permission, then sync.
  Future<bool> requestLocationAccess() async {
    state = state.copyWith(isLoading: true);

    // 1) SERVICES
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings(); // Open settings

      final enabledNow = await Geolocator.isLocationServiceEnabled(); // recheck
      if (!enabledNow) {
        state = state.copyWith(
          serviceEnabled: false,
          locationAllowed: false,
          isLoading: false,
        );
        return false;
      }

      state = state.copyWith(serviceEnabled: true, locationAllowed: false);
    }

    // 2) PERMISSIONS
    var perm = await Geolocator.checkPermission();

    // Permanently denied
    if (perm == LocationPermission.deniedForever) {
      state = state.copyWith(
        locationAllowed: false,
        permanentlyDenied: true,
        isLoading: false,
      );
      return false;
    }

    // Permission denied
    if (!_isGranted(perm)) {
      perm = await Geolocator.requestPermission();
      if (!_isGranted(perm)) {
        final deniedForever = perm == LocationPermission.deniedForever;

        state = state.copyWith(
          locationAllowed: false,
          permanentlyDenied: deniedForever,
          isLoading: false,
        );
        return false;
      }
    }

    // Permission granted => sync
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
