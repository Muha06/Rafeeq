import 'package:rafeeq/features/quran/domain/entities/ayah.dart';

class AyahDto {
  final int id;
  final int ayahNumber;
  final int surahId;
  final String arabic;
  final String english;

  AyahDto({
    required this.id,
    required this.ayahNumber,
    required this.surahId,
    required this.arabic,
    required this.english,
  });

  factory AyahDto.fromJson(Map<String, dynamic> json) {
    final translations = json['translations'] as List<dynamic>?;

    return AyahDto(
      id: json['id'],
      ayahNumber: json['verse_number'],
      surahId: int.parse(json['verse_key'].toString().split(':')[0]),
      arabic: json['text_uthmani'] ?? '',
      english: translations != null && translations.isNotEmpty
          ? cleanTranslation(translations.first['text']) ?? ''
          : '',
    );
  }

  // Convert to your entity
  Ayah toEntity() {
    return Ayah(
      id: id,
      surahId: surahId,
      ayahNumber: ayahNumber,
      textArabic: arabic,
      textEnglish: english,
    );
  }
}

String? cleanTranslation(String html) {
  return html
      // remove footnote superscripts like <sup foot_note=...>1</sup>
      .replaceAll(RegExp(r'<sup[^>]*>.*?</sup>'), '')
      // remove any remaining HTML tags
      .replaceAll(RegExp(r'<[^>]+>'), '')
      // normalize spaces
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}
