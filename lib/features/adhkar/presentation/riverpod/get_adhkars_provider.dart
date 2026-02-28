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
