import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/home/presentation/widgets/ayah_of_the_day.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/QURAN_PAGE/greetings_row.dart';
import 'package:rafeeq/features/home/presentation/widgets/home_reminder_carouel.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';
import 'package:rafeeq/salat-times/domain/entities/salah_prayer.dart';
import 'package:rafeeq/salat-times/presentation/riverpod/salah_times_providers.dart';
import 'package:rafeeq/salat-times/presentation/widgets/salah_status_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final todayHijri = HijriDate.now();
  String get formattedHijri => todayHijri.toFormat('MMMM dd, yyyy h');

  final Map<SalahPrayer, String> assetByPrayer = {
    SalahPrayer.fajr: 'assets/salat/fajr.jpeg',
    SalahPrayer.dhuhr: 'assets/salat/dhuhr.jpeg',
    SalahPrayer.asr: 'assets/salat/asr.jpeg',
    SalahPrayer.maghrib: 'assets/salat/maghrib.jpeg',
    SalahPrayer.isha: 'assets/salat/isha.jpeg',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ref.watch(salahNotificationsSchedulerProvider); //activate
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: false,
              toolbarHeight: theme.appBarTheme.toolbarHeight!,
              title: Text('Rafeeq', style: theme.appBarTheme.titleTextStyle),
              actions: [
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
                  top: 20,
                  bottom: 8,
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
                child: SalahTimesCard(assetsByPrayer: assetByPrayer),
              ),
            ),

            const SliverToBoxAdapter(child: HomeRemindersCarousel()),

            //AYAH OF THE DAY
            const SliverToBoxAdapter(child: AyahOfTheDay()),
          ],
        ),
      ),
    );
  }
}
