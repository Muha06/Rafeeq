import 'package:hive_flutter/hive_flutter.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';

abstract class OnboardingLocalDataSource {
  bool hasSeenOnboarding();
  Future<void> setSeenOnboarding();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl(this._box);

  final Box _box;

  static const _key = 'seen_onboarding';

  @override
  bool hasSeenOnboarding() {
    final seen = _box.get(_key, defaultValue: false) as bool;
    return seen;
  }

  @override
  Future<void> setSeenOnboarding() async {
    await _box.put(_key, true);
    RafeeqAnalytics.logFirstOpen();
  }
}
