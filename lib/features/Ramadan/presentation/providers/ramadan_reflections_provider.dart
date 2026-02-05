import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/Ramadan/data/datasources/local_ramadan_refections.dart';
import '../../domain/ramadan_reflection.dart';

/// Expose the full list (handy for debugging / future list screen)
final ramadanReflectionsProvider = Provider<List<RamadanReflection>>((ref) {
  return kRamadanReflections;
});

/// V1 day calculation (no Hijri dependency):
/// cycles 1..30 based on calendar day.
/// Replace later with real Ramadan day logic.
final ramadanTodayDayProvider = Provider<int>((ref) {
  final today = DateTime.now().day; // 1..31
  return ((today - 1) % 30) + 1; // 1..30
});

/// Get reflection for a given Ramadan day (1..30)
final ramadanReflectionByDayProvider = Provider.family<RamadanReflection?, int>(
  (ref, day) {
    final list = ref.watch(ramadanReflectionsProvider);
    if (list.isEmpty) return null;

    // exact day match
    final match = list.where((r) => r.day == day).toList();
    if (match.isNotEmpty) return match.first;

    // fallback: deterministic pick so UI never breaks
    final index = (day - 1) % list.length;
    return list[index];
  },
);

/// Today’s reflection (what your card will use)
final ramadanTodayReflectionProvider = Provider<RamadanReflection?>((ref) {
  final day = ref.watch(ramadanTodayDayProvider);
  return ref.watch(ramadanReflectionByDayProvider(day));
});
