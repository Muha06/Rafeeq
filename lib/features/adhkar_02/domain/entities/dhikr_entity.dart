class Dhikr {
  final String id;
  final String title;
  final String arabicText;
  final String englishText;
  final String? transliteration;
  final int repeat;
  final String? audioUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String categoryId;

  const Dhikr({
    required this.id,
    required  this.title,
    required this.arabicText,
    required this.englishText,
    this.transliteration,
    required this.repeat,
      this.audioUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
  });
}
