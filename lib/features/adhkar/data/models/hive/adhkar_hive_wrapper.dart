import 'package:hive/hive.dart';
import 'dhikr_hive_model.dart';

part 'generated/adhkar_hive_wrapper.g.dart';

@HiveType(typeId: 36)
class AdhkarHiveWrapper extends HiveObject {
  @HiveField(0)
  final String categoryId;

  @HiveField(1)
  final DateTime cachedAt;

  @HiveField(2)
  final List<DhikrHiveModel> dhikrs;

  AdhkarHiveWrapper({
    required this.categoryId,
    required this.cachedAt,
    required this.dhikrs,
  });
}
