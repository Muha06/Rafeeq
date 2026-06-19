class DhikrCategory {
  final String id;
  final String title;
  final String slug;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
 
  const DhikrCategory({
    required this.id,
    required this.title,
    required this.slug,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
   });
}
