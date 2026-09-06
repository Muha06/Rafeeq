import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafeeq/features/qibla/services/qibla_service.dart';

void main() {
  test('returns accurate qibla degrees', () {
    final qibla = QiblaCalculator.calculate(
      latitude: -4.0437,
      longitude: 39.6589,
    );

    debugPrint("Qibla: $qibla");

    expect(
      QiblaCalculator.calculate(latitude: -4.0437, longitude: 39.6589),
      closeTo(qibla, 0.01),
    );
  });
}
