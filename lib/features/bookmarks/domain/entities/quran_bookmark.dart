class QuranBookmarkEntity {
  final String id;
  final int surahId; 
  final String surahName;  
  final String ayahArabic; 
  final String ayahTranslation; 
  final int ayahNumber;  

  final DateTime createdAt;

  const QuranBookmarkEntity({
    required this.id,
    required this.surahId,
    required this.surahName,
    required this.ayahArabic,
    required this.ayahTranslation,
    required this.ayahNumber,
    required this.createdAt,
  });
}
