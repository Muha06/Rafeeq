class DhikrCategory {
  static const String fallbackPreviewAsset =
      'assets/images/adhkar/morning.jpeg';

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

  String get previewAssetPath {
    final normalizedSlug = slug.trim().toLowerCase();
    const assets = <String, String>{
      'before-sleeping': 'assets/images/adhkar/before-sleeping.jpeg',
      'daily-routine': 'assets/images/adhkar/daily-routine.jpeg',
      'emotional-states': 'assets/images/adhkar/emotional-states.jpeg',
      'evening': 'assets/images/adhkar/evening.jpeg',
      'morning': 'assets/images/adhkar/morning.jpeg',
      'salah': 'assets/images/adhkar/salah.jpeg',
      'salah2': 'assets/images/adhkar/salah2.jpeg',
      'waking-up': 'assets/images/adhkar/waking-up.jpeg',
    };

    return assets[normalizedSlug] ?? fallbackPreviewAsset;
  }
}
