import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bookmarks'),
          bottom: appBarBottomDivider(context),
        ),
        body: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.60,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),

                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
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
    );
  }
}

class EmptyState extends StatelessWidget {
  final String subtitle; // Optional smaller message
  final String buttonText; // CTA button text
  final VoidCallback onPressed; // CTA action
  final IconData? icon; // Optional icon to show on top

  const EmptyState({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 64, color: colorScheme.primary),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 8),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: 200,
              child: TextButton(onPressed: onPressed, child: Text(buttonText)),
            ),
          ],
        ),
      ),
    );
  }
}
