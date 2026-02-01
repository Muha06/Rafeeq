import 'package:flutter/material.dart';
import 'package:rafeeq/core/location/data/location_gps_ds.dart';
import 'package:rafeeq/core/location/data/location_local_ds.dart';
import 'package:rafeeq/core/location/domain/user_location.dart';

abstract class LocationRepository {
  /// Returns cached location fast (or fallback if none)
  Future<UserLocation?> getCachedLocation();

  /// Refresh using GPS + reverse geocode, then cache it
  Future<UserLocation> refreshLocation();

  Future<void> saveLocation(UserLocation loc);

  /// Clear cached location (optional)
  Future<void> clear();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource local;
  final LocationGpsDataSource gps;

  LocationRepositoryImpl({required this.local, required this.gps});
  @override
  Future<UserLocation?> getCachedLocation() async {
    try {
      // 1) try local cache first
      final cached = await local.read();

      if (cached != null) {
        debugPrint('Using cached location: ${cached.city}, ${cached.country}');
        return cached;
      }

      debugPrint('No cached location → refreshing once...');
      final refreshed = await refreshLocation();

      return refreshed;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveLocation(UserLocation loc) async {
    debugPrint('❤️Saving User locationn to local');
    await local.write(loc);
  }

  @override
  Future<UserLocation> refreshLocation() async {
    try {
      final pos = await gps.getCurrentPosition();

      final (city, country) = await gps.reverseGeocode(
        lat: pos.latitude,
        lng: pos.longitude,
      );

      final loc = UserLocation(
        lat: pos.latitude,
        lng: pos.longitude,
        city: city,
        country: country,
        timezone: '$country/$city',
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
