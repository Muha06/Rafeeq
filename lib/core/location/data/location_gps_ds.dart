 
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationGpsDataSource {
  Future<Position> getPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) throw Exception('Location services are disabled');

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
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
