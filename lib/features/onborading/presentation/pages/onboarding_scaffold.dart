import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/tabs_screen.dart';
import 'package:rafeeq/core/themes/dark_theme.dart';
import 'package:rafeeq/features/onborading/presentation/provider/onboarding_provider.dart';
import 'package:rafeeq/features/onborading/presentation/provider/providers.dart';
import 'package:rafeeq/features/onborading/presentation/widgets/dots_indicator.dart';
import 'package:rafeeq/features/onborading/presentation/widgets/slides.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;

  static const _pageCount = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goTo(int index) async {
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finishOnboarding(BuildContext context) async {
    await ref.read(setHasSeenOnboardingProvider).call();
    if (!context.mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const TabsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(onboardingIndexProvider);
 
    return Scaffold(
      backgroundColor: AppDarkColors.canvas,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) =>
                    ref.read(onboardingIndexProvider.notifier).setIndex(i),
                children: const [
                  WelcomeSlide(),
                  SalahSlide(),
                  QuranAdhkarSlide(),
                  RamadanSlide(),
                ],
              ),
            ),

            // ✅ bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: Row(
                children: [
                  OnboardingDots(count: _pageCount, index: index),
                  const Spacer(),

                  // Skip (hide on last page)
                  if (index != _pageCount - 1)
                    TextButton(
                      onPressed: () {
                        _finishOnboarding(context);
                      },
                      child: const Text('Skip'),
                    ),

                  const SizedBox(width: 10),

                  ElevatedButton(
                    onPressed: () async {
                      if (index < _pageCount - 1) {
                        await _goTo(index + 1);
                      } else {
                        _finishOnboarding(context);
                      }
                    },
                    child: Text(index < _pageCount - 1 ? 'Continue' : 'Start'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
