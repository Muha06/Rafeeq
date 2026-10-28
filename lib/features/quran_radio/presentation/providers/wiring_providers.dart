import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:rafeeq/app/providers/wiring_providers.dart';
import 'package:rafeeq/core/constants/hive_boxes.dart';
import 'package:rafeeq/features/quran_radio/data/datasources/radio_favorites_local_ds.dart';
import 'package:rafeeq/features/quran_radio/data/datasources/radio_remote_ds.dart';
import 'package:rafeeq/features/quran_radio/data/repository/radio_favs_repo_impl.dart';
import 'package:rafeeq/features/quran_radio/data/repository/radio_repo_impl.dart';
import 'package:rafeeq/features/quran_radio/domain/repository/radio_favorites_repo.dart';

import '../../domain/repository/radio_repository.dart';

final radioRemoteDataSourceProvider = Provider<RadioRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RadioRemoteDataSource(client);
});

final radioRepositoryProvider = Provider<RadioRepository>((ref) {
  final remote = ref.watch(radioRemoteDataSourceProvider);
  return RadioRepositoryImpl(remote);
});

final radioFavoritesBoxProvider = Provider<Box<int>>((ref) {
  return Hive.box(HiveBoxes.radioFavoritesBox);
});

final radioFavoritesLocalDsProvider = Provider<RadioFavoritesLocalDataSource>(
  (ref) =>
      RadioFavoritesLocalDataSourceImpl(ref.watch(radioFavoritesBoxProvider)),
);

final radioFavoritesRepositoryProvider = Provider<RadioFavoritesRepository>(
  (ref) =>
      RadioFavoritesRepositoryImpl(ref.watch(radioFavoritesLocalDsProvider)),
);
