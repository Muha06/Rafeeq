import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/providers/asma_ul_husna_provider.dart';

final dailyAllahNameProvider = Provider.autoDispose<AsyncValue<AllahName>>((
  ref,
) {
  final namesAsync = ref.watch(allahNamesProvider);

  return namesAsync.whenData((names) {
    final dayOfYear = DateTime.now()
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;

    return names[dayOfYear % names.length];
  });
});
