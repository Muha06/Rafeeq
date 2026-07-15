import 'package:flutter/material.dart';
import 'package:rafeeq/core/features/location/data/location_gps_ds.dart';
import 'package:rafeeq/core/features/location/data/location_local_ds.dart';
import 'package:rafeeq/core/features/location/domain/user_location.dart';

abstract class LocationRepository {
  /// Returns cached location fast (or fallback if none)
  Future<UserLocation?> getCachedLocation();

  /// Refresh using GPS + reverse geocode, then cache it
  Future<UserLocation> refreshCurrentLocation();

  Future<void> saveLocation(UserLocation loc);

  /// Clear cached location (optional)
  Future<void> clear();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource local;
  final LocationGpsDataSource gps;

  LocationRepositoryImpl({required this.local, required this.gps});
  @override
  Future<UserLocation> getCachedLocation() async {
    try {
      // 1) try local cache first
      final cached = await local.read();

      if (cached != null) {
        debugPrint('Using cached location: ${cached.city}, ${cached.country}');
        return cached;
      }

      debugPrint('No cached location → returning fallback');

      // return fallback
      const fallbackLoc = UserLocation(
        lat: 24.4672,
        lng: 39.6111,
        city: 'Madinah',
        country: 'Saudi Arabia',
         isAuto: false,
      );

      return fallbackLoc;
    } catch (e) {
      debugPrint('Error Fetching cached location $e');
      rethrow;
    }
  }

  @override
  Future<void> saveLocation(UserLocation loc) async {
    debugPrint('❤️ Saving User location to local');
    await local.write(loc);
  }

  // Refreshes current location
  // Called if user allowed location permissions
  @override
  Future<UserLocation> refreshCurrentLocation() async {
    try {
      final pos = await gps.getCurrentPosition();

      // convert to city & country
      final (city, country) = await gps.reverseGeocode(
        lat: pos.latitude,
        lng: pos.longitude,
      );

      final loc = UserLocation(
        lat: pos.latitude,
        lng: pos.longitude,
        city: city,
        country: country,
         isAuto: true,
      );

      await local.write(loc);

      return loc;
    } catch (e, st) {
      debugPrint('$st');
      rethrow;
    }
  }

  @override
  Future<void> clear() => local.clear();
}
