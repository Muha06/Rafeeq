import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_reading_plan/domain/entities/progress.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/progress_provider.dart';
 import 'package:rafeeq/features/quran_reading_plan/presentation/providers/quran_log_provider.dart';

final weeklyRangeProvider = Provider<DateTimeRange>((ref) {
  final now = DateTime.now();

  // Make Monday start of week
  final weekday = now.weekday; // 1 = Monday
  final start = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: weekday - 1));

  final end = start.add(const Duration(days: 7));

  return DateTimeRange(start: start, end: end);
});

//weekly progress
final weeklyProgressProvider = Provider<Progress>((ref) {
  final range = ref.watch(weeklyRangeProvider);
  final progress = ref.watch(progressProvider(range));

  final dailyTarget = progress.dailyTarget;

  return Progress(totalRead: progress.totalRead, dailyTarget: dailyTarget * 7);
});


//====================Bar Chart=============================
final weeklyProgressByDayProvider = Provider<List<int>>((ref) {
  final logs = ref.watch(quranLogProvider);
  final range = ref.watch(weeklyRangeProvider);

  // 7 days Sun -> Sat
  return List.generate(7, (i) {
    final day = range.start.add(Duration(days: i));
    final total = logs
        .where(
          (log) =>
              log.date.year == day.year &&
              log.date.month == day.month &&
              log.date.day == day.day,
        )
        .fold(0, (sum, log) => sum + log.ayahsRead);
    return total;
  });
});
