import 'package:rafeeq/features/quran_tempt/domain/entities/ayah.dart';

class AyahDto {
  final int id;
  final int ayahNumber;
  final int surahId;
  final String arabic;
  final String english;
  final String tranliteration;

  AyahDto({
    required this.id,
    required this.ayahNumber,
    required this.surahId,
    required this.arabic,
    required this.english,
    required this.tranliteration,
  });

  factory AyahDto.fromJson(Map<String, dynamic> json) {
    final translations = (json['translations'] as List<dynamic>?)
        ?.cast<Map<String, dynamic>>();

    String? textById(int id) {
      final t = translations?.firstWhere(
        (m) => m['resource_id'] == id,
        orElse: () => const {},
      );
      final text = t?['text'];
      return text is String ? text : null;
    }

    final englishRaw = textById(20);
    final translitRaw = textById(57);

    return AyahDto(
      id: json['id'] as int,
      ayahNumber: json['verse_number'] as int,
      surahId: int.parse((json['verse_key'] as String).split(':')[0]),
      arabic: (json['text_uthmani'] as String?) ?? '',
      english: cleanTranslation(englishRaw ?? '') ?? '',
      tranliteration: cleanTranslation(translitRaw ?? '') ?? '',
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
      transliteration: tranliteration,
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
