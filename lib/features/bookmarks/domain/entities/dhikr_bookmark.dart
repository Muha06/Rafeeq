class DhikrBookmark {
  final int dhikrId; // points to Dhikr.id
  final String title; // quick display
  final int categoryId;
  final DateTime createdAt;

  const DhikrBookmark({
    required this.dhikrId,
    required this.title,
    required this.categoryId,

    required this.createdAt,
  });
}
