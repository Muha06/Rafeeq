import 'package:flutter/material.dart';
import 'package:rafeeq/core/location/data/location_gps_ds.dart';
import 'package:rafeeq/core/location/data/location_local_ds.dart';
import 'package:rafeeq/core/location/domain/user_location.dart';

abstract class LocationRepository {
  /// Returns cached location fast (or fallback if none)
  Future<UserLocation?> getCachedLocation();

  /// Refresh using GPS + reverse geocode, then cache it
  Future<UserLocation> refreshLocation();

  /// Clear cached location (optional)
  Future<void> clear();
}

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource local;
  final LocationGpsDataSource gps;

  LocationRepositoryImpl({required this.local, required this.gps});

  @override
  Future<UserLocation?> getCachedLocation() async {
    // debugPrint('Getting cached location');
    // final hiveLoc = await local.read();
    // debugPrint('Hive loc: ${hiveLoc?.city}, ${hiveLoc?.country}');

    // if (hiveLoc != null) return hiveLoc;

    try {
      debugPrint('Hive is null → refreshing once...');

      final refreshed = await refreshLocation();
      debugPrint('Refreshed: ${refreshed.city}, ${refreshed.country}');
      return refreshed;
    } catch (e) {
      debugPrint('Refresh failed: $e');
      return null;
    }
  }

  @override
  Future<UserLocation> refreshLocation() async {
    try {
      debugPrint('📍 Step 1: getCurrentPosition()...');
      final pos = await gps.getCurrentPosition();
      debugPrint(
        '📍 Position: ${pos.latitude},${pos.longitude} acc=${pos.accuracy} ts=${pos.timestamp}',
      );

      debugPrint('🗺️ Step 2: reverseGeocode()...');
      final (city, country) = await gps.reverseGeocode(
        lat: pos.latitude,
        lng: pos.longitude,
      );
      debugPrint('🗺️ Geocoded: $city, $country');

      final loc = UserLocation(
        lat: pos.latitude,
        lng: pos.longitude,
        city: city,
        country: country,
        timezone: 'Africa/Nairobi',
        isAuto: true,
      );

      debugPrint('✅ Step 3: About to write...');
      await local.write(loc);
      debugPrint('✅ Step 4: Wrote to Hive');

      return loc;
    } catch (e, st) {
      debugPrint('❌ refreshLocation failed: $e');
      debugPrint('$st');
      rethrow;
    }
  }

  @override
  Future<void> clear() => local.clear();
}
