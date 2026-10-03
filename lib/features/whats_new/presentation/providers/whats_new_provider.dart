import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';
import 'package:rafeeq/features/whats_new/data/whats_new_items.dart';

const lastWhatsNewVersionKey = 'last_whats_new_version';

final whatsNewProvider = NotifierProvider<WhatsNewNotifier, bool>(
  WhatsNewNotifier.new,
);

class WhatsNewNotifier extends Notifier<bool> {
  Box get _box => ref.read(settingsBoxProvider);

  @override
  bool build() {
    return _box.get(lastWhatsNewVersionKey) != currentWhatsNewVersion;
  }

  Future<void> markAsSeen() async {
    await _box.put(lastWhatsNewVersionKey, currentWhatsNewVersion);

    state = false;
  }
}
