import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/salat_notifications_repo.dart';
import 'package:rafeeq/core/features/location/domain/user_location.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/wiring_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/notiffications_controller.dart';
import 'package:rafeeq/features/timings/data/datasources/salah_remote_ds.dart';
import 'package:rafeeq/features/timings/data/repository/salah_repo_impl.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/domain/repository/get_today_salah_times_repo.dart';
import 'package:rafeeq/features/timings/domain/usecases/get_today_salah_times.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/cached_salah_providers.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/disable_salah_reminders_provider.dart';

///  Remote DS
final salahRemoteDataSourceProvider = Provider<SalahRemoteDataSource>((ref) {
  return SalahRemoteDataSourceImpl(ref.read(httpClientProvider));
});

///  Repository
final salahTimesRepositoryProvider = Provider<SalahTimesRepository>((ref) {
  return SalahTimesRepositoryImpl(
    remote: ref.read(salahRemoteDataSourceProvider),
    local: ref.read(salahCacheLocalProvider),
  );
});

/// Usecase
final fetchSalahTimesUsecase = Provider<GetTodaySalahTimes>((ref) {
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
  final fetchTimesUsecase = ref.watch(fetchSalahTimesUsecase);

  // Fetch user location
  var userLocationCoords = await ref.watch(userLocationProvider.future);

  return fetchTimesUsecase(
    latitude: userLocationCoords!.lat,
    longitude: userLocationCoords.lng,
    city: userLocationCoords.city,
    country: userLocationCoords.country,
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
    //check if user allowed salah Notifications
    final enabled = ref.read(salahNotifControllerProvider);

    //Did'nt enable? cancel all notifications
    if (!enabled) {
      SalahNotifications.instance.cancelAll();
      return;
    }

    //User allowed salah notifications
    next.whenData((times) async {
      final enabled = ref.read(salahNotifControllerProvider);

      if (!enabled) return;

      //User allowed notification reminders -> Schedule for today
      final disabled = ref.read(disabledSalahPrayersProvider);

      await SalahNotifications.instance.scheduleForToday(
        times: times,
        disabled: disabled,
      );
    });
  });

  //this provider tells us whether user allowed Salah reminders
  ref.listen<bool>(salahNotifControllerProvider, (prev, after) async {
    //User disabled salah reminders
    if (!after) {
      await SalahNotifications.instance.cancelAll();
      return;
    }

    //Otherwise if user allowed salah reminders
    //We fetch then schedule
    final times = await ref.read(
      todaySalahTimesProvider.future,
    ); //TODO: check this
    final salahRemindersAllowed = ref.read(salahNotifControllerProvider);

    if (!salahRemindersAllowed) return;

    final disabled = ref.read(disabledSalahPrayersProvider);

    await SalahNotifications.instance.scheduleForToday(
      times: times,
      disabled: disabled,
    );
  });

  //Disabled salah reminders
  ref.listen<Set<SalahPrayer>>(disabledSalahPrayersProvider, (
    oldSalahList,
    newDisabledSalahList,
  ) async {
    final salahRemindersAllowed = ref.read(salahNotifControllerProvider);

    if (!salahRemindersAllowed) return;

    final times = await ref.read(todaySalahTimesProvider.future);
    if (!ref.read(salahNotifControllerProvider)) return;

    await SalahNotifications.instance.scheduleForToday(
      times: times,
      disabled: newDisabledSalahList,
    );
  });
});
