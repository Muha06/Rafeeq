import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/wiring_providers.dart';
import 'package:rafeeq/features/radio_station/data/radio_remote_ds.dart';
 import 'package:rafeeq/features/radio_station/data/repository/radio_repo_impl.dart';
import '../../domain/repository/radio_repository.dart';

final radioRemoteDataSourceProvider = Provider<RadioRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return RadioRemoteDataSource(client);
});
final radioRepositoryProvider = Provider<RadioRepository>((ref) {
  final remote = ref.watch(radioRemoteDataSourceProvider);
  return RadioRepositoryImpl(remote);
});
