import 'package:rafeeq/features/adhkar_02/data/datasources/adhkar_local_ds.dart';
import 'package:rafeeq/features/adhkar_02/data/datasources/dhikr_remote_datasource.dart';
import 'package:rafeeq/features/adhkar_02/data/models/hive/category_hive_wrapper.dart';
import 'package:rafeeq/features/adhkar_02/data/models/hive/dhikr_category_hive.dart';
import 'package:rafeeq/features/adhkar_02/data/models/hive/adhkar_hive_wrapper.dart';
import 'package:rafeeq/features/adhkar_02/data/models/hive/dhikr_hive_model.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_category.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_entity.dart';
import 'package:rafeeq/features/adhkar_02/domain/repositories/adkar_repo.dart';

class DhikrRepoImpl implements AdkarRepo {
  final AdhkarRemoteDataSource remoteDataSource;
  final AdhkarLocalDs localDataSource;

  DhikrRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  static const Duration ttl = Duration(days: 7);

  @override
  Future<List<DhikrCategory>> fetchAllCategories() async {
    // Check cache first
    final cache = await localDataSource.getCategoryCache();

    //Validate cache
    if (cache != null && _isCacheValid(cache.cachedAt)) {
      final categoryEntities = cache.categories.map((categoriesModel) {
        return categoriesModel.toEntity();
      }).toList();

      return categoryEntities;
    }

    // Else fetch
    final dtos = await remoteDataSource.fetchAllCategories();
    final categories = dtos.map((dto) => dto.toEntity()).toList();

    // Cache

    final categoryWrapper = CategoryCacheHive(
      cachedAt: DateTime.now(),
      categories: categories.map((c) {
        return DhikrCategoryHive.fromEntity(c);
      }).toList(),
    );

    await localDataSource.cacheCategories(cacheWrapper: categoryWrapper);

    return categories;
  }

  @override
  Future<List<Dhikr>> fetchAllDhikrs(String categoryId) async {
    // 1. Check cache first
    final cache = await localDataSource.getDhikrCache(categoryId);

    if (cache != null && _isCacheValid(cache.cachedAt)) {
      return cache.dhikrs.map((e) => e.toEntity()).toList();
    }

    // 2. Else: Fetch from remote
    final dtos = await remoteDataSource.fetchAllDhikrs(categoryId);
    final dhikrs = dtos.map((dto) => dto.toEntity()).toList();

    // 3. Cache result
    await localDataSource.cacheAdhkar(
      categoryId: categoryId,
      adhkarsWrapperCache: AdhkarHiveWrapper(
        categoryId: categoryId,
        cachedAt: DateTime.now(),
        dhikrs: dhikrs.map((e) => DhikrHiveModel.fromEntity(e)).toList(),
      ),
    );

    // 4. Return fresh data
    return dhikrs;
  }

  // Helper
  bool _isCacheValid(DateTime cachedAt) {
    return DateTime.now().difference(cachedAt) < ttl;
  }
}
