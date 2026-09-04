import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/location/presentation/provider/location_prov.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/helpers/app_dialogs.dart';
import 'package:rafeeq/features/home/presentation/pages/tabs_screen.dart';
import 'package:rafeeq/features/onboarding/presentation/provider/onboarding_provider.dart';
import 'package:rafeeq/features/onboarding/presentation/provider/providers.dart';
import 'package:rafeeq/features/onboarding/presentation/widgets/collect_name.dart';
import 'package:rafeeq/features/onboarding/presentation/widgets/dots_indicator.dart';
import 'package:rafeeq/features/onboarding/presentation/widgets/slides.dart';
import 'package:rafeeq/user/presentation/providers/user_provider.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageController;
  final _userNameController = TextEditingController();

  static const _pageCount = 3;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _userNameController.addListener(_onNameChanged);
  }

  void _onNameChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _userNameController.removeListener(_onNameChanged);

    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goTo(int index) async {
    if (index == 1) {
      FocusScope.of(context).unfocus();
      await Future.delayed(200.ms);

      // confirm name
      final ok = await AppDialogs.showConfirmDialog(
        context: context,
        title: 'Confirm your name',
        message:
            'We’ll use "${_userNameController.text}" to personalize your experience.',
        confirmText: 'Continue',
      );

      if (ok == null || ok == false) {
        return;
      }
    }

    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  Future<void> _finishOnboarding() async {
    // Save name to cache
    final name = _userNameController.text;
    ref.read(userNameProvider.notifier).saveName(name);

    //  Save user location
    await _saveUserLocation();

    if (!context.mounted) return;

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const TabsScreen()));

    await ref.read(setHasSeenOnboardingProvider).call();
  }

  Future<void> _saveUserLocation() async {
    debugPrint('Saving user location after onboarding');
    final locationPerm = ref.watch(locationPermissionProvider);

    final isAllowed = locationPerm.isGranted;
    debugPrint("Location permission allowed: $isAllowed");
    if (!isAllowed) return;

    await ref.read(userLocationProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(onboardingIndexProvider);

    final name = _userNameController.text.trim();
    final canContinue = (name.isNotEmpty);

    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //  pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => {
                  FocusScope.of(context).unfocus(),

                  ref.read(onboardingIndexProvider.notifier).setIndex(i),
                },
                children: [
                  CollectUserNameSlide(controller: _userNameController),
                  const WelcomeSlide(),
                  const SalahSlide(),
                  const QuranAdhkarSlide(),
                ],
              ),
            ),

            // ✅ bottom controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  OnboardingDots(count: _pageCount, index: index),
                  const Spacer(),

                  // Skip (hide on last page)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: canContinue ? cs.primary : cs.primaryContainer,
                    ),
                    child: IconButton(
                      onPressed: canContinue
                          ? () async {
                              if (index < _pageCount - 1) {
                                await _goTo(index + 1);
                              } else {
                                _finishOnboarding();
                              }
                            }
                          : null,
                      icon: PhosphorIcon(
                        index == (_pageCount - 1)
                            ? PhosphorIcons.check
                            : PhosphorIcons.caretRight,
                        color: cs.onPrimary,
                      ),
                    ),
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
