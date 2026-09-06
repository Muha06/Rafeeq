import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/features/qibla/services/qibla_service.dart';
import 'package:riverpod/riverpod.dart';

final qiblaDirectionProvider = Provider<double>((ref) {
  final location = ref.watch(userLocationProvider).value!;

  return QiblaCalculator.calculate(
    latitude: location.lat,
    longitude: location.lng,
  );
});
