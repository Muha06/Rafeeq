import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/core/animations/navigation_animations.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/HOME_PAGE/all_surah_listview.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/HOME_PAGE/ayah_of_the_day.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/HOME_PAGE/friday_reminder.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/HOME_PAGE/greetings_row.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/HOME_PAGE/quick_last_read.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/HOME_PAGE/quick_surah_links.dart';
import 'package:rafeeq/features/settings/presentation/pages/settings_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final todayHijri = HijriDate.now();
  String get formattedHijri => todayHijri.toFormat('MMMM dd, yyyy h');
  final ScrollController scrollController = ScrollController();

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: Durations.short4,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              snap: false,
              toolbarHeight: theme.appBarTheme.toolbarHeight!,
              title: GestureDetector(
                onTap: scrollToTop,
                child: const Text('Rafeeq'),
              ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 14,
                ),
                child: GreetingsRow(formattedHijri: formattedHijri),
              ),
            ),

            //AYAH OF THE DAY
            const SliverToBoxAdapter(child: AyahOfTheDay()),

            //friday reminder
            const SliverToBoxAdapter(child: FridayReminder()),

            //quick last read
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: QuickLastReadList(),
              ),
            ),

            // QUICKSURAHLINK
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: QuickSurahLinks(),
              ),
            ),

            //Surah listview
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              sliver: AllSurahsList(),
            ),
          ],
        ),
      ),
    );
  }
}
