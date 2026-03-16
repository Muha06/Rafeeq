//mushaf page usecase
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/mushaf_page.dart';
import 'package:rafeeq/features/quran/domain/useCases/fetch_mushaf_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_ayah_provider.dart';
 
final mushafPageUsecaseProvider = Provider<FetchMushafPageUseCase>((ref) {
  final repo = ref.watch(ayahRepositoryProvider);
  return FetchMushafPageUseCase(repository: repo);
});

final mushafPageProvider = FutureProvider.family<MushafPage, int>((ref, page) {
  final usecase = ref.watch(mushafPageUsecaseProvider);

  return usecase.call(page: page);
});

 