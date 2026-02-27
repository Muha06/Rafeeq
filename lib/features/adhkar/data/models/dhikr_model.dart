// Model (for JSON parsing)
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';

class DhikrModel {
  final int id;
  final String arabicText;
  final String transliteration;
  final String translation;
  final int repeat;
  final String audioUrl;

  DhikrModel({
    required this.id,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.repeat,
    required this.audioUrl,
  });

  factory DhikrModel.fromJson(Map<String, dynamic> json) {
    return DhikrModel(
      id: json['ID'] as int,
      arabicText: json['ARABIC_TEXT'] as String,
      transliteration: json['LANGUAGE_ARABIC_TRANSLATED_TEXT'] as String? ?? '',
      translation: json['TRANSLATED_TEXT'] as String? ?? '',
      repeat: json['REPEAT'] as int? ?? 1,
      audioUrl: json['AUDIO'] as String? ?? '',
    );
  }

  DhikrEntity toEntity({required int categoryId}) {
    return DhikrEntity(
      id: id,
      arabicText: arabicText,
      transliteration: transliteration,
      translation: translation,
      repeat: repeat,
      audioUrl: audioUrl,
      categoryId: categoryId,
    );
  }
}
