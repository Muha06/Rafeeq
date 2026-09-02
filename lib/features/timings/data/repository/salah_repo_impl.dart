import 'package:flutter/cupertino.dart';
import 'package:rafeeq/features/timings/data/datasources/cached_salah_local_ds.dart';
import 'package:rafeeq/features/timings/data/datasources/salah_remote_ds.dart';
import 'package:rafeeq/features/timings/data/models/mappers.dart';
import 'package:rafeeq/features/timings/data/models/salah_times_model.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_times.dart';
import 'package:rafeeq/features/timings/domain/repository/get_today_salah_times_repo.dart';

class FetchSalahTimesRepoImpl implements FetchSalahTimesRepo {
  final SalahRemoteDataSource remote;
  final SalahCacheLocalDataSource local;

  const FetchSalahTimesRepoImpl({required this.remote, required this.local});

  @override
  Future<SalahTimesEntity> fetchTodayByCoords({
    required double latitude,
    required double longitude,
    required String city,
    required String country,
    int method = 3,
  }) {
    return _fetchMonthlyTimings(
      city: city,
      country: country,
      method: method,
      fetchMonth: () => remote.fetchMonthByCoordinates(
        latitude: latitude,
        longitude: longitude,
        method: method,
      ),
    );
  }

  @override
  Future<SalahTimesEntity> fetchTodayByCity({
    required String city,
    required String country,
    int method = 3,
  }) {
    return _fetchMonthlyTimings(
      city: city,
      country: country,
      method: method,
      fetchMonth: () =>
          remote.fetchMonthByCity(city: city, country: country, method: method),
    );
  }

  Future<SalahTimesEntity> _fetchMonthlyTimings({
    required String city,
    required String country,
    required int method,
    required Future<List<AladhanTimingsModel>> Function() fetchMonth,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 1. Check today's cache
    final cached = local.getToday(
      date: today,
      city: city,
      country: country,
      method: method,
    );

    if (cached != null) {
      debugPrint('Returning cached timings for today: ${cached.date}');
      return cached.toEntity();
    }

    // 2. Fetch the entire month
    debugPrint('No cached timings found. Fetching month from remote...');

    final monthlyModels = await fetchMonth();

    debugPrint('Fetched ${monthlyModels.length} timings for the month.');

    // 3. Cache the entire month
    debugPrint('Caching the entire month of timings...');

    for (final model in monthlyModels) {
      await local.save(
        CachedSalahTimesHiveX.fromEntity(
          entity: model.toEntity(),
          city: city,
          country: country,
          method: method,
        ),
      );
    }

    // 4. Find today's timing
    final todayModel = monthlyModels.firstWhere(
      (model) =>
          model.date.year == today.year &&
          model.date.month == today.month &&
          model.date.day == today.day,
      orElse: () => throw Exception('No timings found for today'),
    );

    return todayModel.toEntity();
  }
}
