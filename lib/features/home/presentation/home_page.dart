import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/features/location/presentation/pages/user_loc_settings.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/features/Ramadan/presentation/widgets/ramadan_card.dart';
import 'package:rafeeq/features/home/presentation/widgets/hijri_date.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_list_page.dart';
import 'package:rafeeq/features/haramain-live/presentation/widgets/haramain_card.dart';
import 'package:rafeeq/features/home/providers/reminder_providers.dart';
import 'package:rafeeq/features/quran/presentation/widgets/ayah_of_the_day.dart';
import 'package:rafeeq/features/home/presentation/widgets/reminders_carousel.dart';
import 'package:rafeeq/features/home/presentation/widgets/quick_action_row.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/quran_qoal_home_card.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/presentation/widgets/timeline_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  static const double _hPad = 12.0;
  static const double _v10 = 10.0;

  final Map<SalahPrayer, String> assetByPrayer = {
    SalahPrayer.fajr: 'assets/images/salat/fajr.jpeg',
    SalahPrayer.sunrise: 'assets/images/salat/fajr.jpeg',
    SalahPrayer.dhuha: 'assets/images/salat/dhuhr.jpeg',
    SalahPrayer.dhuhr: 'assets/images/salat/dhuhr.jpeg',
    SalahPrayer.asr: 'assets/images/salat/asr.jpeg',
    SalahPrayer.maghrib: 'assets/images/salat/maghrib.jpeg',
    SalahPrayer.isha: 'assets/images/salat/night.jpeg',
    SalahPrayer.midnight: 'assets/images/salat/night.jpeg',
    SalahPrayer.tahajjud: 'assets/images/salat/isha.jpeg',
  };

  @override
  Widget build(BuildContext context) {
    final goal = ref.watch(quranGoalProvider);
    final reminders = ref.watch(homeRemindersProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          // SliverAppBar(
          //   pinned: false,
          //   floating: false,
          //   snap: false,
          //   toolbarHeight: theme.appBarTheme.toolbarHeight!,
          //   title: Text('Home', style: theme.appBarTheme.titleTextStyle),
          //   actions: [
          //     const UserLocationChip(),
          //     IconButton(
          //       onPressed: () async {
          //         pushLeftPage(context, const SettingsPage());
          //       },
          //       icon: const Icon(CupertinoIcons.settings),
          //     ),
          //   ],
          //   bottom: buildlHijriDate(context, ref),
          // ),

          // TIMESCARD + QUICK ACTIONS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 48,
              ), // to accommodate quick actions overlap
              child: TodayTimesCard(assetsByPrayer: assetByPrayer, height: 340),
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
                child: QuranGoalCard(),
              ),
            ),

          // HARAMAIN CARD
          const SliverToBoxAdapter(
            child: HomeSection(
              padding: EdgeInsets.symmetric(horizontal: _hPad, vertical: _v10),
              child: HaramainCard(),
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

class UserLocationChip extends ConsumerWidget {
  const UserLocationChip({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userLocationAsync = ref.watch(userLocationProvider);

    return userLocationAsync.when(
      error: (error, stackTrace) => GestureDetector(
        onTap: () {
          ref.invalidate(userLocationProvider);
        },
        child: const Chip(
          label: Row(
            children: [
              Icon(Icons.error_outline, size: 18),
              SizedBox(width: 4),
              Text('retry'),
            ],
          ),
        ),
      ),
      loading: () => const Chip(label: CupertinoActivityIndicator()),
      data: (userLocation) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserLocSettingsPage(),
            ),
          );
        },
        child: Chip(
          label: Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16),
              const SizedBox(width: 2),

              Text(
                userLocation?.city ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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
