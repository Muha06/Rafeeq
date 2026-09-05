import 'package:hive/hive.dart';

part 'generated/dhikr_bookmark_hive_model.g.dart';

@HiveType(typeId: 32) // make sure this ID is unique in your app
class DhikrBookmarkHiveModel extends HiveObject {
  @HiveField(0)
  final String dhikrId; //dhikr id

  @HiveField(1)
  final String categoryTitle;

  @HiveField(2)
  final String dhikrTitle;

  @HiveField(3)
  final String arabic;

  @HiveField(4)
  final String translation;

  @HiveField(5)
  final int  repeat;


  @HiveField(6)
  final String categoryId;

  @HiveField(7)
  final int createdAtMillis;

  DhikrBookmarkHiveModel({
    required this.dhikrId,
    required this.dhikrTitle,
    required this.arabic,
    required this.translation,
    required this.categoryTitle,
    required this.repeat,
    required this.createdAtMillis,
    required this.categoryId,
  });
}
