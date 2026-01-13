import 'package:flutter/material.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/HOME_PAGE/all_surah_listview.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/HOME_PAGE/quick_last_read.dart';
import 'package:rafeeq/features/Quran/presentation/widgets/HOME_PAGE/quick_surah_links.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  final ScrollController scrollController = ScrollController();

  void scrollToTop() {
    scrollController.animateTo(
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

              bottom: appBarBottomDivider(context),
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
