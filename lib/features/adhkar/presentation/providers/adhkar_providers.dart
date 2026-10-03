import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/adhkar/presentation/providers/wiring_provider.dart';

final adhkarCategoriesProvider = FutureProvider((ref) async {
  final usecase = ref.watch(fetchAllCategoriesUsecaseProvider);
  return await usecase.call();
});

final adhkarProvider = FutureProvider.family((
  ref,
  String subcategoryId,
) async {
  final usecase = ref.watch(fetchAllAdhkarUsecaseProvider);
  return await usecase.call(subcategoryId);
});
