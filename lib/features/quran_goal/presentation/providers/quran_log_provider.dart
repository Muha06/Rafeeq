import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/quran_goal/data/models/hive/quran_log_hive.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_log.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/total_progress_provider.dart';

final quranLogProvider = NotifierProvider<QuranLogsNotifier, List<QuranLog>>(
  QuranLogsNotifier.new,
);

class QuranLogsNotifier extends Notifier<List<QuranLog>> {
  late Box<QuranHiveLog> box;

  @override
  List<QuranLog> build() {
    box = Hive.box<QuranHiveLog>('quran_logs');

    return box.values.map(mapHiveLog).toList();
  }

  void addLog(int ayahsRead) {
    final domainLog = QuranLog(date: DateTime.now(), ayahsRead: ayahsRead);

    final hiveLog = mapDomainLog(domainLog);
    box.add(hiveLog);

    state = [...state, domainLog];

    RafeeqAnalytics.logFeature('log-quran-goal');
  }

  void resetLogs() {
    box.clear(); // deletes all logs
    state = []; // update provider state

    RafeeqAnalytics.logFeature('reset-quran-goal-stats');
  }
}

final hasCompletedQuranGoalProvider = Provider<bool>((ref) {
  final goal = ref.watch(quranGoalProvider);
  if (goal == null) return false;

  final progress = ref.watch(totalQuranProgressProvider);

  final hasCompleted = progress.totalRead >= progress.totalTarget;

  if (hasCompleted) {
    RafeeqAnalytics.logFeature(
      'complete_quran_goal',
      parameters: {
        'goal_type': goal.type.name,
        'target': goal.dailyTarget,
        'completed_on_time': !DateTime.now().isAfter(goal.endDate),
      },
    );
  }

  return hasCompleted;
});
