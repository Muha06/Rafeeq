import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/request_notification.dart';
import 'package:rafeeq/features/haramain-live/presentation/pages/haramain_fullscreen.dart';
import 'package:rafeeq/features/haramain-live/presentation/provider/haramain_player_provider.dart';
import 'package:rafeeq/features/haramain-live/presentation/widgets/haramain_floating_player.dart';
import 'package:rafeeq/features/home/presentation/pages/live_hub_tabs.dart';
import 'package:rafeeq/features/home/presentation/widgets/bottom_bar.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_category_page.dart';
import 'package:rafeeq/features/quran/presentation/pages/quran_page.dart';
import 'package:rafeeq/features/home/presentation/pages/home_page.dart';
import 'package:rafeeq/features/bookmarks/presentation/pages/bookmark_page.dart';
import 'package:rafeeq/features/whats_new/presentation/pages/whats_new.dart';
import 'package:rafeeq/features/whats_new/presentation/providers/whats_new_provider.dart';
import 'package:rafeeq/core/helpers/in_app_review.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  final List<Widget> _pages = [
    const HomePage(),
    const QuranPage(),
    const AdhkarCategoryPage(),
    const LiveHubTabs(),
    const BookmarkPage(),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  void _bootstrap() async {
    await Future.delayed(3.seconds);

    if (!mounted) return;

    await checkNotificationPermission(context: context, ref: ref);

    _showWhatsNew();

    const AppReviewService()
        .requestReview(); // TODO: Use after user has used app
  }

  Future<void> _showWhatsNew() async {
    if (!ref.read(whatsNewProvider) || !mounted) return;

    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      clipBehavior: Clip.hardEdge,
      builder: (_) => const WhatsNewPage(),
    ).then((_) {
      ref.read(whatsNewProvider.notifier).markAsSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(tabsScreenIndexProvider);

    ref.listen(tabsScreenIndexProvider, (previousIndex, currentIndex) {
      if (previousIndex == 3 && currentIndex != 3) {
        ref.read(haramainPlayerProvider.notifier).showPlayer();
      }
    });

    final screen = SafeArea(
      top: false,
      child: Scaffold(
        body: SafeArea(top: false, child: _pages[selectedIndex]),
        bottomNavigationBar: MyBottomBar(
          currentIndex: selectedIndex,
          onTap: (value) async {
            if (selectedIndex == value) return;

            ref.read(tabsScreenIndexProvider.notifier).state = value;
            AppHaptics.selection();
          },
        ),
      ),
    );

    return _HaramainPlayerLayer(screen: screen);
  }
}

class _HaramainPlayerLayer extends ConsumerWidget {
  const _HaramainPlayerLayer({required this.screen});

  final Widget screen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(haramainPlayerProvider);
    final controller = player.controller;
    final isMiniPlayerVisible =
        player.isVisible &&
        controller != null &&
        controller.value.isInitialized;
    final size = MediaQuery.sizeOf(context);

    return FloatingDraggableWidget(
      mainScreenWidget: screen,
      floatingWidget: isMiniPlayerVisible
          ? HaramainFloatingPlayer(
              controller: controller,
              onClose: () {
                ref.read(haramainPlayerProvider.notifier).stop();
              },
              onFullscreen: () {
                AppNav.push(
                  context,
                  HaramainFullscreenPage(controller: controller),
                );
              },
            )
          : const SizedBox.shrink(),
      floatingWidgetWidth: 220,
      floatingWidgetHeight: 124,
      dx: (size.width - 236).clamp(0.0, double.infinity).toDouble(),
      dy: (size.height - 260).clamp(0.0, double.infinity).toDouble(),
      autoAlign: true,
      disableBounceAnimation: true,
    );
  }
}
