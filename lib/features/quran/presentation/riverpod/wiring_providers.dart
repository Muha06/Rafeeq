import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_local_ds.dart';
import 'package:rafeeq/features/quran/data/repositories/quran_repo_impl.dart';
import 'package:rafeeq/features/quran/domain/repository/quran_repo.dart';
import 'package:rafeeq/features/quran/domain/usecases/get_surahs_usecase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String quranClientId = dotenv.env['QURAN_CLIENT_ID'] ?? '';
String quranClientSecret = dotenv.env['QURAN_CLIENT_SECRET'] ?? '';

//http client
final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final quranLocalDsProvider = FutureProvider<QuranLocalDataSource>((ref) async {
  final ds = QuranLocalDataSourceImpl();
  await ds.init();
  return ds;
});

//repository
final quranRepoProvider = Provider<QuranRepository>((ref) {
  final localDs = ref.read(quranLocalDsProvider.future);

  return QuranRepoImpl(localDs: localDs);
});

// UseCase provider
final getSurahsUseCaseProvider = Provider<GetSurahsUsecase>((ref) {
  final repo = ref.read(quranRepoProvider);
  return GetSurahsUsecase(repository: repo);
});
