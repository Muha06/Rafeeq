class Ayah {
  final int id;
  final int surahId; //surah in which verse is in
  final int ayahNumber;
  final String textArabic; //
  final String textEnglish; //English translation
  final String transliteration;

  const Ayah({
    required this.id,
    required this.surahId,
    required this.ayahNumber,
    required this.textArabic,
    required this.textEnglish,
    required this.transliteration,
  });
}
