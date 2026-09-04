import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/hive/cached_salah_times_hive.dart';

abstract class SalahCacheLocalDataSource {
  CachedSalahTimesHive? getToday({
    required DateTime date,
    required double longitude,
    required double latitude,
    required int method,
  });

  Future<void> saveAll(List<CachedSalahTimesHive> data);

  Future<int> totalSalahsLength();
}

class SalahCacheLocalDataSourceImpl implements SalahCacheLocalDataSource {
  final Box<CachedSalahTimesHive> box;

  SalahCacheLocalDataSourceImpl(this.box);

  @override
  CachedSalahTimesHive? getToday({
    required DateTime date,
    required double longitude,
    required double latitude,
    required int method,
  }) {
    final k = CachedSalahTimesHive.cachedKey(
      date: date,
      longitude: longitude,
      latitude: latitude,
      method: method,
    ); // key for the cache

    debugPrint("Local fetching SalahTimes for key: $k");

    return box.get(k);
  }

  @override
  Future<void> saveAll(List<CachedSalahTimesHive> data) async {
    for (final item in data) {
      final k = CachedSalahTimesHive.cachedKey(
        date: item.date,
        longitude: item.longitude,
        latitude: item.latitude,
        method: item.method,
      );
      await box.put(k, item);
    }
  }

  @override
  Future<int> totalSalahsLength() async {
    final salahs = box.values.toList();
    return salahs.length;
  }
}
