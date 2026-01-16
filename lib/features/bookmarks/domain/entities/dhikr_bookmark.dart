class DhikrBookmark {
  final String dhikrId; // points to Dhikr.id
  final String title; // quick display
  final DateTime createdAt;

  const DhikrBookmark({
    required this.dhikrId,
    required this.title,
    required this.createdAt,
  });
}
