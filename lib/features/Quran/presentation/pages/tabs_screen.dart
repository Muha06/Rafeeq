import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/widgets/github_style_bottom_bar.dart';
import 'package:rafeeq/features/Quran/presentation/pages/bookmark.dart';
import 'package:rafeeq/features/Quran/presentation/pages/home_page.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  final List<Widget> _pages = [const HomePage(), const HomePage()];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final theme = Theme.of(context);

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
