import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/Quran/data/dataSources/last_read_local_ds.dart';
import 'package:rafeeq/features/Quran/data/repositories/last_read_repo_impl.dart';
import 'package:rafeeq/features/Quran/domain/repository/last_read_repo.dart';

//LAST READ HIVE BOX provider
final lastReadBoxProvider = Provider<Box>((ref) {
  return Hive.box('lastReadBox');
});

//LOCAL DATA SOURCE provider
final lastReadLocalDataSourceProvider = Provider<LastReadLocalDataSource>((
  ref,
) {
  return LastReadLocalDataSourceImpl(ref.read(lastReadBoxProvider));
});

//REPO provider
final lastReadRepositoryProvider = Provider<LastReadRepository>((ref) {
  return LastReadRepositoryImpl(ref.read(lastReadLocalDataSourceProvider));
});
