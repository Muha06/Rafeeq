import 'dart:math';

class QiblaCalculator {
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  static double calculate({
    required double latitude,
    required double longitude,
  }) {
    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(kaabaLatitude);

    final deltaLongitude = _toRadians(kaabaLongitude - longitude);

    final y = sin(deltaLongitude) * cos(lat2);

    final x =
        cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLongitude);

    final bearing = atan2(y, x);

    // Convert radians → degrees
    var degrees = _toDegrees(bearing);

    // Normalize to 0–360°
    degrees = (degrees + 360) % 360;

    return degrees;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  static double _toDegrees(double radians) {
    return radians * 180 / pi;
  }
}
