import 'package:rafeeq/features/asma_ul_husna/data/datasources/asma_ul_husna_ds.dart';
import 'package:rafeeq/features/asma_ul_husna/data/datasources/local_ds.dart';
import 'package:rafeeq/features/asma_ul_husna/data/models/mappers.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/repository/repository.dart';

class AllahNamesRepositoryImpl implements AllahNamesRepository {
  final AllahNamesRemoteDataSource remote;
  final AllahNamesLocalDataSource local;

  AllahNamesRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<AllahName>> getAllahNames() async {
    // 1) local first
    final cached = local.getAll(); // List<AllahNameHive>
    if (cached.isNotEmpty) {
      return cached.map((h) => h.toEntity()).toList();
    }

    // 2) remote
    final dtos = await remote.fetchAllahNames(); // List<AllahNameDto>

    // 3) save
    await local.saveAll(dtos.map((d) => d.toHive()).toList());

    // 4) return local (sorted/consistent), fallback to dtos
    final saved = local.getAll();
    if (saved.isNotEmpty) {
      return saved.map((h) => h.toEntity()).toList();
    }

    return dtos.map((d) => d.toEntity()).toList();
  }
}
