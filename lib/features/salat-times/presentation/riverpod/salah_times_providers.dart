import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rafeeq/app/salat_notifications.dart';
import 'package:rafeeq/core/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/features/salat-times/data/datasources/salah_remote_ds.dart';
import 'package:rafeeq/features/salat-times/data/repository/salah_repo_impl.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';
import 'package:rafeeq/features/salat-times/domain/repository/get_today_salah_times_repo.dart';
import 'package:rafeeq/features/salat-times/domain/usecases/get_today_salah_times.dart';
import 'package:rafeeq/features/salat-times/presentation/riverpod/cached_salah_providers.dart';

/// 1) External client
final httpClientProvider = Provider.autoDispose<http.Client>((ref) {
  return http.Client();
});

/// 2) Remote DS
final salahRemoteDataSourceProvider = Provider<SalahRemoteDataSource>((ref) {
  return SalahRemoteDataSourceImpl(ref.read(httpClientProvider));
});

/// 3) Repository
final salahTimesRepositoryProvider = Provider<SalahTimesRepository>((ref) {
  return SalahTimesRepositoryImpl(
    remote: ref.read(salahRemoteDataSourceProvider),
    local: ref.read(salahCacheLocalProvider),
  );
});

/// 4) Usecase
final getTodaySalahTimesProvider = Provider<GetTodaySalahTimes>((ref) {
  return GetTodaySalahTimes(ref.read(salahTimesRepositoryProvider));
});

final salahMethodProvider = Provider<int>((ref) => 3);

final todaySalahTimesProvider = FutureProvider<SalahTimesEntity>((ref) async {
  final usecase = ref.read(getTodaySalahTimesProvider);
  final loc = await ref.watch(userLocationProvider.future);

  // fallback if reverse geocode returns empty/Unknown
  final city = (loc.city.trim().isEmpty || loc.city == 'Unknown')
      ? 'Nairobi'
      : loc.city;
  final country = (loc.country.trim().isEmpty || loc.country == 'Unknown')
      ? 'Kenya'
      : loc.country;

  return usecase.call(
    latitude: loc.lat,
    longitude: loc.lng,
    city: city,
    country: country,
    method: ref.read(salahMethodProvider),
  );
});

final salahNotificationsSchedulerProvider = Provider<void>((ref) {
  //listen to todaySalahTimesProvider & schedules when data  arrives
  ref.listen<AsyncValue<SalahTimesEntity>>(todaySalahTimesProvider, (
    prev,
    next,
  ) {
    next.whenData((times) async {
      await SalahNotifications.instance.scheduleForToday(
        times: times,
        remindBeforeMinutes: 0, // or 10
      );
    });
  });
});
