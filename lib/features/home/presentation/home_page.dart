import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/haramain-live/presentation/widgets/haramain_card.dart';
import 'package:rafeeq/features/home/presentation/widgets/user_location_chip.dart';
import 'package:rafeeq/features/home_reminders/presentation/providers/reminder_providers.dart';
import 'package:rafeeq/features/notifications/presentation/pages/notification_list_page.dart';
import 'package:rafeeq/features/notifications/presentation/providers/notification_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/ayah_of_the_day.dart';
import 'package:rafeeq/features/home_reminders/presentation/widgets/reminders_carousel.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/settings_notifcation_provider.dart';
import 'package:rafeeq/features/timings/presentation/riverpod/salah_notifs_scheduler_provider.dart';
import 'package:rafeeq/features/timings/presentation/widgets/timeline_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const double _hPad = 12.0;
  static const double _v10 = 10.0;
  static const double _appBarIconSize = 26.0;

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(homeRemindersProvider(context));

    //ACTIVATE
    ref.watch(salahNotifSchedulerProvider); // scheduler salah notifs
    ref.watch(adhkarNotificationsControllerProvider); // scheduler adhkar notifs

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            leading: const UserLocationChip(),
            leadingWidth: 120,
            toolbarHeight: kToolbarHeight + 16,
            actions: [
              const _NotificationIcon(iconSize: _appBarIconSize),
              const _SettingsIcon(iconSize: _appBarIconSize),
            ],
            bottom: reminders.isNotEmpty
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(60),
                    child: HomeRemindersCarousel(),
                  )
                : null,
          ),

          // TIMESCARD
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: _hPad,
                right: _hPad,
                bottom: _v10,
              ), // to accommodate quick actions overlap
              child: HomeTimelineCard(),
            ),
          ),

          // AYAH OF THE DAY
          const SliverToBoxAdapter(
            child: HomeSection(
              padding: EdgeInsets.symmetric(horizontal: _hPad, vertical: _v10),
              child: AyahOfTheDay(),
            ),
          ),

          // HARAMAIN CARD
          const SliverToBoxAdapter(
            child: HomeSection(
              padding: EdgeInsets.symmetric(horizontal: _hPad, vertical: _v10),
              child: LiveHubCard(),
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
  const _SettingsIcon({super.key, required this.iconSize});
  final double iconSize;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        pushLeftPage(context, const SettingsPage());
      },
      icon: Icon(CupertinoIcons.gear, size: iconSize),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({super.key, required this.iconSize});
  final double iconSize;
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
              icon: PhosphorIcon(CupertinoIcons.bell, size: iconSize),
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
