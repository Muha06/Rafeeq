import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';

const userProfileBoxName = 'user_profile_box';
const userNameKey = 'user_name';

final userNameProvider = NotifierProvider<UserNameNotifier, String?>(
  UserNameNotifier.new,
);

class UserNameNotifier extends Notifier<String?> {
  @override
  String? build() {
    final box = ref.watch(settingsBoxProvider);

    return box.get(userNameKey) as String?;
  }

  Future<void> saveName(String? name) async {
    if (name == null || name.isEmpty) return;

    final trimmedName = name.trim();

    final box = ref.read(settingsBoxProvider);

    await box.put(userNameKey, trimmedName);

    state = trimmedName;
  }
}
