import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/adhkar_02/data/models/hive/dhikr_category_hive.dart';

part 'generated/category_hive_wrapper.g.dart';

@HiveType(typeId: 35)
class CategoryCacheHive extends HiveObject {
  @HiveField(0)
  final DateTime cachedAt;

  @HiveField(1)
  final List<DhikrCategoryHive> categories;

  CategoryCacheHive({required this.cachedAt, required this.categories});
}
