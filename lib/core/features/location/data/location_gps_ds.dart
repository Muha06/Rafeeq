import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationGpsDataSource {
  Future<Position> getCurrentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Location services disabled');
    }

    final perm = await Geolocator.checkPermission();
    final allowed =
        perm == LocationPermission.whileInUse ||
        perm == LocationPermission.always;

    if (!allowed) {
      throw Exception('Location permission not granted');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 60),
    );
  }

  Future<(String city, String country)> reverseGeocode({
    required double lat,
    required double lng,
  }) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    final p = placemarks.first;

    final city = (p.locality?.trim().isNotEmpty ?? false)
        ? p.locality!.trim()
        : (p.subAdministrativeArea?.trim().isNotEmpty ?? false)
        ? p.subAdministrativeArea!.trim()
        : 'Unknown';

    final country = (p.country?.trim().isNotEmpty ?? false)
        ? p.country!.trim()
        : 'Unknown';

    return (city, country);
  }
}
