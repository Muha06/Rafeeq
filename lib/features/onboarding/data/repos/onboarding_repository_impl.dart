import 'package:rafeeq/features/onboarding/data/datasource/onboarding_local_datasource.dart';
import 'package:rafeeq/features/onboarding/domain/repos/onboarding_repo.dart';
 
class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._local);
  final OnboardingLocalDataSource _local;

  @override
  bool hasSeenOnboarding() => _local.hasSeenOnboarding();

  @override
  Future<void> setSeenOnboarding() => _local.setSeenOnboarding();
}
