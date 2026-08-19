import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/extensions/page_animate_ext.dart';
import 'package:rafeeq/features/bookmarks/presentation/pages/adhkar_bookmark_tab.dart';
import 'package:rafeeq/features/bookmarks/presentation/pages/quran_bookmark_tab.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({super.key});

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(title: const Text('Bookmarks')),
        body: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.60,
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),

                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: theme.colorScheme.primary,
                  ),

                  labelStyle: tt.labelLarge?.copyWith(
                    color: cs.onPrimary,
                  ), // selected

                  unselectedLabelStyle: tt.labelLarge?.copyWith(
                    color: cs.onSurface,
                    fontSize: 14,
                  ),

                  tabs: const [
                    Tab(text: 'Quran'),
                    Tab(text: 'Adhkār'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Expanded(
              child: TabBarView(
                children: [QuranBookmarksTab(), AdhkarBookmarksTab()],
              ),
            ),
          ],
        ),
      ),
    ).animatePage();
  }
}
