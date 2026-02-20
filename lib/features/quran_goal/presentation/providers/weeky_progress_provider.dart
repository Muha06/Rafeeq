import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/progress.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';

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

final weeklyProgressProvider = Provider<Progress>((ref) {
  final range = ref.watch(weeklyRangeProvider);
  final progress = ref.watch(progressProvider(range));

  final dailyTarget = progress.dailyTarget;

  return Progress(totalRead: progress.totalRead, dailyTarget: dailyTarget * 7);
});
