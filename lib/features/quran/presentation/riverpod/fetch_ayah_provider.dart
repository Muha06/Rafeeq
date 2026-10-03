import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/wiring_providers.dart';

// 2️⃣ FutureProvider.family for fetching ayahs per surah
final ayahsProvider = FutureProvider.family<List<Ayah>, int>((
  ref,
  surahId,
) async {
  final repository = ref.watch(quranRepoProvider);

  return repository.getAyahs(surahId); // lazy-load next pages later
});
