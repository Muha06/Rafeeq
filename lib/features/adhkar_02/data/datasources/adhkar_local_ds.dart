import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/adhkar_02/data/models/hive/category_hive_wrapper.dart';

class AdhkarLocalDs {
  final Box box;
  AdhkarLocalDs(this.box);

  static String categoryKey = 'category_cache';

  // WRITE
  Future<void> cacheCategories({
    required CategoryCacheHive cacheWrapper,
  }) async {
    await box.put(categoryKey, cacheWrapper);
    debugPrint("Cache wrote");
  }

  // READ
  Future<CategoryCacheHive?> getCategoryCache() async {
    final cache = box.get(categoryKey);

    if (cache is CategoryCacheHive) {
      debugPrint("Cache hit!");
      return cache;
    }

    return null;
  }
}
