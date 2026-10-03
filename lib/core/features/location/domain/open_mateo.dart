/// ----------------------
/// Model
/// ----------------------
class GeoPlace {
  final String name; // e.g. Nairobi
  final String country; // e.g. Kenya
  final String countryCode; // e.g. KE
  final String? admin1; // e.g. Nairobi Area (optional)
  final double lat;
  final double lng;

  const GeoPlace({
    required this.name,
    required this.country,
    required this.countryCode,
    required this.lat,
    required this.lng,
    this.admin1,
  });

  String get label {
    final a = (admin1 == null || admin1!.trim().isEmpty) ? '' : ', $admin1';
    return '$name$a, $country';
  }

  factory GeoPlace.fromJson(Map<String, dynamic> j) {
    return GeoPlace(
      name: (j['name'] ?? '').toString(),
      country: (j['country'] ?? '').toString(),
      countryCode: (j['country_code'] ?? '').toString(),
      admin1: j['admin1']?.toString(),
      lat: (j['latitude'] as num).toDouble(),
      lng: (j['longitude'] as num).toDouble(),
    );
  }
}
