import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';

class AllahNameDto {
  final int number;
  final String arabic;
  final String transliteration;
  final String meaningEn;

  const AllahNameDto({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaningEn,
  });

  factory AllahNameDto.fromJson(Map<String, dynamic> json) {
    final en = (json['en'] as Map?)?.cast<String, dynamic>() ?? const {};
    final meaning = (en['meaning'] as String?) ?? '';

    return AllahNameDto(
      number: (json['number'] as num?)?.toInt() ?? 0,
      arabic: (json['name'] as String?) ?? '',
      transliteration: (json['transliteration'] as String?) ?? '',
      meaningEn: meaning,
    );
  }

  AllahName toEntity() => AllahName(
    number: number,
    arabic: arabic,
    transliteration: transliteration,
    meaningEn: meaningEn,
  );

  Map<String, dynamic> toJson() => {
    'name': arabic,
    'transliteration': transliteration,
    'number': number,
    'en': {'meaning': meaningEn},
  };
}
