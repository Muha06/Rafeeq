import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/progress.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';

final todayRangeProvider = Provider<DateTimeRange>((ref) {
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, now.day);
  final end = start.add(const Duration(days: 1));
  return DateTimeRange(start: start, end: end);
});

final todayProgressProvider = Provider<Progress>((ref) {
  final range = ref.watch(todayRangeProvider);
  return ref.watch(progressProvider(range));
});
