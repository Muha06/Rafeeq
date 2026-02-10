class DhikrBookmark {
  final String dhikrId; // points to Dhikr.id
  final String title; // quick display
  final String assetPath; 
  final DateTime createdAt;

  const DhikrBookmark({
    required this.dhikrId,
    required this.title,
    required this.assetPath,
    required this.createdAt,
  });
}
