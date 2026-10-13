import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/connectivity_plus/conectivity_plus_provider.dart';
import 'package:rafeeq/features/adhkar/presentation/providers/wiring_provider.dart';

final prefetchAdhkarCacheProvider = FutureProvider<void>((ref) async {
  final isOnline = await ref
      .read(hasInternetConnectionProvider.notifier)
      .waitForInitialCheck();
      
  if (!isOnline) return;

  final categories = await ref.read(fetchAllCategoriesUsecaseProvider).call();
  final fetchAllAdhkar = ref.read(fetchAllAdhkarUsecaseProvider);

  for (final category in categories) {
    await fetchAllAdhkar.call(category.id);
  }
});

final adhkarCategoriesProvider = FutureProvider((ref) async {
  final usecase = ref.watch(fetchAllCategoriesUsecaseProvider);
  return await usecase.call();
});

final adhkarProvider = FutureProvider.family((ref, String subcategoryId) async {
  final usecase = ref.watch(fetchAllAdhkarUsecaseProvider);
  return await usecase.call(subcategoryId);
});
