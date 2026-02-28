import 'package:hive/hive.dart';
import '../../domain/entities/dhikr.dart';

part 'dhikr_hive_model.g.dart';  

@HiveType(typeId: 0)
class DhikrHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String categoryTitle;

  @HiveField(2)
  final String arabicText;

  @HiveField(3)
  final String transliteration;

  @HiveField(4)
  final String translation;

  @HiveField(5)
  final int repeat;

  @HiveField(6)
  final String audioUrl;

  @HiveField(7)
  final int categoryId;

  DhikrHiveModel({
    required this.id,
    required this.categoryTitle,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.repeat,
    required this.audioUrl,
    required this.categoryId,
  });

  // Convert to domain entity
  DhikrEntity toEntity() => DhikrEntity(
    id: id,
    categoryTitle: categoryTitle,
    arabicText: arabicText,
    transliteration: transliteration,
    translation: translation,
    repeat: repeat,
    audioUrl: audioUrl,
    categoryId: categoryId,
  );

  // Convert from entity to Hive model
  factory DhikrHiveModel.fromEntity(DhikrEntity entity) => DhikrHiveModel(
    id: entity.id,
    categoryTitle: entity.categoryTitle,
    arabicText: entity.arabicText,
    transliteration: entity.transliteration,
    translation: entity.translation,
    repeat: entity.repeat,
    audioUrl: entity.audioUrl,
    categoryId: entity.categoryId,
  );
}
