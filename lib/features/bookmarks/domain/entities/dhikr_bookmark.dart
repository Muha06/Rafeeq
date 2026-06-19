class DhikrBookmark {
  final String dhikrId; // points to Dhikr.id
  final String title; // quick display
  final String categoryId; 
  final DateTime createdAt;

  const DhikrBookmark({
    required this.dhikrId,
    required this.title,
    required this.categoryId,
    required this.createdAt,
  });
}
