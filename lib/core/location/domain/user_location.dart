/// App-level location used across features (Salat times, Qibla, Ramadan, etc.)
class UserLocation {
  final double lat;
  final double lng;

  /// Human-friendly label (can be empty if not resolved yet)
  final String city;
  final String country;

  /// Usually from prayer API meta.timezone (optional but useful)
  final String timezone;

  /// True = GPS/auto, False = user selected manually
  final bool isAuto;

  const UserLocation({
    required this.lat,
    required this.lng,
    required this.city,
    required this.country,
    required this.timezone,
    required this.isAuto,
  });

  UserLocation copyWith({
    double? lat,
    double? lng,
    String? city,
    String? country,
    String? timezone,
    bool? isAuto,
  }) {
    return UserLocation(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      city: city ?? this.city,
      country: country ?? this.country,
      timezone: timezone ?? this.timezone,
      isAuto: isAuto ?? this.isAuto,
    );
  }

  /// Handy for logs/debug
  @override
  String toString() =>
      'UserLocation(lat: $lat, lng: $lng, city: $city, country: $country, timezone: $timezone, isAuto: $isAuto)';

  /// You can use this to decide whether to refresh location
  bool isCloseTo(UserLocation other, {double epsilon = 0.0005}) {
    return (lat - other.lat).abs() < epsilon &&
        (lng - other.lng).abs() < epsilon;
  }

  /// A safe fallback you can ship with (Nairobi)
  static const fallback = UserLocation(
    lat: 000000,
    lng: 000000,
    city: 'fallback',
    country: 'fallback',
    timezone: 'fallback',
    isAuto: false,
  );
}
