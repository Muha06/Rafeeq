import 'package:rafeeq/features/adhkar_02/domain/entities/dhikr_category.dart';

class DhikrCategoryDto {
  final String id;
  final String title;
  final String slug;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;

  const DhikrCategoryDto({
    required this.id,
    required this.title,
    required this.slug,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 🧠 fromJson (API → DTO)
  factory DhikrCategoryDto.fromJson(Map<String, dynamic> json) {
    return DhikrCategoryDto(
      id: json['id'],
      title: json['title'],
      slug: json['slug'],
      sortOrder: json['sort_order'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  /// 🔁 DTO → Domain Model
  DhikrCategory toEntity() {
    return DhikrCategory(
      id: id,
      title: title,
      slug: slug,
      sortOrder: sortOrder,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }
}
