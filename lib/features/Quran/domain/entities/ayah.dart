class Ayah {
  final int id;
  final int surahId;
  final int ayahNumber;
  final String textArabic;
  final String textEnglish;
  final int juz;
  final int page;

  const Ayah({
    required this.id,
    required this.surahId,
    required this.ayahNumber,
    required this.textArabic,
    required this.textEnglish,
    required this.juz,
    required this.page,
  });
}

enum RevelationType { meccan, medinan }

//sample data

const List<Ayah> ayahsFatiha = [
  Ayah(
    id: 1,
    surahId: 1,
    ayahNumber: 1,
    textArabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    textEnglish: 'In the name of Allah, the Most Gracious, the Most Merciful.',
    juz: 1,
    page: 1,
  ),
  Ayah(
    id: 2,
    surahId: 1,
    ayahNumber: 2,
    textArabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    textEnglish: 'All praise is for Allah—Lord of all worlds.',
    juz: 1,
    page: 1,
  ),
  Ayah(
    id: 3,
    surahId: 1,
    ayahNumber: 3,
    textArabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
    textEnglish: 'The Most Gracious, the Most Merciful.',
    juz: 1,
    page: 1,
  ),
  Ayah(
    id: 4,
    surahId: 1,
    ayahNumber: 4,
    textArabic: 'مَالِكِ يَوْمِ الدِّينِ',
    textEnglish: 'Master of the Day of Judgment.',
    juz: 1,
    page: 1,
  ),
  Ayah(
    id: 5,
    surahId: 1,
    ayahNumber: 5,
    textArabic: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
    textEnglish: 'You alone we worship, and You alone we ask for help.',
    juz: 1,
    page: 1,
  ),
  Ayah(
    id: 6,
    surahId: 1,
    ayahNumber: 6,
    textArabic: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
    textEnglish: 'Guide us to the straight path.',
    juz: 1,
    page: 1,
  ),
  Ayah(
    id: 7,
    surahId: 1,
    ayahNumber: 7,
    textArabic:
        'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
    textEnglish:
        'The path of those upon whom You have bestowed favor, not of those who have evoked Your anger or gone astray.',
    juz: 1,
    page: 1,
  ),
];

const List<Ayah> ayahsBaqara = [
  Ayah(
    id: 8,
    surahId: 2,
    ayahNumber: 1,
    textArabic: 'الم',
    textEnglish: 'Alif, Lam, Meem.',
    juz: 1,
    page: 2,
  ),

  Ayah(
    id: 9,
    surahId: 2,
    ayahNumber: 2,
    textArabic: 'ذَٰلِكَ الْكِتَابُ لَا رَيْبَ ۛ فِيهِ ۛ هُدًى لِّلْمُتَّقِينَ',
    textEnglish:
        'This is the Book! There is no doubt about it—a guide for those mindful of Allah.',
    juz: 1,
    page: 2,
  ),
];
