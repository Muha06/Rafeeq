import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/features/qibla/services/qibla_service.dart';
import 'package:riverpod/riverpod.dart';

final qiblaDirectionProvider = FutureProvider<double>((ref) async {
  final location = await ref.watch(userLocationProvider.future);

  return QiblaCalculator.calculate(
    latitude: location.lat,
    longitude: location.lng,
  );
});
