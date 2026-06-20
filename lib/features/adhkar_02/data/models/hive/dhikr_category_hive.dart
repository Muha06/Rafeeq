import 'package:hive/hive.dart';
import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_category.dart';

part 'dhikr_category_hive.g.dart';

@HiveType(typeId: 33)
class DhikrCategoryHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String slug;

  @HiveField(3)
  final int sortOrder;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime updatedAt;

    DhikrCategoryHive({
    required this.id,
    required this.title,
    required this.slug,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DhikrCategoryHive.fromEntity(DhikrCategory c) {
    return DhikrCategoryHive(
      id: c.id,
      title: c.title,
      slug: c.slug,
      sortOrder: c.sortOrder,
      createdAt: c.createdAt,
      updatedAt: c.updatedAt,
    );
  }

  DhikrCategory toEntity() {
    return DhikrCategory(
      id: id,
      title: title,
      slug: slug,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
