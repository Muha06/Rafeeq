import 'package:flutter/widgets.dart';
import 'package:rafeeq/core/helpers/Quran/quran_db_helpers.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:quran/quran.dart' as quran;
import 'package:sqflite/sqflite.dart';

abstract class QuranLocalDataSource {
  Future<List<Ayah>> getAyahs(int surahId);
  List<Surah> getSurahs();
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  //Translation dbs
  Database? _arDb;
  Database? _enDb;
  Database? _swDb;
  Database? _enTransliterationDb;

  Future<void> init() async {
    try {
      _arDb = await QuranDbHelper.loadDatabase(
        'assets/db/ar_ayah_text.db',
        'quran_ar.db',
      );

      _enDb = await QuranDbHelper.loadDatabase(
        'assets/db/en_ayah_text.db',
        'quran_en.db',
      );
      _swDb = await QuranDbHelper.loadDatabase(
        'assets/db/sw_ayah_text.db',
        'quran_sw.db',
      );
      _enTransliterationDb = await QuranDbHelper.loadDatabase(
        'assets/db/en_ayah_transliteration.db',
        'quran_en_transliteration.db',
      );
    } catch (e) {
      debugPrint('Error initializing Quran local data source: $e');
    }
  }

  @override
  Future<List<Ayah>> getAyahs(int surahId) async {
    // 🔥 fetch both at the same time
    final results = await Future.wait([
      _arDb!.query(
        'verses',
        where: 'surah = ?',
        whereArgs: [surahId],
        // orderBy: 'ayah ASC',
      ),
      _enDb!.query(
        'translation',
        where: 'sura = ?',
        whereArgs: [surahId],
        orderBy: 'ayah ASC',
      ),
      _swDb!.query(
        'translation',
        where: 'sura = ?',
        whereArgs: [surahId],
        orderBy: 'ayah ASC',
      ),
      _enTransliterationDb!.query(
        'transliterations',
        where: 'sura = ?',
        whereArgs: [surahId],
        orderBy: 'ayah ASC',
      ),
    ]);

    debugPrint(
      wrapWidth: 1000,
      "Fetched ${results[0].length} Arabic and ${results[1].length} English ayahs for surah $surahId and ${results[2].length}  Swahili ayahs:",
    );

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
}
