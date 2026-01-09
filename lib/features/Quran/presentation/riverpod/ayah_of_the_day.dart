import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_surahs_provider.dart';

final ayahOfTheDayProvider = FutureProvider<Ayah?>((ref) async {
  // 1️⃣ Pick a surah for today (you could pick randomly or based on day)
  final surahs = ref
      .watch(surahsFutureProvider)
      .maybeWhen(data: (list) => list, orElse: () => []);

  if (surahs.isEmpty) return null;

  // Example: pick surah based on day of month
  final surahIndex = DateTime.now().day % surahs.length;
  final surah = surahs[surahIndex];

  // 2️⃣ Fetch ayahs for that surah using your existing provider
  final ayahs = await ref.watch(ayahsFutureProvider(surah.id).future);

  if (ayahs.isEmpty) return null;

  // 3️⃣ Pick ayah based on day of month again
  final ayahIndex = DateTime.now().day % ayahs.length;
  return ayahs[ayahIndex];
});

//get surah for the ayah

final ayahSurahProvider = Provider.family<Surah?, int>((ref, surahId) {
  final surahs = ref
      .watch(surahsFutureProvider)
      .maybeWhen(data: (list) => list, orElse: () => []);

  return surahs.firstWhereOrNull((s) => s.id == surahId);
});
