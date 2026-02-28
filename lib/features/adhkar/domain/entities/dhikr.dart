// Entity (used across the app, pure domain)
class DhikrEntity {
  final int id;
  final String categoryTitle;
  final String arabicText;
  final String transliteration;
  final String translation;
  final int repeat;
  final String audioUrl;
  final int categoryId;

  const DhikrEntity({
    required this.id,
    required this.categoryTitle,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.repeat,
    required this.audioUrl,
    required this.categoryId,
  });
}
