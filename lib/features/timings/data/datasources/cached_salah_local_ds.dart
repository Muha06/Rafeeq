import 'package:hive/hive.dart';
import '../models/hive/cached_salah_times_hive.dart';

abstract class SalahCacheLocalDataSource {
  CachedSalahTimesHive? getToday({
    required DateTime date,
    required String city,
    required String country,
    required int method,
  });

  Future<void> saveAll(List<CachedSalahTimesHive> data);
}

class SalahCacheLocalDataSourceImpl implements SalahCacheLocalDataSource {
  final Box<CachedSalahTimesHive> box;

  SalahCacheLocalDataSourceImpl(this.box);

  @override
  CachedSalahTimesHive? getToday({
    required DateTime date,
    required String city,
    required String country,
    required int method,
  }) {
    final k = CachedSalahTimesHive.cachedKey(
      date: date,
      city: city,
      country: country,
      method: method,
    ); // key for the cache

    return box.get(k);
  }

  @override
  Future<void> saveAll(List<CachedSalahTimesHive> data) async {
    for (final item in data) {
      final k = CachedSalahTimesHive.cachedKey(
        date: item.date,
        city: item.city,
        country: item.country,
        method: item.method,
      );
      await box.put(k, item);
    }
  }
}
