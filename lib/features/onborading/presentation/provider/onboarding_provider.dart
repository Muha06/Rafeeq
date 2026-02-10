import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingIndexProvider = NotifierProvider<OnboardingIndexNotifier, int>(
  OnboardingIndexNotifier.new,
);

class OnboardingIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void setIndex(int i) => state = i;
}
