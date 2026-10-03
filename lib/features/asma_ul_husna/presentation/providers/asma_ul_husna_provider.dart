import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/asma_ul_husna/data/datasources/asma_ul_husna_ds.dart';
import 'package:rafeeq/features/asma_ul_husna/data/repository/repository_impl.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/repository/repository.dart';

final allahNamesLocaDSProvider = Provider<AllahNamesLocalDataSource>((ref) {
  return const AllahNamesLocalDataSourceImpl();
});

final allahNamesRepositoryProvider = Provider<AllahNamesRepository>((ref) {
  final local = ref.watch(allahNamesLocaDSProvider);
  return AllahNamesRepositoryImpl(local: local);
});

final allahNamesProvider = FutureProvider.autoDispose<List<AllahName>>((
  ref,
) async {
  final repo = ref.read(allahNamesRepositoryProvider);

  return await repo.getAllahNames();
});
