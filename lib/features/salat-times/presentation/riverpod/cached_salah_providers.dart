import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/salat-times/data/datasources/cached_salah_local_ds.dart';
import 'package:rafeeq/features/salat-times/data/models/cached_salah_times_hive.dart'; 

const salahTimesCacheBoxName = 'salah_times_cache_box';

final salahCacheBoxProvider = Provider<Box<CachedSalahTimesHive>>((ref) {
  return Hive.box<CachedSalahTimesHive>(salahTimesCacheBoxName);
});

final salahCacheLocalProvider = Provider<SalahCacheLocalDataSource>((ref) {
  final box = ref.read(salahCacheBoxProvider);
  return SalahCacheLocalDataSourceImpl(box);
});
