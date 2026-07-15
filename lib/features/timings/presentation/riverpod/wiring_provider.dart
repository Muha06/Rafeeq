import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/wiring_providers.dart';
import 'package:rafeeq/features/timings/data/datasources/salah_remote_ds.dart';
import 'package:rafeeq/features/timings/data/repository/salah_repo_impl.dart';
import 'package:rafeeq/features/timings/domain/repository/get_today_salah_times_repo.dart';
import 'package:rafeeq/features/timings/domain/usecases/get_today_salah_times.dart';
import 'package:rafeeq/features/timings/domain/usecases/salat_notifications_repo.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/cached_salah_providers.dart';

///  Remote DS
final salahRemoteDataSourceProvider = Provider<SalahRemoteDataSource>((ref) {
  return SalahRemoteDataSourceImpl(ref.read(httpClientProvider));
});

///  Repository
final salahTimesRepositoryProvider = Provider<FetchSalahTimesRepo>((ref) {
  return FetchSalahTimesRepoImpl(
    remote: ref.read(salahRemoteDataSourceProvider),
    local: ref.read(salahCacheLocalProvider),
  );
});

/// Usecase
final fetchSalahTimesUsecase = Provider<FetchTodaySalahTimes>((ref) {
  return FetchTodaySalahTimes(ref.read(salahTimesRepositoryProvider));
});

final salahMethodProvider = Provider<int>((ref) => 3);

final salahNotifSchedulerServiceProvider = Provider((ref) {
  final localNotifService = ref.watch(localNotificationServiceProvider);

  return SalahNotifSchedulerService(
    localNotificationService: localNotifService,
  );
});
