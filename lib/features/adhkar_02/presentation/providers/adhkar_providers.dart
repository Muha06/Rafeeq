import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/adhkar_02/presentation/providers/wiring_provider.dart';

final fetchAdhkarCategoriesProvider = FutureProvider.autoDispose((ref) async {
  final usecase = ref.watch(fetchAllCategoriesUsecaseProvider);
  return await usecase.call();
});

final fetchAllAdhkarProvider = FutureProvider.family.autoDispose((
  ref,
  String subcategoryId,
) async {
  final usecase = ref.watch(fetchAllAdhkarUsecaseProvider);
  return await usecase.call(subcategoryId);
});
