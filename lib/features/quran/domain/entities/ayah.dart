class Ayah {
  final int id;
  final int surahId; //surah in which verse is in
  final int ayahNumber;
  final String textArabic; //
  final String textEnglish; //English translation
  final String transliteration;

  final int? pageNumber;
  int? lineNumber;
  final int? juz;

    Ayah({
    required this.id,
    required this.surahId,
    required this.ayahNumber,
    required this.textArabic,
    required this.textEnglish,
    required this.transliteration,
    required this.pageNumber,
    required this.lineNumber,
    required this.juz,
  });

  String get verseKey => "$surahId:$ayahNumber";
}
