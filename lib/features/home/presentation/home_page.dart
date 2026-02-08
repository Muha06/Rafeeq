import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/features/location/presentation/pages/user_loc_settings.dart';
import 'package:rafeeq/core/features/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/home/presentation/widgets/Hijri_date.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_list_page.dart';
import 'package:rafeeq/features/haramain-live/presentation/widgets/haramain_card.dart';
import 'package:rafeeq/features/quran/presentation/widgets/ayah_of_the_day.dart';
import 'package:rafeeq/features/home/presentation/widgets/reminders_carousel.dart';
import 'package:rafeeq/features/home/presentation/widgets/quick_action_row.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/features/timings/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/timings/presentation/widgets/timeline_card.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // Padding scale (single source of truth)
  static const double _hPad = 12.0;
  static const double _v16 = 12.0;

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
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: false,
              snap: false,
              toolbarHeight: theme.appBarTheme.toolbarHeight!,
              title: Text('Home', style: theme.appBarTheme.titleTextStyle),
              actions: [
                const UserLocationChip(),
                IconButton(
                  onPressed: () {
                    pushLeftPage(context, const SettingsPage());
                  },
                  icon: const Icon(CupertinoIcons.settings),
                ),
              ],
              bottom: buildlHijriDate(context, ref),
            ),

            // TODAY TIMES
            SliverToBoxAdapter(
              child: HomeSection(
                padding: const EdgeInsets.symmetric(
                  horizontal: _hPad,
                  vertical: _v16,
                ),
                child: TodayTimesCard(assetsByPrayer: assetByPrayer),
              ),
            ),

            // REMINDERS
            const SliverToBoxAdapter(child: HomeRemindersCarousel()),

            // QUICK LINKS ROW
            SliverToBoxAdapter(
              child: HomeSection(
                padding: const EdgeInsets.symmetric(
                  horizontal: _hPad,
                  vertical: _v16,
                ),
                child: HomeQuickActionsRow(
                  onQuran: () {
                    ref.read(tabsScreenIndexProvider.notifier).state = 1;
                  },
                  onAdhkar: () {
                    ref.read(tabsScreenIndexProvider.notifier).state = 2;
                  },
                  onAllahNames: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllahNamesPage(),
                      ),
                    );
                  },
                ),
              ),
            ),

            //Ramadan card
            // const SliverToBoxAdapter(
            //   child: HomeSection(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: _hPad,
            //       vertical: _v16,
            //     ),
            //     child: RamadanDailyCard(),
            //   ),
            // ),

            // HARAMAIN CARD
            const SliverToBoxAdapter(
              child: HomeSection(
                padding: EdgeInsets.symmetric(
                  horizontal: _hPad,
                  vertical: _v16,
                ),
                child: HaramainCard(),
              ),
            ),

            // AYAH OF THE DAY
            const SliverToBoxAdapter(
              child: HomeSection(
                padding: EdgeInsets.symmetric(
                  horizontal: _hPad,
                  vertical: _v16,
                ),
                child: AyahOfTheDay(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserLocationChip extends ConsumerWidget {
  const UserLocationChip({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final userLocationAsync = ref.watch(userLocationProvider);
    final isDark = ref.watch(isDarkProvider);

    return userLocationAsync.when(
      error: (error, stackTrace) => GestureDetector(
        onTap: () {
          ref.invalidate(userLocationProvider);
        },
        child: Chip(
          label: Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 18,
                color: isDark
                    ? AppDarkColors.iconSecondary
                    : AppLightColors.iconSecondary,
              ),
              const SizedBox(width: 4),
              Text('retry', style: theme.textTheme.labelLarge),
            ],
          ),
          backgroundColor: isDark
              ? AppDarkColors.darkSurface
              : AppLightColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),
      ),
      loading: () => Chip(
        label: const CupertinoActivityIndicator(),
        backgroundColor: isDark
            ? AppDarkColors.darkSurface
            : AppLightColors.lightSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
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
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: isDark
                    ? AppDarkColors.iconPrimary
                    : AppLightColors.iconSecondary,
              ),
              const SizedBox(width: 2),

              Text(
                userLocation?.city ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium!,
              ),
            ],
          ),
          backgroundColor: isDark
              ? AppDarkColors.darkSurface
              : AppLightColors.lightSurface,
          padding: const EdgeInsets.all(4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.transparent),
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
