import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_list_page.dart';
import 'package:rafeeq/features/haramain-live/presentation/widgets/haramain_card.dart';
import 'package:rafeeq/features/home/presentation/widgets/quick_action_row.dart';
import 'package:rafeeq/features/home/providers/reminder_providers.dart';
import 'package:rafeeq/features/quran/presentation/widgets/ayah_of_the_day.dart';
import 'package:rafeeq/features/home/presentation/widgets/reminders_carousel.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/quran_reading_plan_provider.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/widgets/home_card_reading_plan.dart';
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
          // TIMESCARD + QUICK ACTIONS
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: _v10,
              ), // to accommodate quick actions overlap
              child: TodayTimesCard(height: 285),
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
