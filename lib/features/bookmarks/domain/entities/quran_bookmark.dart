 
class QuranBookmarkEntity {
  final String id;
  final int surahId;

  /// Text shown directly in bookmarks list
  final String surahEnglishName; //bookmarked surah name
  final int ayahNumber; //bookmarked ayah number

  final DateTime createdAt;

  const QuranBookmarkEntity({
    required this.id,
    required this.surahId,
    required this.surahEnglishName,
    required this.ayahNumber,
    required this.createdAt,
  });
}
