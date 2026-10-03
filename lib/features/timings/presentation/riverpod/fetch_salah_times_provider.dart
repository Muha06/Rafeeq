import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/wiring_provider.dart';

final fetchTodaySalahTimesProvider = FutureProvider<SalahTimesEntity>((
  ref,
) async {
  debugPrint('📍 fetchTodaySalahTimesProvider started');

  final fetchTimesUsecase = ref.watch(fetchSalahTimesUsecase);

  debugPrint('📍 Waiting for user location...');

  final userLocation = await ref.watch(userLocationProvider.future);

  debugPrint(
    '📍 Location received: '
    '${userLocation.lat}, ${userLocation.lng}',
  );

  debugPrint('🕌 Fetching Salah times...');

  final result = await fetchTimesUsecase.fetchTodayByCoords(
    userLocation: userLocation,
    method: ref.read(salahMethodProvider),
  );

  debugPrint('✅ Salah times fetched: ${result.date}');

  return result;
});
