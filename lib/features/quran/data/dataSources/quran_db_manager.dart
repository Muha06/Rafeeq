import 'package:flutter/widgets.dart';
import 'package:rafeeq/core/helpers/Quran/quran_db_helpers.dart';
import 'package:sqflite/sqflite.dart';

class QuranDatabaseManager {
  Database? _arDb;
  Database? _enDb;
  Database? _swDb;
  Database? _enTransliterationDb;
  Database? _surahInfoDb;
  Database? _wbwEnglishDb;
  Database? _wbwArabicDb;

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

      _surahInfoDb = await QuranDbHelper.loadDatabase(
        'assets/db/surah-info-en.db',
        'surah_infos.db',
      );

      _wbwEnglishDb = await QuranDbHelper.loadDatabase(
        'assets/db/wbw/en_wbw.db',
        'en_wbw.db',
      );

      _wbwArabicDb = await QuranDbHelper.loadDatabase(
        'assets/db/wbw/ar_wbw.db',
        'ar_wbw.db',
      );
    } catch (e) {
      debugPrint("Error initializing Quran Databases: $e");
      rethrow;
    }
  }

  Database get arDb => _arDb!;
  Database get enDb => _enDb!;
  Database get swDb => _swDb!;
  Database get enTransliterationDb => _enTransliterationDb!;
  Database get surahInfoDb => _surahInfoDb!;
  Database get wbwEnglishDb => _wbwEnglishDb!;
  Database get wbwArabicDb => _wbwArabicDb!;
}
