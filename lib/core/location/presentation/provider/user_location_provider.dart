import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rafeeq/core/location/data/location_gps_ds.dart';
import 'package:rafeeq/core/location/data/user_loc_local.ds.dart';
import 'package:rafeeq/core/location/domain/user_location.dart';
import 'package:rafeeq/core/location/domain/user_location_repo.dart';

// You already have something like this in your app:
final settingsBoxProvider = Provider<Box>((ref) => Hive.box('settingsBox'));

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final box = ref.read(settingsBoxProvider);
  return LocationRepositoryImpl(
    local: LocationLocalDataSource(box),
    gps: LocationGpsDataSource(),
  );
});

final userLocationProvider = FutureProvider<UserLocation>((ref) async {
  final repo = ref.read(locationRepositoryProvider);
  return repo.getCachedLocation();
});

final refreshUserLocationProvider = FutureProvider<UserLocation>((ref) async {
  final repo = ref.read(locationRepositoryProvider);
  final loc = await repo.refreshAutoLocation();
  ref.invalidate(userLocationProvider); // force refetch everywhere
  return loc;
});
