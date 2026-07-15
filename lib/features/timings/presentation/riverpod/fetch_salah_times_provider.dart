import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/wiring_provider.dart';

final fetchTodaySalahTimesProvider = FutureProvider<SalahTimesEntity>((
  ref,
) async {
  final fetchTimesUsecase = ref.watch(fetchSalahTimesUsecase);

  // Fetch user location
  final userLocation = await ref.watch(userLocationProvider.future);

  final isAuto = userLocation.isAuto;
  if (isAuto) {
    return await fetchTimesUsecase.fetchTodayByCoords(
      latitude: userLocation.lat,
      longitude: userLocation.lng,
      city: userLocation.city,
      country: userLocation.country,
      method: ref.read(salahMethodProvider),
    );
  }

  return fetchTimesUsecase.fetchTodayByCity(
    city: userLocation.city,
    country: userLocation.country,
  );
});
