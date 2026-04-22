import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/location/data/location_gps_ds.dart';
import 'package:rafeeq/core/features/location/data/location_local_ds.dart';
import 'package:rafeeq/core/features/location/domain/user_location.dart';
import 'package:rafeeq/core/features/location/domain/user_location_repo.dart';
import 'package:rafeeq/core/features/location/presentation/provider/general_location_permission_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';

// You already have something like this in your app:

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final box = ref.read(settingsBoxProvider);
  return LocationRepositoryImpl(
    local: LocationLocalDataSource(box),
    gps: LocationGpsDataSource(),
  );
});

final userLocationProvider =
    AsyncNotifierProvider<UserLocationNotifier, UserLocation?>(
      UserLocationNotifier.new,
    );

class UserLocationNotifier extends AsyncNotifier<UserLocation?> {
  //
  @override
  Future<UserLocation?> build() async {
    final repo = ref.read(locationRepositoryProvider);

    final cachedLocation = await repo.getCachedLocation();

    //If cached is null return null
    //Set user fallback
    if (cachedLocation == null) {
      setManual(
        lat: 24.4672,
        lng: 39.6111,
        city: 'Madinah',
        country: 'Saudi Arabia',
        timezone: 'Ksa/Medinah',
      );
      return null;
    }

    return cachedLocation;
  }

  //
  //refresh
  Future<void> refresh() async {
    final repo = ref.read(locationRepositoryProvider);
    final prev = state.value; // keep old
    state = AsyncData(prev); // keep showing
    final newLoc = await repo.getCurrentLocation();
    state = AsyncData(newLoc);
  }

  /// Save manual selection (from Open-Meteo pick)
  Future<void> setManual({
    required double lat,
    required double lng,
    required String city,
    required String country,
    String? timezone,
  }) async {
    final repo = ref.read(locationRepositoryProvider);

    final loc = UserLocation(
      lat: lat,
      lng: lng,
      city: city,
      country: country,
      timezone: timezone ?? 'Africa/Nairobi',
      isAuto: false,
    );

    await repo.saveLocation(loc);
    state = AsyncData(loc);
  }

  /// Switch back to auto mode (GPS)
  Future<void> setAuto() async {
    final access = ref.read(systemLocationAccessProvider.notifier);

    final ok = await access.requestLocation();
    if (!ok) {
      throw 'permissions deinied';
      // don’t switch to GPS mode
      // show a snackbar/dialog based on access.state
    }

    final repo = ref.read(locationRepositoryProvider);
    final loc = await repo.getCurrentLocation();
    state = AsyncData(loc);
  }
}
