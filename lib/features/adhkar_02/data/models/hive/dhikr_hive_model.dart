import 'package:hive/hive.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_entity.dart';

part 'dhikr_hive_model.g.dart';

@HiveType(typeId: 34)
class DhikrHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String arabicText;

  @HiveField(3)
  final String englishText;

  @HiveField(4)
  final String? transliteration;

  @HiveField(5)
  final int repeat;

  @HiveField(6)
  final int sortOrder;

  @HiveField(7)
  final String? audioUrl;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime updatedAt;

  @HiveField(10)
  final String categoryId;

    DhikrHiveModel({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.englishText,
    this.transliteration,
    required this.repeat,
    required this.sortOrder,
    this.audioUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.categoryId,
  });

  // 🔁 mapping helpers
  factory DhikrHiveModel.fromEntity(Dhikr d) {
    return DhikrHiveModel(
      id: d.id,
      title: d.title,
      arabicText: d.arabicText,
      englishText: d.englishText,
      transliteration: d.transliteration,
      repeat: d.repeat,
      sortOrder: d.sortOrder,
      audioUrl: d.audioUrl,
      createdAt: d.createdAt,
      updatedAt: d.updatedAt,
      categoryId: d.categoryId,
    );
  }

  Dhikr toEntity() {
    return Dhikr(
      id: id,
      title: title,
      arabicText: arabicText,
      englishText: englishText,
      transliteration: transliteration,
      repeat: repeat,
      sortOrder: sortOrder,
      audioUrl: audioUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      categoryId: categoryId,
    );
  }
}
