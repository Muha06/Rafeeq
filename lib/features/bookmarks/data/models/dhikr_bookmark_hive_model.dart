import 'package:hive/hive.dart';

part 'dhikr_bookmark_hive_model.g.dart';

@HiveType(typeId: 32) // make sure this ID is unique in your app
class DhikrBookmarkHiveModel extends HiveObject {
  @HiveField(0)
  final String dhikrId; //dhikr id

  @HiveField(1)
  final String dhikrTitle;

  @HiveField(2)
  final int createdAtMillis;

  @HiveField(3)
  final String assetPath;

  DhikrBookmarkHiveModel({
    required this.dhikrId,
    required this.dhikrTitle,
    required this.createdAtMillis,
    required this.assetPath,
  });
}
