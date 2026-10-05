import 'package:flutter/widgets.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_db_manager.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:quran/quran.dart' as quran;
import 'package:rafeeq/features/quran/domain/entities/surah_info.dart';
import 'package:rafeeq/features/quran/domain/entities/wbw/word_by_word.dart';

abstract class QuranLocalDataSource {
  Future<List<Ayah>> getAyahs(int surahId);
  List<Surah> getSurahs();
  Surah getSurahById(int surahId);
  Future<SurahInfo?> getSurahInfo(int surahId);
  Future<WordByWord> getWordByWord(int surahId, int ayahNumber);
}

bool _isAyahNumberMarker(String text, int ayahNumber) {
  if (text.isEmpty) return false;

  final westernDigits = StringBuffer();
  for (final rune in text.runes) {
    if (rune >= 0x0660 && rune <= 0x0669) {
      westernDigits.writeCharCode(rune - 0x0660 + 0x30);
    } else if (rune >= 0x06f0 && rune <= 0x06f9) {
      westernDigits.writeCharCode(rune - 0x06f0 + 0x30);
    } else {
      return false;
    }
  }

  return int.tryParse(westernDigits.toString()) == ayahNumber;
}

class QuranLocalDataSourceImpl implements QuranLocalDataSource {
  final QuranDatabaseManager dbs;

  QuranLocalDataSourceImpl({required this.dbs});

  @override
  Future<List<Ayah>> getAyahs(int surahId) async {
    final results = await Future.wait([
      dbs.arDb.query(
        'verses',
        where: 'surah = ?',
        whereArgs: [surahId],
        orderBy: 'ayah ASC',
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

    debugPrint("Results: $results");
    debugPrint("Results length: ${results.length}");

    final arList = results[0];
    final enList = results[1];
    final swList = results[2];
    final enTransliterationList = results[3];

    return List.generate(arList.length, (index) {
      final ar = arList[index];
      final en = enList[index];
      final sw = swList[index];
      final enTransliteration = enTransliterationList[index];
      final ayahNumber = ar['ayah'] as int;

      return Ayah(
        id: ar['id'] as int,
        surahId: surahId,
        ayahNumber: ayahNumber,
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

  // Get Word by Word translation for a specific Surah and Ayah
  @override
  Future<WordByWord> getWordByWord(int surahId, int ayahNumber) async {
    final results = await Future.wait([
      dbs.wbwArabicDb.query(
        'words',
        where: 'surah = ? AND ayah = ?',
        whereArgs: [surahId, ayahNumber],
      ),
      dbs.wbwEnglishDb.query(
        'word_translation',
        where: 'surah_number = ? AND ayah_number = ?',
        whereArgs: [surahId, ayahNumber],
      ),
    ]);

    final arabicResults = results[0];
    final englishResults = results[1];

    debugPrint("Arabic Results: $arabicResults");
    debugPrint("English Results: $englishResults");

    if (arabicResults.isEmpty || englishResults.isEmpty) {
      throw Exception(
        'No word-by-word data found for Surah $surahId, Ayah $ayahNumber',
      );
    }

    final englishByWord = {
      for (final row in englishResults)
        int.parse(row['word_number'].toString()): row['text'] as String,
    };

    final words = arabicResults.map((arabicRow) {
      final arabic = arabicRow['text'] as String;
      if (_isAyahNumberMarker(arabic, ayahNumber)) return null;

      final wordNumber = int.parse(arabicRow['word'].toString());
      final english = englishByWord[wordNumber];

      if (english == null) {
        throw Exception(
          'Missing English translation for Surah $surahId, '
          'Ayah $ayahNumber, word $wordNumber',
        );
      }

      return WordByWordWord(
        wordNumber: wordNumber,
        arabic: arabic,
        english: english,
      );
    }).whereType<WordByWordWord>().toList();
    words.sort((a, b) => a.wordNumber.compareTo(b.wordNumber));

    return WordByWord(
      surahNumber: surahId,
      ayahNumber: ayahNumber,
      words: words,
    );
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
