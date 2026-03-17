import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'dart:math';

final ayahOfTheDayProvider = FutureProvider<Ayah?>((ref) async {
  // Wait for surahs properly (no empty fallback)
  final surahs = ref.watch(surahsProvider);
  if (surahs.isEmpty) return null;

  final now = DateTime.now();
  final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;

  // Seed based on date (stable for the whole day)
  final baseSeed = (now.year * 1000) + dayOfYear;

  // Pick surah using seeded random (better distribution than day%len)
  final rngSurah = Random(baseSeed);
  final surah = surahs[rngSurah.nextInt(surahs.length)];

  // Fetch ayahs
  final ayahs = await ref.watch(ayahsFutureProvider(surah.id).future);
  if (ayahs.isEmpty) return null;

  // Different seed for ayah (so it doesn’t mirror surah selection)
  final rngAyah = Random(baseSeed ^ surah.id); // XOR mixes it nicely
  final ayah = ayahs[rngAyah.nextInt(ayahs.length)];

  return ayah;
});

//get surah for the ayah
final ayahSurahProvider = Provider.family<Surah?, int>((ref, surahId) {
  final surahs = ref.watch(surahsProvider);

  return surahs.firstWhereOrNull((s) => s.id == surahId);
});
