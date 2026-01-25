import 'package:flutter/material.dart';
import 'package:rafeeq/features/salat-times/data/datasources/cached_salah_local_ds.dart';
import 'package:rafeeq/features/salat-times/data/datasources/salah_remote_ds.dart';
import 'package:rafeeq/features/salat-times/data/models/mappers.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_times.dart';
import 'package:rafeeq/features/salat-times/domain/repository/get_today_salah_times_repo.dart';

class SalahTimesRepositoryImpl implements SalahTimesRepository {
  final SalahRemoteDataSource remote;
  final SalahCacheLocalDataSource local;

  const SalahTimesRepositoryImpl({required this.remote, required this.local});

  @override
  Future<SalahTimesEntity> getTodayByCoords({
    required double latitude,
    required double longitude,
    required String city,
    required String country,
    int method = 3,
  }) async {
    final now = DateTime.now();
    final normalized = DateTime(now.year, now.month, now.day);

    // 1) Cache first (still keying by city/country/method/date)
    final localCache = local.getToday(
      date: normalized,
      city: city,
      country: country,
      method: method,
    );

    if (localCache != null) {
      return localCache.toEntity();
    }

    // 2) Remote fetch by coords
    final model = await remote.fetchTodayByCoords(
      latitude: latitude,
      longitude: longitude,
      method: method,
    );
    debugPrint('$latitude $longitude');

    final entity = model.toEntity();

    // 3) Save to cache
    await local.save(
      CachedSalahTimesHiveX.fromEntity(
        entity: entity,
        city: city,
        country: country,
        method: method,
      ),
    );

    return entity;
  }

  @override
  Future<SalahTimesEntity> getTodayByCity({
    required String city,
    required String country,
    int method = 3,
  }) async {
    final now = DateTime.now();
    final normalized = DateTime(now.year, now.month, now.day);

    // 1) Cache first
    final localCache = local.getToday(
      date: normalized,
      city: city,
      country: country,
      method: method,
    );

    if (localCache != null) {
      return localCache.toEntity();
    }

    // 2) Remote fetch
    final model = await remote.fetchTodayByCity(
      city: city,
      country: country,
      method: method,
    );

    final entity = model.toEntity();

    // 3) Save to cache
    await local.save(
      CachedSalahTimesHiveX.fromEntity(
        entity: entity,
        city: city,
        country: country,
        method: method,
      ),
    );

    return entity;
  }
}
