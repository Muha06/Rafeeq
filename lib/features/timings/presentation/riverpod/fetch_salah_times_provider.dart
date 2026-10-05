import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/calculation_methods_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/wiring_provider.dart';

final fetchTodaySalahTimesProvider = FutureProvider<SalahTimesEntity>((
  ref,
) async {
  final fetchTimesUsecase = ref.watch(fetchSalahTimesUsecase);

  final userLocation = await ref.watch(userLocationProvider.future);

  final result = await fetchTimesUsecase.fetchTodayByCoords(
    userLocation: userLocation,
    method: ref.watch(selectedCalculationMethodProvider).id,
  );

  return result;
});
