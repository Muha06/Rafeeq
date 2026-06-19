import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/wiring_providers.dart';
import 'package:rafeeq/features/adhkar_02/data/datasources/adhkar_audio_remote_ds.dart';
import 'package:rafeeq/features/adhkar_02/data/datasources/dhikr_remote_datasource.dart';
import 'package:rafeeq/features/adhkar_02/data/repositories/audio_repo_impl.dart';
import 'package:rafeeq/features/adhkar_02/data/repositories/dhikr_repo_impl.dart';
import 'package:rafeeq/features/adhkar_02/domain/repositories/adkar_repo.dart';
import 'package:rafeeq/features/adhkar_02/domain/repositories/audio_repo.dart';
import 'package:rafeeq/features/adhkar_02/domain/usecases/fetch_all_adhkar.dart';
import 'package:rafeeq/features/adhkar_02/domain/usecases/get_adhkar_audio_urls.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/adhkar_audio_urls.dart';
import 'package:rafeeq/features/adhkar_02/domain/usecases/fetch_all_categories.dart';
 
final adhkarRemoteDataSourceProvider = Provider<AdhkarRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AdhkarRemoteDatasourceImpl(client: client);
});

final adhkarRepoProvider = Provider<AdkarRepo>((ref) {
  final remoteDataSource = ref.watch(adhkarRemoteDataSourceProvider);
  return DhikrRepoImpl(remoteDataSource: remoteDataSource);
});

final fetchAllAdhkarUsecaseProvider = Provider<FetchAllAdhkarUsecase>((ref) {
  final repo = ref.watch(adhkarRepoProvider);
  return FetchAllAdhkarUsecase(repo: repo);
});

final fetchAllCategoriesUsecaseProvider = Provider<FetchAllCategories>((ref) {
  final repo = ref.watch(adhkarRepoProvider);
  return FetchAllCategories(repository: repo);
});

 

//Audio Remote
final dhikrAudioRemoteDsProvider = Provider<DhikrAudioRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return DhikrAudioRemoteDsImpl(client);
});

final dhikrAudioRepositoryProvider = Provider<DhikrAudioRepository>((ref) {
  final remote = ref.watch(dhikrAudioRemoteDsProvider);

  return DhikrAudioRepositoryImpl(remote: remote);
});

//audio usecase
final adhkarAudioUrlsUseCaseProvider = Provider<GetAdhkarAudioUrls>((ref) {
  final repo = ref.watch(dhikrAudioRepositoryProvider);

  return GetAdhkarAudioUrls(repo: repo);
});

//get Adhkars audio
final adhkarAudioUrlsProvider = FutureProvider<AdhkarAudioUrls>((ref) async {
  final usecase = ref.read(adhkarAudioUrlsUseCaseProvider);
  return usecase();
});
