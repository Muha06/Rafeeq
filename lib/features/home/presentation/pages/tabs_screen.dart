import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/features/home/presentation/pages/live_tabs.dart';
import 'package:rafeeq/features/home/presentation/widgets/bottom_bar.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_category_page.dart';
import 'package:rafeeq/features/quran/presentation/pages/quran_page.dart';
import 'package:rafeeq/features/home/presentation/pages/home_page.dart';
import 'package:rafeeq/features/bookmarks/presentation/pages/bookmark_page.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  final List<Widget> _pages = [
    const HomePage(),
    const QuranPage(),
    const AdhkarCategoryPage(),
    const LiveHubTabs(),
    const BookmarkPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(tabsScreenIndexProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        body: _pages[selectedIndex],
        bottomNavigationBar: MyBottomBar(
          currentIndex: selectedIndex,
          onTap: (value) async {
            setState(() {
              ref.read(tabsScreenIndexProvider.notifier).state = value;
            });

            if (selectedIndex == value) return;

            AppHaptics.selection();
          },
        ),
      ),
    );
  }
}
