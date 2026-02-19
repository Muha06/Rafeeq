import 'package:hive/hive.dart';

part 'surah_hive.g.dart';

@HiveType(typeId: 1)
class SurahHive extends HiveObject {
  @HiveField(0)
  int id; // same as surah number

  @HiveField(1)
  String nameArabic;

  @HiveField(2)
  String nameEnglish;

  @HiveField(3)
  String nameTransliteration;

  @HiveField(4)
  bool isMeccan;

  @HiveField(5)
  int versesCount;

  SurahHive({
    required this.id,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.isMeccan,
    required this.versesCount,
  });
}
