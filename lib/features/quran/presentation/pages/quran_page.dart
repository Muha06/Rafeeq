import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:rafeeq/core/helpers/extensions/page_animate_ext.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/search_surah_field.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/surah_listview.dart';
import 'package:rafeeq/features/quran/presentation/widgets/QURAN_PAGE/quick_last_read.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/quran_goal_card.dart';

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
    const horizontalPadding = AppSpacing.screenHorizontal;

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
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // --- Quran Goal Stats Portal ---
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: QuranReadingPlanCard(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          //quick last read
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: QuickLastReadList(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          //  Add Search field
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: SearchSurahField(),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          //Surah listview
          const AllSurahsList(),
        ],
      ),
    ).animatePage();
  }
}
