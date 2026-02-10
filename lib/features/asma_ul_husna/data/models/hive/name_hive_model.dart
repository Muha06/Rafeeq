import 'package:hive/hive.dart';

part 'name_hive_model.g.dart'; // only if you use generator

@HiveType(typeId: 30) // pick an unused id
class AllahNameHive extends HiveObject {
  @HiveField(0)
  final int number;

  @HiveField(1)
  final String nameAr;

  @HiveField(2)
  final String transliteration;

  @HiveField(3)
  final String meaningEn;

  AllahNameHive({
    required this.number,
    required this.nameAr,
    required this.transliteration,
    required this.meaningEn,
  });
}
