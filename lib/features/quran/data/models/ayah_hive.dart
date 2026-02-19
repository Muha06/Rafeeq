import 'package:hive/hive.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';

part 'ayah_hive.g.dart';

@HiveType(typeId: 2) // typeID should be unique
class AyahHive extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  int surahId;

  @HiveField(2)
  int ayahNumber;

  @HiveField(3)
  String textArabic;

  @HiveField(4)
  String textEnglish;

  @HiveField(5)
  String textTransliteration;

  AyahHive({
    required this.id,
    required this.surahId,
    required this.ayahNumber,
    required this.textArabic,
    required this.textEnglish,
    required this.textTransliteration,
  });

  // helper to convert to Entity
  Ayah toEntity() {
    return Ayah(
      id: id,
      surahId: surahId,
      ayahNumber: ayahNumber,
      textArabic: textArabic,
      textEnglish: textEnglish,
      transliteration: textTransliteration,
    );
  }

  //factory from Entity
  factory AyahHive.fromEntity(Ayah ayah) {
    return AyahHive(
      id: ayah.id,
      surahId: ayah.surahId,
      ayahNumber: ayah.ayahNumber,
      textArabic: ayah.textArabic,
      textEnglish: ayah.textEnglish,
      textTransliteration: ayah.transliteration,
    );
  }
}
