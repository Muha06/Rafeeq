import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/asma_ul_husna/data/datasources/asma_ul_husna_ds.dart';
import 'package:rafeeq/features/asma_ul_husna/data/datasources/local_ds.dart';
import 'package:rafeeq/features/asma_ul_husna/data/models/hive/name_hive_model.dart';
import 'package:rafeeq/features/asma_ul_husna/data/repository/repository_impl.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/repository/repository.dart';
import 'package:dio/dio.dart';
import 'package:rafeeq/features/settings/presentation/provider/notifcation_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {'Accept': 'application/json'},
    ),
  );
});
final allahNamesBoxProvider = Provider<Box<AllahNameHive>>((ref) {
  return Hive.box<AllahNameHive>('allah_names_box');
});

final allahNamesremoteDsProvider = Provider<AllahNamesRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AllahNamesRemoteDataSourceImpl(dio);
});

final allahNamesLocaDSProvider = Provider<AllahNamesLocalDataSource>((ref) {
  final box = ref.watch(allahNamesBoxProvider);
  return AllahNamesLocalDataSourceImpl(
    namesBox: box, 
  );
});

final allahNamesRepositoryProvider = Provider<AllahNamesRepository>((ref) {
  final remote = ref.watch(allahNamesremoteDsProvider);
  final local = ref.watch(allahNamesLocaDSProvider);
  return AllahNamesRepositoryImpl(remote: remote, local: local);
});

final allahNamesProvider = FutureProvider.autoDispose<List<AllahName>>((
  ref,
) async {
  final repo = ref.watch(allahNamesRepositoryProvider);
  return repo.getAllahNames();
});
