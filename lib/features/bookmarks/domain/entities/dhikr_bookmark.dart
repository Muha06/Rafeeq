class DhikrBookmark {
  final String dhikrId; // points to Dhikr.id
  final String categoryId;
  final String title;
  final String arabic;
  final String translation;
  final String categoryTitle;
  final int repeat;
  final DateTime createdAt;

  const DhikrBookmark({
    required this.dhikrId,
    required this.categoryId,
    required this.title,
    required this.arabic,
    required this.translation,
    required this.categoryTitle,
    required this.repeat,
    required this.createdAt,
  });
}
