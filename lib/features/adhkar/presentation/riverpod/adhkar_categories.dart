import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_category.dart';

final getAdhkarCategoriesProvider = Provider<List<AdhkarCategory>>((ref) {
  return const [
    AdhkarCategory(
      key: 'general',
      title: 'Daily Adhkars',
      assetPath: 'assets/adhkar/general.json',
      imagePath: 'assets/images/category/daily.png',
    ),
    AdhkarCategory(
      key: 'morning',
      title: 'Morning Adhkar',
      assetPath: 'assets/adhkar/morning.json',
      imagePath: 'assets/images/category/sunrise.png',
    ),
    AdhkarCategory(
      key: 'evening',
      title: 'Evening Adhkar',
      assetPath: 'assets/adhkar/evening.json',
      imagePath: 'assets/images/category/sunset.png',
    ),
    AdhkarCategory(
      key: 'after_salah',
      title: 'After Salah',
      assetPath: 'assets/adhkar/after_salah.json',
      imagePath: 'assets/images/home/tasbih.png',
    ),
  ];
});
