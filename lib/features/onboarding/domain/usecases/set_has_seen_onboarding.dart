import 'package:rafeeq/features/onboarding/domain/repos/onboarding_repo.dart';

 
class SetHasSeenOnboarding {
  SetHasSeenOnboarding(this._repo);
  final OnboardingRepository _repo;

  Future<void> call() => _repo.setSeenOnboarding();
}
