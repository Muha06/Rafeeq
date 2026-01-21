 
import 'package:rafeeq/features/asma_ul_husna/data/datasources/asma_ul_husna_ds.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/repository/repository.dart';

class AllahNamesRepositoryImpl implements AllahNamesRepository {
  final AllahNamesRemoteDataSource remote;

  AllahNamesRepositoryImpl(this.remote);

  @override
  Future<List<AllahName>> getAllahNames() async {
    final dtos = await remote.fetchAllahNames();
    return dtos.map((e) => e.toEntity()).toList();
  }
}
