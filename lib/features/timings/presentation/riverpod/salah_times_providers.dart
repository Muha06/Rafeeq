import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rafeeq/app/salat_notifications_repo.dart';
import 'package:rafeeq/core/features/location/domain/user_location.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/notiffications_controller.dart';
import 'package:rafeeq/features/timings/data/datasources/salah_remote_ds.dart';
import 'package:rafeeq/features/timings/data/repository/salah_repo_impl.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/domain/repository/get_today_salah_times_repo.dart';
import 'package:rafeeq/features/timings/domain/usecases/get_today_salah_times.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/cached_salah_providers.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/disable_salah_reminders_provider.dart';

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

const kMadinahFallback = UserLocation(
  lat: 24.4672,
  lng: 39.6111,
  city: 'Madinah',
  country: 'Saudi Arabia',
  timezone: 'Ksa/Medinah',
  isAuto: false,
);

//Fetches salats timings
final todaySalahTimesProvider = FutureProvider<SalahTimesEntity>((ref) async {
  final usecase = ref.watch(getTodaySalahTimesProvider);

  // Just await the future directly
  var loc = await ref.watch(userLocationProvider.future);

  // If null → set fallback
  if (loc == null) {
    await ref
        .read(userLocationProvider.notifier)
        .setManual(
          lat: kMadinahFallback.lat,
          lng: kMadinahFallback.lng,
          city: kMadinahFallback.city,
          country: kMadinahFallback.country,
        );

    // re-read updated value
    loc = await ref.watch(userLocationProvider.future);
  }

  return usecase(
    latitude: loc!.lat,
    longitude: loc.lng,
    city: loc.city,
    country: loc.country,
    method: ref.read(salahMethodProvider),
  ).timeout(const Duration(seconds: 30));
});

//SINGLE SALAT NOTIFICATIONS SCHEDULER CONTROLLER  PROVIDER
//LISTENS TO 2 PROVIDERS: TIMESPROVIDER & USER SET SETTINGS
final salahNotificationsControllerProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<SalahTimesEntity>>(todaySalahTimesProvider, (
    prev,
    next,
  ) {
    final enabled = ref.read(salahNotifControllerProvider);

    if (!enabled) {
      SalahNotifications.instance.cancelAll();
      return;
    }

    next.whenData((times) async {
      final enabled = ref.read(salahNotifControllerProvider);

      if (!enabled) return;

      final disabled = ref.read(
        disabledSalahPrayersProvider,
      ); // ✅ fresh disabled salahs

      await SalahNotifications.instance.scheduleForToday(
        times: times,
        disabled: disabled,
      );
    });
  });

  ref.listen<bool>(salahNotifControllerProvider, (prev, next) async {
    if (!next) {
      await SalahNotifications.instance.cancelAll();
      return;
    }

    final times = await ref.read(todaySalahTimesProvider.future);
    if (!ref.read(salahNotifControllerProvider)) return;

    final disabled = ref.read(disabledSalahPrayersProvider); // ✅ fresh

    await SalahNotifications.instance.scheduleForToday(
      times: times,
      disabled: disabled,
    );
  });

  ref.listen<Set<SalahPrayer>>(disabledSalahPrayersProvider, (
    prev,
    next,
  ) async {
    if (!ref.read(salahNotifControllerProvider)) return;

    final times = await ref.read(todaySalahTimesProvider.future);
    if (!ref.read(salahNotifControllerProvider)) return;

    await SalahNotifications.instance.scheduleForToday(
      times: times,
      disabled: next,
    );
  });
});
