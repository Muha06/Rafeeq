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
    final locality = p.locality;
    final subAdministrativeArea = p.subAdministrativeArea;

    final city = (locality?.trim().isNotEmpty ?? false)
        ? p.locality!.trim()
        : (subAdministrativeArea?.trim().isNotEmpty ?? false)
        ? subAdministrativeArea!.trim()
        : 'Unknown city';

    final country = (p.country?.trim().isNotEmpty ?? false)
        ? p.country!.trim()
        : 'Unknown country';

    return (city, country);
  }
}
