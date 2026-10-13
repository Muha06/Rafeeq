import 'package:rafeeq/core/features/location/domain/user_location.dart';
import 'package:rafeeq/features/timings/data/datasources/cached_salah_local_ds.dart';
import 'package:rafeeq/features/timings/data/datasources/salah_remote_ds.dart';
import 'package:rafeeq/features/timings/data/models/mappers.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/domain/repository/get_today_salah_times_repo.dart';

class FetchSalahTimesRepoImpl implements FetchSalahTimesRepo {
  final SalahRemoteDataSource remote;
  final SalahCacheLocalDataSource local;

  const FetchSalahTimesRepoImpl({required this.remote, required this.local});

  @override
  Future<SalahTimesEntity> fetchByCoords({
    required UserLocation userLocation,
    int method = 3,
    required DateTime date,
  }) async {
    final day = DateTime(date.year, date.month, date.day);

    // 1. Check today's cache
    final cached = local.getToday(
      date: day,
      longitude: userLocation.lng,
      latitude: userLocation.lat,
      method: method,
    );

    if (cached != null) {
      return cached.toEntity();
    }

    // 2. Fetch the entire month

    final monthlyModels = await remote.fetchMonthByCoordinates(
      latitude: userLocation.lat,
      longitude: userLocation.lng,
    );

    // 3. Cache the entire month

    final cachedModels = monthlyModels
        .map(
          (model) => CachedSalahTimesHiveX.fromEntity(
            entity: model.toEntity(),
            latitude: userLocation.lat,
            longitude: userLocation.lng,
            method: method,
          ),
        )
        .toList();

    await local.saveAll(cachedModels);

    // 4. Find today's timing
    final todayModel = monthlyModels.firstWhere(
      (model) =>
          model.date.year == day.year &&
          model.date.month == day.month &&
          model.date.day == day.day,
      orElse: () => throw Exception('No timings found for today'),
    );

    return todayModel.toEntity();
  }
}
