import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_auth_client.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_text_remote_ds.dart';
import 'package:rafeeq/features/quran/data/repositories/ayah_repo_impl.dart';
import 'package:rafeeq/features/quran/domain/entities/mushaf_page.dart';
import 'package:rafeeq/features/quran/domain/useCases/fetch_mushaf_page.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(); // load env variables

  String quranClientId = dotenv.env['QURAN_CLIENT_ID'] ?? '';
  String quranClientSecret = dotenv.env['QURAN_CLIENT_SECRET'] ?? '';

  final remote = QuranTextApiService(
    clientId: quranClientId,
    auth: QuranAuthClient(
      clientId: quranClientId,
      clientSecret: quranClientSecret,
      httpClient: http.Client(),
    ),
    client: http.Client(),
  );
  final repo = AyahRepositoryImpl(remoteDS: remote);
  final usecase = FetchMushafPageUseCase(repository: repo);

  try {
    final page = await usecase.call(page: 1);
    debugPrint('Fetched Mushaf page: ${page.pageNumber}');

    expect(page, isA<MushafPage>());
  } catch (e, st) {
    debugPrint("Error: $e, $st");
  }
  http.Client().close();
}
