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

  Future<void> refresh() async {
    final repo = ref.read(locationRepositoryProvider);
    final prev = state.value; // keep old
    state = AsyncData(prev); // keep showing
    final newLoc = await repo.refreshLocation();
    state = AsyncData(newLoc);
  }

  Future<void> clear() async {
    final repo = ref.read(locationRepositoryProvider);
    await repo.clear();
    state = const AsyncData(null);
  }
}
