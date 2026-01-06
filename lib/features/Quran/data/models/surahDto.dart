import 'package:rafeeq/features/Quran/domain/entities/surah.dart';

class SurahDto {
  final int id;
  final String nameArabic;
  final String nameSimple;
  final String nameComplex;
  final int versesCount;
  final String revelationPlace;
  final String translatedName;

  const SurahDto({
    required this.id,
    required this.nameArabic,
    required this.nameSimple,
    required this.nameComplex,
    required this.versesCount,
    required this.revelationPlace,
    required this.translatedName,
  });

  factory SurahDto.fromJson(Map<String, dynamic> json) {
    return SurahDto(
      id: json['id'],
      nameArabic: json['name_arabic'],
      nameSimple: json['name_simple'],
      nameComplex: json['name_complex'],
      versesCount: json['verses_count'],
      revelationPlace: json['revelation_place'],
      translatedName: json['translated_name']?['name'] ?? '',
    );
  }

  //======TO ENTITY=======
  Surah toEntity() {
    return Surah(
      id: id,
      nameArabic: nameArabic,
      nameEnglish: translatedName,
      nameTransliteration: nameSimple,
      versesCount: versesCount,
      isMeccan: revelationPlace == 'makkah',
    );
  }
}
