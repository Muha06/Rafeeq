import 'package:rafeeq/features/adhkar/data/datasources/adhkar_text_remote_ds.dart';
import 'package:rafeeq/features/adhkar/data/datasources/adkhar_local_ds.dart';
import 'package:rafeeq/features/adhkar/data/models/dhikr_hive_model.dart';
import 'package:rafeeq/features/adhkar/data/models/dhikr_model.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';
import 'package:flutter/foundation.dart';

class DhikrTextRepositoryImpl implements DhikrTextRepository {
  final DhikrTextRemoteDataSource remoteDs;
  final DhikrLocalDataSource localDs;

  DhikrTextRepositoryImpl({required this.remoteDs, required this.localDs});

  @override
  Future<List<DhikrEntity>> getDhikrByCategoryId(int categoryId) async {
    try {
      // 1️⃣ Try fetching from cache first
      final cached = localDs.getAdhkar(categoryId);

      if (cached != null && cached.isNotEmpty) {
        debugPrint("Got from hive: ${cached.length}");
        return cached.map((hiveModel) => hiveModel.toEntity()).toList();
      }

      debugPrint("hive empty fetching remote");

      // 2️⃣ Fetch from remote
      final List<DhikrModel> dhikrModels = await remoteDs.fetchSubcategoryById(
        categoryId,
      );

      // Convert to entities and attach categoryId
      final dhikrEntities = dhikrModels
          .map((model) => model.toEntity(categoryId: categoryId))
          .toList();

      // 3️⃣ Save to Hive for caching
      final hiveModels = dhikrEntities
          .map((entity) => DhikrHiveModel.fromEntity(entity))
          .toList();

      await localDs.saveAdhkar(categoryId, hiveModels);

      return dhikrEntities;
    } catch (e) {
      debugPrint('Error fetching dhikr for category $categoryId: $e');
      rethrow;
    }
  }

  //each id (subcategory) returns list<DhikrEntity>
  @override
  Future<List<DhikrEntity>> getDhikrByCategoryIds(List<int> ids) async {
    final List<DhikrEntity> adhkars = [];

    try {
      for (final id in ids) {
        final res = await getDhikrByCategoryId(id); // List<DhikrEntity>

        // Add each dhikr individually, but prevent duplicates by ID
        for (final dhikr in res) {
          if (!adhkars.any((d) => d.id == dhikr.id)) {
            adhkars.add(dhikr);
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching grouped categories: $e');
      rethrow;
    }

    return adhkars;
  }
}
