 import 'package:rafeeq/core/location/data/location_gps_ds.dart';
import 'package:rafeeq/core/location/data/user_loc_local.ds.dart';
import 'package:rafeeq/core/location/domain/user_location.dart';

abstract class LocationRepository {
  /// Returns cached location fast (or fallback if none)
  Future<UserLocation> getCachedLocation();

  /// Saves location (manual or auto)
  Future<void> saveLocation(UserLocation location);

  /// Refresh using GPS + reverse geocode, then cache it
  Future<UserLocation> refreshAutoLocation();

  /// Clear cached location (optional)
  Future<void> clear();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource local;
  final LocationGpsDataSource gps;

  LocationRepositoryImpl({required this.local, required this.gps});

  @override
  Future<UserLocation> getCachedLocation() async {
    return (await local.read()) ?? UserLocation.fallback;
  }

  @override
  Future<void> saveLocation(UserLocation location) => local.write(location);

  @override
  Future<UserLocation> refreshAutoLocation() async {
    final pos = await gps.getPosition();
    final (city, country) = await gps.reverseGeocode(
      lat: pos.latitude,
      lng: pos.longitude,
    );

    // timezone: keep cached one for now, your prayer API will return meta.timezone later
    final cached = await local.read();

    final loc = UserLocation(
      lat: pos.latitude,
      lng: pos.longitude,
      city: city,
      country: country,
      timezone: cached?.timezone ?? 'Africa/Nairobi',
      isAuto: true,
    ); 
    await local.write(loc);
    return loc;
  }

  @override
  Future<void> clear() => local.clear();
}
