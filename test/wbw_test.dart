import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_db_manager.dart';
import 'package:rafeeq/features/quran/data/dataSources/quran_local_ds.dart';
import 'package:sqflite/ffi/sqflite_ffi.dart';

// test for wbw
void main() {
  late QuranLocalDataSourceImpl local;

  setUp(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    local = QuranLocalDataSourceImpl(dbs: QuranDatabaseManager());
    await local.dbs.init();
  });

  test('should return WordByWord model successfully', () async {
    final wbw = await local.getWordByWord(1, 1);

    debugPrint("WBW: ${wbw.words.length}");

    expect(wbw.surahNumber, 1);
    expect(wbw.ayahNumber, 1);
  });

  test('should keep multi-digit words in numeric Quran order', () async {
    final wbw = await local.getWordByWord(2, 4);

    expect(wbw.words.map((word) => word.wordNumber).toList(), [
      for (var wordNumber = 1; wordNumber <= 12; wordNumber++) wordNumber,
    ]);
    expect(wbw.words[9].english, 'and in the Hereafter');
  });

  test('should omit the ayah number marker', () async {
    final wbw = await local.getWordByWord(1, 2);

    expect(wbw.words.map((word) => word.arabic), isNot(contains('٢')));
    expect(wbw.words.map((word) => word.english), isNot(contains('(2)')));
  });
}
