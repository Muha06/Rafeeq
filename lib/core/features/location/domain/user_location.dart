/// App-level location used across features (Salat times, Qibla, Ramadan, etc.)
class UserLocation {
  final double lat;
  final double lng;

  /// Human-friendly label (can be empty if not resolved yet)
  final String city;
  final String country;

  /// True = GPS/auto,
  final bool isAuto;

  const UserLocation({
    required this.lat,
    required this.lng,
    required this.city,
    required this.country,
    required this.isAuto,
  });

  UserLocation copyWith({
    double? lat,
    double? lng,
    String? city,
    String? country,
    bool? isAuto,
  }) {
    return UserLocation(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      city: city ?? this.city,
      country: country ?? this.country,
      isAuto: isAuto ?? this.isAuto,
    );
  }

  // /// A safe fallback you can ship with (Nairobi)
  // static const fallback = UserLocation(
  //   lat: 000000,
  //   lng: 000000,
  //   city: 'fallback',
  //   country: 'fallback',
  //   isAuto: false,
  // );
}
