import 'package:rafeeq/features/asma_ul_husna/data/datasources/asma_ul_husna_ds.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/repository/repository.dart';

class AllahNamesRepositoryImpl implements AllahNamesRepository {
  final AllahNamesLocalDataSource local;

  AllahNamesRepositoryImpl({required this.local});

  @override
  Future<List<AllahName>> getAllahNames() async {
    final models = await local.getAllahNames();

    return models.map((d) => d.toEntity()).toList();
  }
}
