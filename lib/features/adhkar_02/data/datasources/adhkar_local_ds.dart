import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/adhkar_02/data/models/hive/adhkar_hive_wrapper.dart';
import 'package:rafeeq/features/adhkar_02/data/models/hive/category_hive_wrapper.dart';

class AdhkarLocalDs {
  final Box box;
  AdhkarLocalDs(this.box);

  static String categoryKey = 'category_cache';

  // WRITE Category
  Future<void> cacheCategories({
    required CategoryCacheHive cacheWrapper,
  }) async {
    await box.put(categoryKey, cacheWrapper);
    debugPrint("Cache wrote");
  }

  // READ Category
  Future<CategoryCacheHive?> getCategoryCache() async {
    final cache = box.get(categoryKey);

    if (cache is CategoryCacheHive) {
      debugPrint("Cache hit!");
      return cache;
    }

    return null;
  }

  // WRITE ADHKARS
  Future<void> cacheAdhkar({
    required String categoryId,
    required AdhkarHiveWrapper adhkarsWrapperCache,
  }) async {
    await box.put('dhikr_cache_$categoryId', adhkarsWrapperCache);
    debugPrint("Cache wrote");
  }

  // GET ADHKARS
  Future<AdhkarHiveWrapper?> getDhikrCache(String categoryId) async {
    final cache = box.get('dhikr_cache_$categoryId');

    if (cache is AdhkarHiveWrapper) {
      debugPrint("Cache hit!");
      return cache;
    }

    return null;
  }
}
