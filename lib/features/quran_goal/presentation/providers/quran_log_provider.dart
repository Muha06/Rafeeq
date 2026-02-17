import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/quran_goal/data/models/quran_log_hive.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_log.dart';

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
  }

  void resetLogs() {
    box.clear(); // deletes all logs
    state = []; // update provider state
  }
}
