import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:quran/quran.dart' as quran;

class QuranLocalDataSource {
  List<Surah> getAllSurahs() {
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
