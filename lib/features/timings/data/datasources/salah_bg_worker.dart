import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

const salahMaintenanceTask = 'salahScheduleMaintenance';
const salahMaintenanceWorkName = 'salahDailyMaintenance';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    switch (task) {
      case salahMaintenanceTask:
        // TODO: Initialize Hive and maintain Salah notifications.
        return true;

      default:
        return true;
    }
  });
}

class SalahBackgroundWorker {
  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  Future<void> scheduleDailyMaintenance({
    required Duration initialDelay,
  }) async {
    await Workmanager().registerOneOffTask(
      salahMaintenanceWorkName,
      salahMaintenanceTask,
      initialDelay: initialDelay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }
}
