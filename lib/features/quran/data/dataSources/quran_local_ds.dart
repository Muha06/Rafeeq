import 'package:rafeeq/features/quran/data/dataSources/quran_db_manager.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:quran/quran.dart' as quran;
import 'package:rafeeq/features/quran/domain/entities/surah_info.dart';

abstract class QuranLocalDataSource {
  Future<List<Ayah>> getAyahs(int surahId);
  List<Surah> getSurahs();
  Surah getSurahById(int surahId);
  Future<SurahInfo?> getSurahInfo(int surahId);
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  //Translation dbs
  QuranDatabaseManager dbs;

  QuranLocalDataSourceImpl({required this.dbs});

  @override
  Future<List<Ayah>> getAyahs(int surahId) async {
    //  fetch both at the same time
    final results = await Future.wait([
      dbs.arDb.query(
        'verses',
        where: 'surah = ?',
        whereArgs: [surahId],
        // orderBy: 'ayah ASC',
      ),
      dbs.enDb.query(
        'translation',
        where: 'sura = ?',
        whereArgs: [surahId],
        orderBy: 'ayah ASC',
      ),
      dbs.swDb.query(
        'translation',
        where: 'sura = ?',
        whereArgs: [surahId],
        orderBy: 'ayah ASC',
      ),
      dbs.enTransliterationDb.query(
        'transliterations',
        where: 'sura = ?',
        whereArgs: [surahId],
        orderBy: 'ayah ASC',
      ),
    ]);

    final arList = results[0];
    final enList = results[1];
    final swList = results[2];
    final enTransliterationList = results[3];

    // 🧠 sanity check (VERY important)
    if (arList.length != enList.length || enList.length != swList.length) {
      throw Exception('Mismatch between Arabic and translation ayahs');
    }

    // 🔥 merge them
    return List.generate(arList.length, (index) {
      final ar = arList[index];
      final en = enList[index];
      final sw = swList[index];
      final enTransliteration = enTransliterationList[index];

      return Ayah(
        id: ar['id'] as int,
        surahId: surahId,
        ayahNumber: ar['ayah'] as int,
        textArabic: ar['text'] as String,
        textEnglish: en['text'] as String,
        textSwahili: sw['text'] as String,
        transliteration: enTransliteration['text'] as String,
        pageNumber: null,
        lineNumber: null,
        juz: null,
      );
    });
  }

  @override
  Future<SurahInfo?> getSurahInfo(int surahId) async {
    final result = await dbs.surahInfoDb.query(
      'surah_infos',
      where: 'surah_number = ?',
      whereArgs: [surahId],
      limit: 1,
    );

    if (result.isEmpty) return null;

    final row = result.first;

    return SurahInfo(
      surahNumber: row['surah_number'] as int,
      surahName: row['surah_name'] as String,
      text: row['text'] as String,
      shortText: row['short_text'] as String,
    );
  }

  @override
  List<Surah> getSurahs() {
    final count = quran.totalSurahCount;

    return List.generate(count, (index) {
      final id = index + 1;

      return Surah(
        id: id,
        isMeccan: quran.getPlaceOfRevelation(id) == 'Makkah',
        nameEnglish: quran.getSurahNameEnglish(id),
        nameArabic: quran.getSurahNameArabic(id),
        nameTransliteration: quran.getSurahName(id),
        versesCount: quran.getVerseCount(id),
      );
    });
  }

  @override
  Surah getSurahById(int surahId) {
    final surahs = getSurahs();

    return surahs.firstWhere((s) => s.id == surahId);
  }
}
