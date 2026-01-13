import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/widgets/github_style_bottom_bar.dart';
import 'package:rafeeq/features/Quran/presentation/pages/adhkar.dart';
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
    const AdhkarPage(),
    const BookmarkPage(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: GithubStyleBottomBar(
        currentIndex: _selectedIndex,
        onTap: (value) => setState(() {
          _selectedIndex = value;
        }),
        isDarkMode: isDark,
      ),
    );
  }
}
