import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_ayah_provider.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/providers/asma_ul_husna_provider.dart';
import 'package:rafeeq/features/onborading/presentation/widgets/enable_loc_cta.dart';
import 'package:rafeeq/features/onborading/presentation/widgets/enable_notifs_cta.dart';
import '../widgets/onboarding_slide.dart';

class WelcomeSlide extends ConsumerWidget {
  const WelcomeSlide({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final repo = ref.read(ayahRepositoryProvider);
    Future.microtask(() {
      // Quran prefetch
      repo.prefetchAllAyahs();

      // Allah names prefetch
      ref.read(allahNamesProvider.future);
    });

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
          'Enable location to calculate accurate prayer times for where you are.',
      accent: Theme.of(context).colorScheme.primary,
      child: const LocationPermissionCta(),
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

class RamadanSlide extends StatelessWidget {
  const RamadanSlide({super.key});

  @override
  Widget build(BuildContext context) {
    return OnboardingSlide(
      imageAsset: 'assets/images/onboarding/ramadan_feature.png',
      title: 'Ramadan, made intentional',
      subtitle: 'Suḥūr • Iftār • Daily reminders that matter.',
      accent: Theme.of(context).colorScheme.primary,
      child: const NotificationsPermissionCta(),
    );
  }
}
