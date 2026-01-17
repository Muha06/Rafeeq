import 'package:hive/hive.dart';

part 'quran_bookmark_hive_model.g.dart';

@HiveType(typeId: 31) // make sure this ID is unique in your app
class QuranBookmarkHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int surahId;

  @HiveField(2)
  final String surahEnglishName;

  @HiveField(3)
  final int ayahNumber;

  @HiveField(4)
  final int createdAtMillis;

  QuranBookmarkHiveModel({
    required this.id,
    required this.surahId,
    required this.surahEnglishName,
    required this.ayahNumber,
    required this.createdAtMillis,
  });
}
