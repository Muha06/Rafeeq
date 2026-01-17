import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/adhkar/data/datasources/adhkar_local_ds.dart';
import 'package:rafeeq/features/adhkar/data/repository_impl/repository_impl.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';
import 'package:rafeeq/features/adhkar/domain/usecases/get_adhkars_usecase.dart';

//local
final localDsProvider = Provider<AdhkarLocalDataSource>((ref) {
  return AdhkarLocalDsImpl();
});

//repo
final adhkarRepositoryProvider = Provider<AdhkarRepository>((ref) {
  final local = ref.watch(localDsProvider);

  return AdhkarRepositoryImpl(localDs: local);
});

//usecase
final adhkarUseCaseProvider = Provider<GetAdhkarsUsecase>((ref) {
  final repo = ref.watch(adhkarRepositoryProvider);

  return GetAdhkarsUsecase(repo: repo);
});

//get adhkars
final getAdhkarsProvider = FutureProvider.family<List<Dhikr>, String>((
  ref,
  assetPath,
) {
  final usecase = ref.watch(adhkarUseCaseProvider);

  return usecase.call(assetPath);
});
