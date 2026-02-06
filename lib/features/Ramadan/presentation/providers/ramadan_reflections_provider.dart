import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/features/Ramadan/data/datasources/local_ramadan_refections.dart';
import '../../domain/ramadan_reflection.dart';

final ramadanReflectionsProvider = Provider<List<RamadanReflection>>((ref) {
  return kRamadanReflections;
});

final ramadanReflectionByDayProvider =
    Provider.family<RamadanReflection?, HijriDate>((ref, hijri) {
      final month = hijri.hMonth;
      if (month != 9) return null; //not ramadan

      final day = hijri.hDay;

      final list = ref.watch(ramadanReflectionsProvider);

      final match = list.firstWhere((r) => day == r.day);

      return match;
    });
