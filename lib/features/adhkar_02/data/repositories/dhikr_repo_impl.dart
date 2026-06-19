import 'package:rafeeq/features/adhkar_02/data/datasources/dhikr_remote_datasource.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_category.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_entity.dart';
 import 'package:rafeeq/features/adhkar_02/domain/repositories/adkar_repo.dart';

class DhikrRepoImpl implements AdkarRepo {
  final AdhkarRemoteDataSource remoteDataSource;
  DhikrRepoImpl({required this.remoteDataSource});

  @override
  Future<List<DhikrCategory>> fetchAllCategories() async {
    final dtos = await remoteDataSource.fetchAllCategories();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

 

  @override
  Future<List<Dhikr>> fetchAllDhikrs(String categoryId) async {
    final dtos = await remoteDataSource.fetchAllDhikrs(categoryId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
