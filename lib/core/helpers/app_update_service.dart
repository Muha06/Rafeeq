import 'package:flutter/widgets.dart';
import 'package:in_app_update/in_app_update.dart';

enum AppUpdateType { flexible, immediate }

class AppUpdateService {
  const AppUpdateService();

  Future<void> checkForUpdate({
    AppUpdateType type = AppUpdateType.flexible,
  }) async {
    try {
      debugPrint("Checking for Updates ✅");

      final updateInfo = await InAppUpdate.checkForUpdate();
      debugPrint("Info: $updateInfo");

      debugPrint('''
  Update availability: ${updateInfo.updateAvailability}
  Immediate allowed: ${updateInfo.immediateUpdateAllowed}
  Flexible allowed: ${updateInfo.flexibleUpdateAllowed}
  Available version: ${updateInfo.availableVersionCode}
  ''');

      if (updateInfo.updateAvailability != UpdateAvailability.updateAvailable) {
        debugPrint("No Update available");
        return;
      }

      debugPrint("Update available 🎉");

      switch (type) {
        case AppUpdateType.flexible:
          await _flexibleUpdate(updateInfo);

        case AppUpdateType.immediate:
          await _immediateUpdate(updateInfo);
      }
    } catch (e) {
      // Never let an update failure prevent Rafeeq from launching.
      debugPrint('App update check failed: $e');
    }
  }

  Future<void> _flexibleUpdate(AppUpdateInfo updateInfo) async {
    if (!updateInfo.flexibleUpdateAllowed) return;

    await InAppUpdate.startFlexibleUpdate();

    // Completes after Google Play finishes downloading the update.
    await InAppUpdate.completeFlexibleUpdate();
  }

  Future<void> _immediateUpdate(AppUpdateInfo updateInfo) async {
    if (!updateInfo.immediateUpdateAllowed) return;

    await InAppUpdate.performImmediateUpdate();
  }
}
