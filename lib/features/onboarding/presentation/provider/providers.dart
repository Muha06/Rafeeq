import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/onboarding/data/datasource/onboarding_local_datasource.dart';
import 'package:rafeeq/features/onboarding/data/repos/onboarding_repository_impl.dart';
import 'package:rafeeq/features/onboarding/domain/repos/onboarding_repo.dart';
import 'package:rafeeq/features/onboarding/domain/usecases/get_has_seen_onboarding.dart';
import 'package:rafeeq/features/onboarding/domain/usecases/set_has_seen_onboarding.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final box = ref.watch(settingsBoxProvider);
  final local = OnboardingLocalDataSourceImpl(box);
  return OnboardingRepositoryImpl(local);
});

final getHasSeenOnboardingProvider = Provider<GetHasSeenOnboarding>((ref) {
  return GetHasSeenOnboarding(ref.watch(onboardingRepositoryProvider));
});

final setHasSeenOnboardingProvider = Provider<SetHasSeenOnboarding>((ref) {
  return SetHasSeenOnboarding(ref.watch(onboardingRepositoryProvider));
});

/// Used at app start to decide which screen to show.
/// Hive read is sync so this is sync too.
final hasSeenOnboardingProvider = Provider<bool>((ref) {
  return ref.watch(getHasSeenOnboardingProvider).call();
});
