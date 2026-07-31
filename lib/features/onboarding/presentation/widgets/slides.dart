import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/onboarding/presentation/widgets/enable_loc_cta.dart';
import 'package:rafeeq/features/onboarding/presentation/widgets/enable_notifs_cta.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/fetch_salah_times_provider.dart';
import 'onboarding_slide.dart';

class WelcomeSlide extends ConsumerWidget {
  const WelcomeSlide({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return OnboardingSlide(
      imageAsset: 'assets/images/onboarding/welcome.png',
      title: 'Your Daily Worship Companion',
      subtitle: 'Everything you need for your daily worship.',
      accent: Theme.of(context).colorScheme.primary,
    );
  }
}

class SalahSlide extends StatelessWidget {
  const SalahSlide({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final btnStyle = theme.elevatedButtonTheme.style?.copyWith(
      backgroundColor: WidgetStatePropertyAll(cs.tertiary),
      foregroundColor: WidgetStatePropertyAll(cs.onTertiary),
      iconColor: WidgetStatePropertyAll(cs.onTertiary),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );

    return OnboardingSlide(
      imageAsset: 'assets/images/onboarding/salat_feature.png',
      title: 'Stay on time for every ṣalāh',
      subtitle:
          'Enable Location & Notification to calculate and send accurate prayer reminders for where you are.',
      accent: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
            child: LocationPermissionCta(btnStyle: btnStyle),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: NotificationsPermissionCta(btnStyle: btnStyle),
          ),
        ],
      ),
    );
  }
}

class QuranAdhkarSlide extends ConsumerWidget {
  const QuranAdhkarSlide({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.watch(fetchTodaySalahTimesProvider);
    
    return OnboardingSlide(
      imageAsset: 'assets/images/onboarding/quran_feature.png',
      title: 'Stay connected daily',
      subtitle: 'Qur’an, adhkār, and reflections — at your own pace.',
      accent: Theme.of(context).colorScheme.primary,
    );
  }
}
