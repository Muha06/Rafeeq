import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/location/data/location_gps_ds.dart';
import 'package:rafeeq/core/features/location/data/location_local_ds.dart';
import 'package:rafeeq/core/features/location/domain/user_location.dart';
import 'package:rafeeq/core/features/location/domain/location_repo.dart';
import 'package:rafeeq/core/features/location/presentation/provider/general_location_permission_provider.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
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
    AsyncNotifierProvider<UserLocationNotifier, UserLocation>(
      UserLocationNotifier.new,
    );

class UserLocationNotifier extends AsyncNotifier<UserLocation> {
  LocationRepository get _locationRepo => ref.read(locationRepositoryProvider);

  @override
  Future<UserLocation> build() async {
    final cachedLocation = await _locationRepo.getCachedLocation();

    return cachedLocation;
  }

  //refresh
  Future<void> refresh() async {
    final newLoc = await _locationRepo.refreshCurrentLocation();
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
    // Set Manual location
    final loc = UserLocation(
      lat: lat,
      lng: lng,
      city: city,
      country: country,
      isAuto: false,
    );

    await _locationRepo.saveLocation(loc);
    RafeeqAnalytics.logFeature('set-manual-location');

    state = AsyncData(loc);
  }

  /// Switch back to auto mode (GPS)
  Future<bool> setAuto() async {
    // check permissions
    final access = ref.read(systemLocationAccessProvider.notifier);

    final ok = await access.requestLocationAccess();

    if (!ok) {
      return false;
    }

    final loc = await _locationRepo.refreshCurrentLocation();
    state = AsyncData(loc);

    RafeeqAnalytics.logFeature('set-auto-location');

    return true;
  }
}
