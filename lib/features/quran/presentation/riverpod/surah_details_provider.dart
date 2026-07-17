import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/surah_info.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/wiring_providers.dart';

// 2️⃣ FutureProvider.family for fetching ayahs per surah
final surahInfoProvider = FutureProvider.family<SurahInfo?, int>((
  ref,
  surahId,
) async {
  final repository = ref.watch(quranRepoProvider);

  return repository.getSurahInfo(surahId); // lazy-load next pages later
});
