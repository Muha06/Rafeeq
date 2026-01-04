class Surah {
  final int id;
  final String nameArabic;
  final String nameEnglish;
  final int versesCount;
  final bool isMeccan;

  const Surah({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.versesCount,
    required this.isMeccan,
  });
}

//sample data

const List<Surah> surahs = [
  Surah(
    id: 1,
    nameArabic: 'الفاتحة',
    nameEnglish: 'Al-Fatiha',
    versesCount: 7,
    isMeccan: true,
  ),
  Surah(
    id: 2,
    nameArabic: 'البقرة',
    nameEnglish: 'Al-Baqarah',
    versesCount: 286,
    isMeccan: false,
  ),
];
