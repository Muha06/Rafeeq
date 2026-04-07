import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_reading_plan/domain/entities/progress.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/quran_reading_plan_provider.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/quran_log_provider.dart';

//Universal provider that returns logs for given datetime range
final progressProvider = Provider.family<Progress, DateTimeRange>((ref, range) {
  final logs = ref.watch(quranLogProvider); // all logs
  final readingPlan = ref.watch(quranReadingPlanProvider); // user daily target

  final totalRead = logs
      .where((log) {
        final logDate = log.date;
        return !logDate.isBefore(range.start) && logDate.isBefore(range.end);
      })
      .fold(0, (sum, log) => sum + log.ayahsRead);

  return Progress(totalRead: totalRead, dailyTarget: readingPlan.dailyTarget);
});
