import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/progress.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';

final monthlyRangeProvider = Provider<DateTimeRange>((ref) {
  final now = DateTime.now();

  final start = DateTime(now.year, now.month, 1);

  final end = (now.month == 12)
      ? DateTime(now.year + 1, 1, 1)
      : DateTime(now.year, now.month + 1, 1);

  return DateTimeRange(start: start, end: end);
});

final monthlyProgressProvider = Provider<Progress>((ref) {
  final range = ref.watch(monthlyRangeProvider);
  final progress = ref.watch(progressProvider(range));

  final dailyTarget = progress.dailyTarget;

  return Progress(totalRead: progress.totalRead, dailyTarget: dailyTarget * 30);
});
