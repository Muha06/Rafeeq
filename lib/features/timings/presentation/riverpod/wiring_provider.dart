import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/constants/hive_boxes.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/wiring_providers.dart';
import 'package:rafeeq/features/timings/data/datasources/salah_remote_ds.dart';
import 'package:rafeeq/features/timings/data/repository/salah_repo_impl.dart';
import 'package:rafeeq/features/timings/domain/repository/get_today_salah_times_repo.dart';
import 'package:rafeeq/features/timings/domain/usecases/fetch_today_salah_times.dart';
import 'package:rafeeq/features/timings/domain/usecases/salat_notifications_repo.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/timings/data/datasources/cached_salah_local_ds.dart';
import 'package:rafeeq/features/timings/data/models/hive/cached_salah_times_hive.dart';

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

// CACHE
final salahCacheBoxProvider = Provider<Box<CachedSalahTimesHive>>((ref) {
  return Hive.box<CachedSalahTimesHive>(HiveBoxes.salahTimesCacheBox);
});

final salahCacheLocalProvider = Provider<SalahCacheLocalDataSource>((ref) {
  final box = ref.read(salahCacheBoxProvider);
  return SalahCacheLocalDataSourceImpl(box);
});
