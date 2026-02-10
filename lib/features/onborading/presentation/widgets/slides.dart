import 'package:flutter/material.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/features/onborading/presentation/widgets/enable_loc_cta.dart';
import 'package:rafeeq/features/onborading/presentation/widgets/enable_notifs_cta.dart';
import '../widgets/onboarding_slide.dart';

class WelcomeSlide extends StatelessWidget {
  const WelcomeSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingSlide(
      imageAsset: 'assets/images/onboarding/welcome.png',
      title: 'Rafeeq',
      subtitle: 'A calm companion for your worship.',
      accent: AppDarkColors.amber,
    );
  }
}

class SalahSlide extends StatelessWidget {
  const SalahSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingSlide(
      imageAsset: 'assets/images/onboarding/salat_feature.png',
      title: 'Stay on time for every ṣalāh',
      subtitle:
          'Enable location to calculate accurate prayer times for where you are.',
      accent: AppDarkColors.amber,
      child: LocationPermissionCta(),
    );
  }
}

class QuranAdhkarSlide extends StatelessWidget {
  const QuranAdhkarSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingSlide(
      imageAsset: 'assets/images/onboarding/quran_feature.png',
      title: 'Stay connected daily',
      subtitle: 'Qur’an, adhkār, and reflections — at your own pace.',
      accent: AppDarkColors.amber,
    );
  }
}

class RamadanSlide extends StatelessWidget {
  const RamadanSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnboardingSlide(
      imageAsset: 'assets/images/onboarding/ramadan_feature.png',
      title: 'Ramadan, made intentional',
      subtitle: 'Suḥūr • Iftār • Daily reminders that matter.',
      accent: AppDarkColors.amber,
      child: NotificationsPermissionCta(),
    );
  }
}
