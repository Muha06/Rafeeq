import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/adhkar/data/datasources/adhkar_local_ds.dart';
import 'package:rafeeq/features/adhkar/data/datasources/adhkar_remote_ds.dart';
import 'package:rafeeq/features/adhkar/data/repository_impl/repository_impl.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_audio_urls.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';
import 'package:rafeeq/features/adhkar/domain/usecases/get_adhkar_audio_urls.dart';
import 'package:rafeeq/features/adhkar/domain/usecases/get_adhkars_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//local
final localDsProvider = Provider<AdhkarLocalDataSource>((ref) {
  return AdhkarLocalDsImpl();
});

//remote
final adhkarRemoteDsProvider = Provider<AdhkarRemoteDsImpl>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AdhkarRemoteDsImpl(client);
});

//supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

//repo
final adhkarRepositoryProvider = Provider<AdhkarRepository>((ref) {
  final local = ref.watch(localDsProvider);
  final remote = ref.watch(adhkarRemoteDsProvider);

  return AdhkarRepositoryImpl(localDs: local, remote: remote);
});

//usecase
final adhkarUseCaseProvider = Provider<GetAdhkarsUsecase>((ref) {
  final repo = ref.watch(adhkarRepositoryProvider);

  return GetAdhkarsUsecase(repo: repo);
});

//audio urls usecase
final adhkarAudioUrlsUseCaseProvider = Provider<GetAdhkarAudioUrls>((ref) {
  final repo = ref.watch(adhkarRepositoryProvider);

  return GetAdhkarAudioUrls(repo: repo);
});

final adhkarAudioUrlsProvider = FutureProvider<AdhkarAudioUrls>((ref) async {
  final usecase = ref.read(adhkarAudioUrlsUseCaseProvider);
  return usecase();  
});

//get adhkars
final getAdhkarsProvider = FutureProvider.family<List<Dhikr>, String>((
  ref,
  assetPath,
) {
  final usecase = ref.watch(adhkarUseCaseProvider);

  return usecase.call(assetPath);
});
