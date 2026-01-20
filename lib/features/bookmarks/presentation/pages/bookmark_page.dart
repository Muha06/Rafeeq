import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/appbar_bottom_divider.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/pages/adhkar_bookmark_tab.dart';
import 'package:rafeeq/features/bookmarks/presentation/pages/quran_bookmark_tab.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/execution_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class BookmarkPage extends ConsumerStatefulWidget {
  const BookmarkPage({super.key});

  @override
  ConsumerState<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends ConsumerState<BookmarkPage> {
  Future<bool> _confirmClearAll(BuildContext context) async {
    final theme = Theme.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Clear all bookmarks?', style: theme.textTheme.titleMedium),
        content: Text(
          'This will remove all saved bookmarks.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),

          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
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
                // padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppDarkColors.darkSurface
                      : AppLightColors.amberSoft,
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
                    color: isDark
                        ? AppDarkColors.textSecondary
                        : AppLightColors.buttonPrimaryPressed,
                  ),

                  // labelColor: isDark ? Colors.white : Colors.black,
                  unselectedLabelColor: isDark
                      ? AppDarkColors.textBody
                      : AppLightColors.textPrimary,

                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppLightColors.snackbarText,
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

  IconButton icn(
    List<QuranBookmarkEntity> bookMarks,
    BuildContext context,
    bool isDark,
  ) {
    return IconButton(
      onPressed: () async {
        if (bookMarks.isEmpty) return;

        final ok = await _confirmClearAll(context);
        if (!ok) return;

        try {
          await ref.read(
            clearAllBookmarksActionProvider,
          )(); //clear all bookmarks

          if (context.mounted) {
            AppSnackBar.showSimple(
              context: context,
              isDark: isDark,
              message: 'All bookmarks cleared 🗑️',
              duration: const Duration(seconds: 2),
            );
          }
        } catch (e) {
          if (context.mounted) {
            AppSnackBar.showSimple(
              context: context,
              isDark: isDark,
              message: 'Failed to clear bookmarks: $e',
              duration: const Duration(seconds: 3),
            );
          }
        }
      },
      icon: Icon(
        Icons.delete_forever,
        color: isDark
            ? AppDarkColors.iconSecondary
            : AppLightColors.iconPrimary,
      ),
    );
  }
}
