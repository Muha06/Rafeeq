import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';

const userProfileBoxName = 'user_profile_box';
const userNameKey = 'user_name';

final userNameProvider = NotifierProvider<UserNameNotifier, String>(
  UserNameNotifier.new,
);

class UserNameNotifier extends Notifier<String> {
  Box get _box => ref.read(settingsBoxProvider);

  @override
  String build() {
    return _box.get(userNameKey) as String;
  }

  Future<void> saveName(String? name) async {
    if (name == null || name.isEmpty) return;

    final trimmedName = name.trim();

    await _box.put(userNameKey, trimmedName);

    state = trimmedName;
  }

  Future<void> updateName(String newName) async {
    saveName(newName);
  }
}
