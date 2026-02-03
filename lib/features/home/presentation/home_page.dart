import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/location/presentation/pages/user_loc_settings.dart';
import 'package:rafeeq/core/location/presentation/provider/user_location_provider.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/QURAN_PAGE/greetings_row.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/pages/asma_ul_husna_list_page.dart';
import 'package:rafeeq/features/haramain-live/presentation/widgets/haramain_card.dart';
import 'package:rafeeq/features/home/presentation/widgets/ayah_of_the_day.dart';
import 'package:rafeeq/features/home/presentation/widgets/reminders_carousel.dart';
import 'package:rafeeq/features/home/presentation/widgets/quick_action_row.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/features/salat-times/domain/entities/salah_prayer.dart';
import 'package:rafeeq/features/salat-times/presentation/widgets/timeline_card.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final todayHijri = HijriDate.now();
  String get formattedHijri => todayHijri.toFormat('MMMM dd, yyyy h');

  final Map<SalahPrayer, String> assetByPrayer = {
    SalahPrayer.fajr: 'assets/images/salat/fajr.jpeg',
    SalahPrayer.sunrise: 'assets/images/salat/fajr.jpeg',
    SalahPrayer.dhuha: 'assets/images/salat/daytime_3.jpeg',
    SalahPrayer.dhuhr: 'assets/images/salat/dhuhr.jpeg',
    SalahPrayer.asr: 'assets/images/salat/dhuhr.jpeg',
    SalahPrayer.maghrib: 'assets/images/salat/maghrib.jpeg',
    SalahPrayer.isha: 'assets/images/salat/isha_2.jpeg',
    SalahPrayer.midnight: 'assets/images/salat/isha_2.jpeg',
    SalahPrayer.tahajjud: 'assets/images/salat/isha.jpeg',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userLocationAsync = ref.watch(userLocationProvider);
    final isDark = ref.watch(isDarkProvider);

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
              title: Text('Rafeeq', style: theme.appBarTheme.titleTextStyle),
              actions: [
                userLocationAsync.when(
                  error: (error, stackTrace) => GestureDetector(
                    onTap: () => ref.invalidate(userLocationProvider),
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
                        : AppLightColors.amberSoft,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  ),
                  data: (userLocation) => GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserLocSettingsPage(),
                      ),
                    ),
                    child: Chip(
                      label: Text(
                        userLocation?.city ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w300,
                          height: 1.25,
                          fontSize: 14,
                        ),
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
                ),

                IconButton(
                  onPressed: () {
                    pushLeftPage(context, const SettingsPage());
                  },
                  icon: const Icon(CupertinoIcons.settings),
                ),
              ],
              bottom: appBarBottomDivider(context),
            ),

            //GREETINGS
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12,
                  top: 16,
                  bottom: 0,
                ),
                child: GreetingsRow(formattedHijri: formattedHijri),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: TodayTimesCard(assetsByPrayer: assetByPrayer),
              ),
            ),

            //REMINDERs
            const SliverToBoxAdapter(child: HomeRemindersCarousel()),

            //quick actions row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsGeometry.only(
                  left: 12,
                  right: 12,
                  bottom: 24,
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

            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: HaramainCard(),
              ),
            ),
            //AYAH OF THE DAY
            const SliverToBoxAdapter(child: AyahOfTheDay()),
          ],
        ),
      ),
    );
  }
}
