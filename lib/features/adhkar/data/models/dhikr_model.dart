// Model (for JSON parsing)
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';

class DhikrModel {
  final int id;
  final String arabicText;
  final String transliteration;
  final String translation;
  final int repeat;
  final String audioUrl;
  final String categoryTitle;

  DhikrModel({
    required this.id,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.repeat,
    required this.audioUrl,
    required this.categoryTitle,
  });

  factory DhikrModel.fromJson({
    required Map<String, dynamic> json,
    required String categoryTitle,
  }) {
    String cleanTexts(String? text) {
      if (text == null) return '';
      text = text.trim();
      if (text.startsWith('(') && text.endsWith(')')) {
        text = text.substring(1, text.length - 1).trim();
      }
      return text;
    }

    return DhikrModel(
      id: json['ID'] as int,
      categoryTitle: categoryTitle,
      arabicText: cleanTexts(json['ARABIC_TEXT'] as String),
      transliteration: cleanTexts(
        json['LANGUAGE_ARABIC_TRANSLATED_TEXT'] as String? ?? '',
      ),
      translation: cleanTexts(json['TRANSLATED_TEXT'] as String? ?? ''),
      repeat: json['REPEAT'] as int? ?? 1,
      audioUrl: json['AUDIO'] as String? ?? '',
    );
  }

  DhikrEntity toEntity({required int categoryId}) {
    return DhikrEntity(
      id: id,
      categoryTitle: categoryTitle,
      arabicText: arabicText,
      transliteration: transliteration,
      translation: translation,
      repeat: repeat,
      audioUrl: audioUrl,
      categoryId: categoryId,
    );
  }
}
