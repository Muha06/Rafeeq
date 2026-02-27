import 'package:rafeeq/features/adhkar/data/datasources/adhkar_text_remote_ds.dart';
import 'package:rafeeq/features/adhkar/data/models/dhikr_model.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';
import 'package:flutter/foundation.dart';

class DhikrTextRepositoryImpl implements DhikrTextRepository {
  final DhikrTextRemoteDataSource remoteDs;

  DhikrTextRepositoryImpl({required this.remoteDs});

  @override
  Future<List<DhikrEntity>> getDhikrByCategoryId(int categoryId) async {
    try {
      final List<DhikrModel> dhikrModels = await remoteDs
          .fetchDhikrByCategoryId(categoryId);

      // Convert models to entities and attach categoryId
      final dhikrEntities = dhikrModels
          .map((model) => model.toEntity(categoryId: categoryId))
          .toList();

      return dhikrEntities;
    } catch (e) {
      debugPrint('Error fetching dhikr for category $categoryId: $e');
      rethrow;
    }
  }
}
