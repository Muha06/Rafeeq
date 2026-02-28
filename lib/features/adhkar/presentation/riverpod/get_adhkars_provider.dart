import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/adhkar/data/datasources/adhkar_category_list.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_audio_urls.dart';
import 'package:rafeeq/features/adhkar/domain/entities/adhkar_category.dart';
import 'package:rafeeq/features/adhkar/domain/entities/dhikr.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/wiring_providers.dart';

//categories
final adhkarCategoriesProviders = Provider<List<DhikrCategory>>((ref) {
  return adhkarCategories;
});

//get Adhkars audio
final adhkarAudioUrlsProvider = FutureProvider<AdhkarAudioUrls>((ref) async {
  final usecase = ref.read(adhkarAudioUrlsUseCaseProvider);
  return usecase();
});

//get adhkars
final getAdhkarsProvider = FutureProvider.family<List<DhikrEntity>, List<int>>((
  ref,
  categoryIds,
) {
  final usecase = ref.watch(dhikrTextUseCaseProvider);

  return usecase.call(categoryIds);
});

// Preload adhkars dynamically
final preloadAdhkarsProvider = FutureProvider<void>((ref) async {
  final usecase = ref.watch(dhikrTextUseCaseProvider);

  // Get all categories
  final allCategories = ref.watch(adhkarCategoriesProviders);

  // Flatten all subcategory IDs into a single list
  final allSubcategoryIds = allCategories
      .expand((category) => category.categoryIds)
      .toList();

  try {
    // Fetch & cache all adhkars
    await usecase.call(allSubcategoryIds);
    debugPrint('Preloaded ${allSubcategoryIds.length} subcategories');
  } catch (e) {
    debugPrint('Error preloading adhkars: $e');
  }
});
