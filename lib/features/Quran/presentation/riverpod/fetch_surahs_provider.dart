// Repository provider (inject your implementation here)
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/Quran/data/dataSources/Quran_remote_ds.dart';
import 'package:rafeeq/features/Quran/data/repositories/surah_repo_impl.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/domain/repository/surah_repo.dart';
import 'package:rafeeq/features/Quran/domain/useCases/fetch_surahs_useCase.dart';

String client_id = '02f06383-9a7d-4fc1-9d7d-30689409362d';
String client_secret = 'YWQztxHhJeyv.vX44~NA~KgB8U';

//http client
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client(); // single client reused
});

//api service
final remoteApiServiceProvider = Provider((ref) {
  final client = ref.watch(httpClientProvider);

  return QuranApiService(
    clientId: client_id,
    clientSecret: client_secret,
    client: client,
  );
});

//repository 
final surahRepositoryProvider = Provider<SurahRepository>((ref) {
  final apiService = ref.watch(remoteApiServiceProvider);

  return SurahRepositoryImpl(apiService: apiService);
});

// UseCase provider
final getSurahsUseCaseProvider = Provider<GetSurahsUseCase>((ref) {
  final repo = ref.read(surahRepositoryProvider);
  return GetSurahsUseCase(repository: repo);
});

// FutureProvider fetches the actual list of Surahs
final surahsFutureProvider = FutureProvider<List<Surah>>((ref) async {
  final useCase = ref.read(getSurahsUseCaseProvider);
  return await useCase.execute();
});
