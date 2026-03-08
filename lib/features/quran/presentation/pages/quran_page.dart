import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/rafeeq_analytics.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/quran/presentation/pages/all_mushaf_pages.dart';
import 'package:rafeeq/features/quran/presentation/pages/search_surah_page.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/all_surah_listview.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/quick_last_read.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/quick_surah_links.dart';
import 'package:rafeeq/features/quran_goal/presentation/pages/quran_goal_stats.dart';

class QuranPage extends ConsumerStatefulWidget {
  const QuranPage({super.key});

  @override
  ConsumerState<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends ConsumerState<QuranPage> {
  final ScrollController scrollController = ScrollController();

  Future<void> scrollToTop() async {
    await scrollController.animateTo(
      0,
      duration: Durations.short4,
      curve: Curves.easeIn,
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
                child: const Text('Quran'),
              ),
              actions: [
                IconButton(
                  icon: const Icon(CupertinoIcons.search),

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SurahSearchPage(),
                      ),
                    );
                  },
                ),
              ],
              bottom: appBarBottomDivider(context),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // --- Quran Goal Stats Portal ---
            const SliverToBoxAdapter(child: ViewQuranGoalStats()),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            //quick last read
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: QuickLastReadList(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            // QUICKSURAHLINK
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
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

class ViewQuranGoalStats extends StatelessWidget {
  const ViewQuranGoalStats({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          // navigate to goal stats page
          // AppNav.push(context, const QuranGoalStatsPage()).then(
          //   (value) => RafeeqAnalytics.logScreenView(
          //     'Quran_progress_stats_page',
          //   ),
          // );
          AppNav.push(context, MushafEntryPage());
        },
        child: Container(
          height: 64,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.chart_bar,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'View your Quran Goal stats',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.chevron_forward,
                color: theme.colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
