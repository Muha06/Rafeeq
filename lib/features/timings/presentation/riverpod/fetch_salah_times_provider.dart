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

  return await fetchTimesUsecase.fetchTodayByCoords(
    userLocation: userLocation,
    method: ref.read(salahMethodProvider),
  );
});
