//supabase client
import 'package:rafeeq/features/adhkar/data/datasources/adhkar_audio_remote_ds.dart';
import 'package:rafeeq/features/adhkar/data/datasources/adhkar_text_remote_ds.dart';
import 'package:rafeeq/features/adhkar/data/repository_impl/audio_repo_impl.dart';
import 'package:rafeeq/features/adhkar/data/repository_impl/text_repository_impl.dart';
import 'package:rafeeq/features/adhkar/domain/repository/audio_repo.dart';
import 'package:rafeeq/features/adhkar/domain/repository/repository.dart';
import 'package:rafeeq/features/adhkar/domain/usecases/get_adhkar_audio_urls.dart';
import 'package:rafeeq/features/adhkar/domain/usecases/get_adhkars_usecase.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

//Audio Remote
final dhikrAudioRemoteDsProvider = Provider<DhikrAudioRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DhikrAudioRemoteDsImpl(client);
});

//Text Remote
final dhikrTextRemoteDsProvider = Provider<DhikrTextRemoteDataSource>((ref) {
  final httpClient = ref.watch(httpClientProvider);

  return DhikrTextRemoteDataSourceImpl(
    client: httpClient,
    baseUrl: 'https://www.hisnmuslim.com/api/en/',
  );
});

//Audio repo
final dhikrAudioRepositoryProvider = Provider<DhikrAudioRepository>((ref) {
  final remote = ref.watch(dhikrAudioRemoteDsProvider);

  return DhikrAudioRepositoryImpl(remote: remote);
});

//Text repo
final dhikrTextRepositoryProvider = Provider<DhikrTextRepository>((ref) {
  final remote = ref.watch(dhikrTextRemoteDsProvider);

  return DhikrTextRepositoryImpl(remoteDs: remote);
});

//Dhikr usecase
final dhikrTextUseCaseProvider = Provider<GetAdhkarsUsecase>((ref) {
  final repo = ref.watch(dhikrTextRepositoryProvider);

  return GetAdhkarsUsecase(repo: repo);
});

//audio usecase
final adhkarAudioUrlsUseCaseProvider = Provider<GetAdhkarAudioUrls>((ref) {
  final repo = ref.watch(dhikrAudioRepositoryProvider);

  return GetAdhkarAudioUrls(repo: repo);
});
