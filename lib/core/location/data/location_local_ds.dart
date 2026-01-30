import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:rafeeq/core/location/domain/user_location.dart';

class LocationLocalDataSource {
  final Box settingsBox;
  LocationLocalDataSource(this.settingsBox);

  static const _kLat = 'user_loc_lat';
  static const _kLng = 'user_loc_lng';
  static const _kCity = 'user_loc_city';
  static const _kCountry = 'user_loc_country';
  static const _kTimezone = 'user_loc_tz';
  static const _kIsAuto = 'user_loc_is_auto';

  Future<UserLocation?> read() async {
    final latRaw = settingsBox.get(_kLat);
    final lngRaw = settingsBox.get(_kLng);

    final lat = (latRaw is num) ? latRaw.toDouble() : null;
    final lng = (lngRaw is num) ? lngRaw.toDouble() : null;

    if (lat == null || lng == null) return null;

    return UserLocation(
      lat: lat,
      lng: lng,
      city: (settingsBox.get(_kCity) as String?) ?? '',
      country: (settingsBox.get(_kCountry) as String?) ?? '',
      timezone: (settingsBox.get(_kTimezone) as String?) ?? 'Africa/Nairobi',
      isAuto: (settingsBox.get(_kIsAuto) as bool?) ?? false,
    );
  }

  Future<void> write(UserLocation loc) async {
    await settingsBox.put(_kLat, loc.lat);
    await settingsBox.put(_kLng, loc.lng);
    await settingsBox.put(_kCity, loc.city);
    await settingsBox.put(_kCountry, loc.country);
    await settingsBox.put(_kTimezone, loc.timezone);
    await settingsBox.put(_kIsAuto, loc.isAuto);
    debugPrint('Hive wrote');
  }

  Future<void> clear() async {
    await settingsBox.delete(_kLat);
    await settingsBox.delete(_kLng);
    await settingsBox.delete(_kCity);
    await settingsBox.delete(_kCountry);
    await settingsBox.delete(_kTimezone);
    await settingsBox.delete(_kIsAuto);
  }
}
