import 'package:rafeeq/features/onborading/data/datasource/onboarding_local_datasource.dart';
import 'package:rafeeq/features/onborading/domain/repos/onboarding_repo.dart';
 
class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._local);
  final OnboardingLocalDataSource _local;

  @override
  bool hasSeenOnboarding() => _local.hasSeenOnboarding();

  @override
  Future<void> setSeenOnboarding() => _local.setSeenOnboarding();
}
