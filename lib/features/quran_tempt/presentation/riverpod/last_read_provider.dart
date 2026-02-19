import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/quran_tempt/data/dataSources/last_read_local_ds.dart';
import 'package:rafeeq/features/quran_tempt/data/repositories/last_read_repo_impl.dart';
import 'package:rafeeq/features/quran_tempt/domain/entities/last_read_ayah.dart';
import 'package:rafeeq/features/quran_tempt/domain/repository/last_read_repo.dart';

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

// FUTURE PROVIDER to get all last read ayahs
final lastReadAyahsProvider = FutureProvider<List<LastReadAyah>>((ref) async {
  // Call the repo directly (perfectly fine for now)
  return ref.read(lastReadRepositoryProvider).getAllLastReads();
});
