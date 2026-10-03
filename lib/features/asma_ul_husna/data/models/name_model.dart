import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_translation.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/translations_enum.dart';

class AllahNameModel extends AllahName {
  const AllahNameModel({
    required super.number,
    required super.arabic,
    required super.transliteration,
    required super.translations,
    required super.audioUrl,
  });

  factory AllahNameModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>;
    final translations = json['translations'] as Map<String, dynamic>;

    return AllahNameModel(
      number: json['number'] as int,
      arabic: name['arabic'] as String,
      transliteration: name['transliteration'] as String,
      audioUrl: json['audio_url'] as String,
      translations: translations.map(
        (key, value) => MapEntry(
          AllahNameLanguageX.fromJsonKey(key),
          AllahNameTranslation.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }

  AllahName toEntity() {
    return AllahName(
      number: number,
      arabic: arabic,
      transliteration: transliteration,
      translations: translations,
      audioUrl: audioUrl,
    );
  }
}
