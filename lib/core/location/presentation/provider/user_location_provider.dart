import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/location/data/location_gps_ds.dart';
import 'package:rafeeq/core/location/data/location_local_ds.dart';
import 'package:rafeeq/core/location/domain/user_location.dart';
import 'package:rafeeq/core/location/domain/user_location_repo.dart';
import 'package:rafeeq/features/settings/presentation/provider/notifcation_provider.dart';

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
  @override
  Future<UserLocation?> build() async {
    final repo = ref.read(locationRepositoryProvider);

    return repo.getCachedLocation();
  }

  //refresh
  Future<void> refresh() async {
    final repo = ref.read(locationRepositoryProvider);
    final prev = state.value; // keep old
    state = AsyncData(prev); // keep showing
    final newLoc = await repo.refreshLocation();
    state = AsyncData(newLoc);
  }

  /// ✅ Save manual selection (from Open-Meteo pick)
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

  /// ✅ Switch back to auto mode (GPS)
  Future<void> setAuto() async {
    final repo = ref.read(locationRepositoryProvider);

    final prev = state.value;
    state = AsyncData(prev);

    final loc = await repo.refreshLocation(); // this refetches user location
    state = AsyncData(loc);
  }

  Future<void> clear() async {
    final repo = ref.read(locationRepositoryProvider);
    await repo.clear();
    state = const AsyncData(null);
  }
}
