import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/onboarding/presentation/widgets/enable_loc_cta.dart';
import 'package:rafeeq/features/onboarding/presentation/widgets/enable_notifs_cta.dart';
import 'onboarding_slide.dart';

class WelcomeSlide extends ConsumerWidget {
  const WelcomeSlide({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return OnboardingSlide(
      imageAsset: 'assets/images/onboarding/welcome.png',
      title: 'Rafeeq',
      subtitle: 'A calm companion for your worship.',
      accent: Theme.of(context).colorScheme.primary,
    );
  }
}

class SalahSlide extends StatelessWidget {
  const SalahSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingSlide(
      imageAsset: 'assets/images/onboarding/salat_feature.png',
      title: 'Stay on time for every ṣalāh',
      subtitle:
          'Enable Location & Notification to calculate and send accurate prayer reminders for where you are.',
      accent: Theme.of(context).colorScheme.primary,
      child: const Column(
        children: [
          LocationPermissionCta(),
          SizedBox(height: 8),
          NotificationsPermissionCta(),
        ],
      ),
    );
  }
}

class QuranAdhkarSlide extends StatelessWidget {
  const QuranAdhkarSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingSlide(
      imageAsset: 'assets/images/onboarding/quran_feature.png',
      title: 'Stay connected daily',
      subtitle: 'Qur’an, adhkār, and reflections — at your own pace.',
      accent: Theme.of(context).colorScheme.primary,
    );
  }
}
