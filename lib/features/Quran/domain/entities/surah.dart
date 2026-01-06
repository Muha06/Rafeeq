class Surah {
  final int id;
  final String nameArabic; // 'الفاتحة'
  final String nameEnglish; // 'The Opener'
  final String nameTransliteration; // 'Al Fatiha'
  final int versesCount;
  final bool isMeccan;

  const Surah({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.versesCount,
    required this.isMeccan,
  });
}


