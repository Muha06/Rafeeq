import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class OnboardingLocalDataSource {
  bool hasSeenOnboarding();
  Future<void> setSeenOnboarding();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl(this._box);

  final Box _box;

  static const _key = 'seen_onboarding';

  @override
  bool hasSeenOnboarding() => _box.get(_key, defaultValue: false) as bool;

  @override
  Future<void> setSeenOnboarding() async {
    debugPrint('setting as seen');
    await _box.put(_key, true);
  }
}
