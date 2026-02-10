import 'package:rafeeq/features/onborading/domain/repos/onboarding_repo.dart';

 
class GetHasSeenOnboarding {
  GetHasSeenOnboarding(this._repo);
  final OnboardingRepository _repo;

  bool call() => _repo.hasSeenOnboarding();
}
