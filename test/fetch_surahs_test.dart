import 'package:flutter/cupertino.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_text_local.dart';
import 'package:rafeeq/features/quran/data/repositories/surah_repo_impl.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';

void main() async {
  // await dotenv.load(); // load env variables

  // String quranClientId = dotenv.env['QURAN_CLIENT_ID'] ?? '';
  // String quranClientSecret = dotenv.env['QURAN_CLIENT_SECRET'] ?? '';

  test('Surah repository returns a list of Surah', () async {
    final local = QuranLocalDataSource();
    final surahRepo = SurahRepositoryImpl(local: local);

    final surahs = surahRepo.getSurahs();
    final surah = surahs[1];

    debugPrint(
      "Surah ${surah.versesCount} ${surah.nameArabic} ${surah.nameEnglish} ${surah.nameTransliteration} ${surah.isMeccan}",
    );

    expect(surahs, isA<List<Surah>>());
  });
}
