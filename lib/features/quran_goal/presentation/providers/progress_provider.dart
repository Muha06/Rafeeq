import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/progress.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';

//Universal provider that returns logs for given datetime range
final progressProvider = Provider.family<Progress, DateTimeRange>((ref, range) {
  final logs = ref.watch(quranLogProvider); // all logs
  final goal = ref.watch(quranGoalProvider); // user daily target

  final totalRead = logs
      .where((log) {
        final logDate = log.date;
        // match if log is on same day as range start OR end
        return (logDate.year == range.start.year &&
                logDate.month == range.start.month &&
                logDate.day == range.start.day) ||
            (logDate.year == range.end.year &&
                logDate.month == range.end.month &&
                logDate.day == range.end.day) ||
            (logDate.isAfter(range.start) && logDate.isBefore(range.end));
      })
      .fold(0, (sum, log) => sum + log.ayahsRead);

  return Progress(totalRead: totalRead, dailyTarget: goal.dailyTarget);
});
