import 'package:flutter/rendering.dart';
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
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';

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

  // watch location state (reactive)
  final locAsync = ref.watch(userLocationProvider);

  // if it's loading/error, just await the future once
  final loc = await locAsync.when(
    data: (v) async => v,
    loading: () => ref.watch(userLocationProvider.future),
    error: (e, st) => Future.error(e, st),
  );

  if (loc == null) {
    throw Exception('Location not set. Turn on location and try again.');
  }

  return usecase.call(
    latitude: loc.lat,
    longitude: loc.lng,
    city: loc.city,
    country: loc.country,
    method: ref.read(salahMethodProvider),
  );
});

//SINGLE SCHEDULER CONTROLLER PROVIDER
final salahNotificationsControllerProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<SalahTimesEntity>>(todaySalahTimesProvider, (
    prev,
    next,
  ) async {
    final enabled = ref.read(salahNotifEnabledProvider);

    if (!enabled) {
      debugPrint('☀️salah reminders settings: $enabled');
      await SalahNotifications.instance.cancelAll();
      return;
    }

    next.whenData((times) async {
      // re-check enabled again before scheduling (async safety)
      if (!ref.read(salahNotifEnabledProvider)) return;
      debugPrint('salah reminders: allowed scheduling');
      await SalahNotifications.instance.scheduleForToday(times: times);
    });
  });

  //check if user allowed salah reminders settings
  ref.listen<bool>(salahNotifEnabledProvider, (prev, next) async {
    if (!next) {
      debugPrint('☀️salah reminders: canceled, cancelling');
      await SalahNotifications.instance.cancelAll();
      return;
    }

    final times = await ref.read(todaySalahTimesProvider.future);
    if (!ref.read(salahNotifEnabledProvider)) return; //off? dont set

    debugPrint('☀️salah reminders allowed: $next');
    await SalahNotifications.instance.scheduleForToday(times: times);
  });
});
