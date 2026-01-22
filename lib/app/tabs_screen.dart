import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/widgets/bottom_bar.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_category_page.dart';
import 'package:rafeeq/features/Quran/presentation/pages/quran_page.dart';
import 'package:rafeeq/features/home/presentation/home_page.dart';
import 'package:rafeeq/features/bookmarks/presentation/pages/bookmark_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

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
    const BookmarkPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final selectedIndex = ref.watch(tabsScreenIndexProvider);

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: _pages),
      bottomNavigationBar: MyBottomBar(
        currentIndex: selectedIndex,
        onTap: (value) => setState(() {
          ref.read(tabsScreenIndexProvider.notifier).state = value;
        }),
        isDarkMode: isDark,
      ),
    );
  }
}
