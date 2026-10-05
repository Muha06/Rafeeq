import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah_info.dart';
import 'package:rafeeq/features/quran/domain/entities/wbw/word_by_word.dart';

abstract class QuranRepository {
  Future<List<Ayah>> getAyahs(int surahId);
  Future<List<Surah>> getSurahs();
  Future<SurahInfo?> getSurahInfo(int surahId);
  Future<WordByWord> getWordByWord(int surahId, int ayahNumber);
}
