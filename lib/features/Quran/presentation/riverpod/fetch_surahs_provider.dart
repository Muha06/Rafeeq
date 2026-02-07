// Repository provider (inject your implementation here)
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/network/quran_auth_client.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_text_remote_ds.dart';
import 'package:rafeeq/features/quran/data/repositories/surah_repo_impl.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/domain/repository/surah_repo.dart';
import 'package:rafeeq/features/quran/domain/useCases/fetch_surahs_useCase.dart';
import 'package:riverpod/legacy.dart';

String quranClientId = dotenv.env['QURAN_CLIENT_ID'] ?? '';
String quranClientSecret = dotenv.env['QURAN_CLIENT_SECRET'] ?? '';

//http client
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

//auth client
final quranAuthClientProvider = Provider<QuranAuthClient>((ref) {
  final client = ref.read(httpClientProvider);
  return QuranAuthClient(
    clientId: quranClientId,
    clientSecret: quranClientSecret,
    httpClient: client,
  );
});

//api service
final quranremoteApiServiceProvider = Provider((ref) {
  final client = ref.watch(httpClientProvider);
  final auth = ref.watch(quranAuthClientProvider);

  return QuranTextApiService(
    clientId: quranClientId,
    auth: auth,
    client: client,
  );
});

//repository
final surahRepositoryProvider = Provider<SurahRepository>((ref) {
  final apiService = ref.watch(quranremoteApiServiceProvider);

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

//Quick surah links
final quickSurahLinksProvider = Provider<List<Surah>>((ref) {
  final surahsAsync = ref.watch(surahsFutureProvider);

  return surahsAsync.maybeWhen(
    data: (surahs) {
      const quickSurahIds = [1, 18, 36, 55, 67];

      return surahs.where((s) => quickSurahIds.contains(s.id)).toList();
    },
    orElse: () => [],
  );
});

final searchSurahTextProvider = StateProvider.autoDispose((ref) {
  return '';
});
