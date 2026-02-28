import 'package:rafeeq/features/onboarding/domain/repos/onboarding_repo.dart';

 
class GetHasSeenOnboarding {
  GetHasSeenOnboarding(this._repo);
  final OnboardingRepository _repo;

  bool call() => _repo.hasSeenOnboarding();
}
