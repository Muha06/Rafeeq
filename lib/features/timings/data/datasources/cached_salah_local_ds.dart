import 'package:hive/hive.dart';
import '../models/hive/cached_salah_times_hive.dart';

abstract class SalahCacheLocalDataSource {
  CachedSalahTimesHive? getToday({
    required DateTime date,
    required String city,
    required String country,
    required int method,
  });

  Future<void> save(CachedSalahTimesHive data);
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
    );
    return box.get(k);
  }

  @override
  Future<void> save(CachedSalahTimesHive data) async {
    final k = CachedSalahTimesHive.cachedKey(
      date: data.date,
      city: data.city,
      country: data.country,
      method: data.method,
    );
    await box.put(k, data);
  }
}
