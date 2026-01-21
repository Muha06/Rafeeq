import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/asma_ul_husna/data/datasources/asma_ul_husna_ds.dart';
import 'package:rafeeq/features/asma_ul_husna/data/repository/repository_impl.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/repository/repository.dart';
import 'package:dio/dio.dart';
 
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
    ),
  );
});

final allahNamesremoteDsProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);
  return AllahNamesRemoteDataSourceImpl(dio);
});

final allahNamesRepositoryProvider = Provider<AllahNamesRepository>((ref) {
  final remote = ref.watch(allahNamesremoteDsProvider);
  return AllahNamesRepositoryImpl(remote);
});

final allahNamesProvider = FutureProvider<List<AllahName>>((ref) async {
  final repo = ref.watch(allahNamesRepositoryProvider);
  return repo.getAllahNames();
});
