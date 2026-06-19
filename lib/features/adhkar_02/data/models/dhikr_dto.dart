import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_entity.dart';

class DhikrDto {
  final String id;
  final String title;
  final String arabicText;
  final String englishText;
  final String? transliteration;
  final int repeat;
  final int sortOrder;
  final String categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? audio;

  const DhikrDto({
    required this.id,
    required  this.title,
    required this.arabicText,
    required this.englishText,
    this.transliteration,
    required this.repeat,
    required this.sortOrder,
    required this.categoryId,
      this.audio,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 🧠 fromJson (API → DTO)
  factory DhikrDto.fromJson(Map<String, dynamic> json) {
    return DhikrDto(
      id: json['id'] as String,
      title: json['title'] as String,
      arabicText: json['arabic'] as String,
      englishText: json['english'] as String,
      transliteration: json['transliteration'] as String?,
      repeat: json['repeats'] as int,
      sortOrder: json['sort_order'] as int,
      categoryId: json['category_id'] as String,
      audio: json['audio_url'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  /// 🔁 DTO → Model (clean layer)
  Dhikr toEntity() {
    return Dhikr(
      id: id,
      title: title,
      arabicText: arabicText,
      englishText: englishText,
      transliteration: transliteration,
      repeat: repeat,
      audioUrl: audio,
      categoryId: categoryId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
