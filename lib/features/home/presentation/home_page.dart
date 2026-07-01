import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_list_page.dart';
import 'package:rafeeq/features/haramain-live/presentation/widgets/haramain_card.dart';
import 'package:rafeeq/features/home/presentation/widgets/quick_action_row.dart';
import 'package:rafeeq/features/home/presentation/widgets/user_location_chip.dart';
import 'package:rafeeq/features/home/providers/reminder_providers.dart';
import 'package:rafeeq/features/notifications/presentation/pages/notification_list_page.dart';
import 'package:rafeeq/features/notifications/presentation/providers/notification_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/ayah_of_the_day.dart';
import 'package:rafeeq/features/home/presentation/widgets/reminders_carousel.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/quran_reading_plan_provider.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/widgets/home_card_reading_plan.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/features/timings/presentation/widgets/timeline_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const double _hPad = 12.0;
  static const double _v10 = 10.0;

  @override
  Widget build(BuildContext context) {
    final goal = ref.watch(quranReadingPlanProvider);
    final reminders = ref.watch(homeRemindersProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverAppBar(
            leading: UserLocationChip(),
            leadingWidth: 120,
            actions: [_NotificationIcon(), _SettingsIcon()],
          ),

          // TIMESCARD + QUICK ACTIONS
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: _v10,
              ), // to accommodate quick actions overlap
              child: HomeTimelineCard(),
            ),
          ),

          //QUICK ROWS
          SliverToBoxAdapter(
            child: HomeSection(
              padding: const EdgeInsets.symmetric(
                horizontal: _hPad,
                vertical: _v10,
              ),
              child: HomeQuickActionsRow(
                onQuran: () {
                  ref.read(tabsScreenIndexProvider.notifier).state = 1;
                },
                onAdhkar: () {
                  ref.read(tabsScreenIndexProvider.notifier).state = 2;
                },
                onAllahNames: () {
                  AppNav.push(context, const AllahNamesPage());
                },
              ),
            ),
          ),

          // REMINDERS
          if (reminders.isNotEmpty)
            const SliverToBoxAdapter(
              child: HomeSection(
                padding: EdgeInsets.symmetric(vertical: _v10),
                child: HomeRemindersCarousel(),
              ),
            ),

          //QURAN GOAL CARD
          if (goal.isActive)
            const SliverToBoxAdapter(
              child: HomeSection(
                padding: EdgeInsets.symmetric(
                  horizontal: _hPad,
                  vertical: _v10,
                ),
                child: QuranReadingPlanCard(),
              ),
            ),

          // HARAMAIN CARD
          const SliverToBoxAdapter(
            child: HomeSection(
              padding: EdgeInsets.symmetric(horizontal: _hPad, vertical: _v10),
              child: LiveHubCard(),
            ),
          ),

          // AYAH OF THE DAY
          const SliverToBoxAdapter(
            child: HomeSection(
              padding: EdgeInsets.symmetric(horizontal: _hPad, vertical: _v10),
              child: AyahOfTheDay(),
            ),
          ),
        ],
      ),
    );
  }
}

//padding to sections
class HomeSection extends StatelessWidget {
  const HomeSection({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding, child: child);
  }
}

class _SettingsIcon extends StatelessWidget {
  const _SettingsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        pushLeftPage(context, const SettingsPage());
      },
      icon: Icon(PhosphorIcons.gear(PhosphorIconsStyle.bold), size: 24),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final hasUnreadNotifications = ref.watch(
          hasUnreadNotificationsProvider,
        );

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {
                AppNav.push(context, const NotificationsInboxPage());
              },
              icon: PhosphorIcon(
                PhosphorIcons.bell(PhosphorIconsStyle.bold),
                size: 24,
              ),
            ),

            if (hasUnreadNotifications)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
