import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_translation.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/translations_enum.dart';

class AllahName {
  final int number;
  final String arabic;
  final String transliteration;
  final Map<AllahNameLanguage, AllahNameTranslation> translations;
  final String audioUrl;

  const AllahName({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.translations,
    required this.audioUrl,
  });

  String get id => number.toString();
}
