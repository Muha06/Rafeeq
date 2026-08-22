import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/progress.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';

//Universal provider that returns goal progress
final progressProvider = Provider<Progress>((ref) {
  final logs = ref.watch(quranLogProvider); // all logs
  final quranGoal = ref.watch(quranGoalProvider); // user daily target

  final totalRead = logs.fold(0, (sum, log) => sum + log.ayahsRead);

  return Progress(totalRead: totalRead, totalTarget: quranGoal!.dailyTarget);
});
