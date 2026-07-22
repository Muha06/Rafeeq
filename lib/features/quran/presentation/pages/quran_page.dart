import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/quran/presentation/pages/search_surah_page.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/surah_listview.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/quick_last_read.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/quick_surah_links.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/quran_goal_card.dart';
import 'package:hugeicons_pro/hugeicons.dart';

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
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: false,
            floating: true,
            snap: false,
            title: GestureDetector(
              onTap: scrollToTop,
              child: const Text('Quran'),
            ),
            actions: [
              IconButton(
                icon: const Icon(HugeIconsSolid.search01),

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
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: QuranReadingPlanCard(),
            ),
          ),
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
          const SliverToBoxAdapter(child: AllSurahsList()),
        ],
      ),
    );
  }
}
