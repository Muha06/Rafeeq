import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/extensions/page_animate_ext.dart';
import 'package:rafeeq/features/haramain-live/presentation/pages/haramain_live_page.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/progress_custom_paint.dart';
import 'package:rafeeq/features/quran_radio/presentation/pages/radios_list_page.dart';

class LiveHubTabs extends StatefulWidget {
  const LiveHubTabs({super.key});

  @override
  State<LiveHubTabs> createState() => _LiveHubTabsState();
}

class _LiveHubTabsState extends State<LiveHubTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        // top: false,
        bottom: false,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                const SliverAppBar(
                  title: Text('Live Hub'),
                  floating: true,
                  snap: true,
                  pinned: false,
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    const TabBar(
                      tabs: [
                        Tab(text: 'Radio'),
                        Tab(text: 'Haramain'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [RadioListPage(), HaramainLivePage()],
            ),
          ),
        ),
      ),
    ).animatePage();
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar; // What to make sticky

  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return false;
  }
}
