import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/extensions/page_animate_ext.dart';
import 'package:rafeeq/features/haramain-live/presentation/pages/haramain_live_page.dart';
import 'package:rafeeq/features/haramain-live/presentation/provider/haramain_player_provider.dart';
import 'package:rafeeq/features/quran_radio/presentation/pages/radios_list_page.dart';

class LiveHubTabs extends ConsumerStatefulWidget {
  const LiveHubTabs({super.key});

  @override
  ConsumerState<LiveHubTabs> createState() => _LiveHubTabsState();
}

class _LiveHubTabsState extends ConsumerState<LiveHubTabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, _) {
              return [
                const SliverAppBar(
                  title: Text('Live Hub'),
                  floating: true,
                  snap: true,
                  centerTitle: true,
                  pinned: false,
                ),

                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      onTap: (index) {
                        final notifier = ref.read(
                          haramainPlayerProvider.notifier,
                        );

                        if (index == 1) {
                          notifier.hidePlayer();
                          notifier.start();
                        } else {
                          notifier.showPlayer();
                        }
                      },
                      tabs: const [
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
              children: [RadioListPage(), HaramainLivePage(startOnOpen: false)],
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
