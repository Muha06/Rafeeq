import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/dhikr_bookmark.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/execution_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class BookmarkTile extends ConsumerWidget {
  const BookmarkTile({
    super.key,
    required this.indexDisplay,
    required this.bookMark,
    required this.isDark,
  });

  final int indexDisplay;
  final QuranBookmarkEntity bookMark;
  final bool isDark;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(indexDisplay.toString()),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ${bookMark.surahEnglishName}',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    ' ${bookMark.surahId}:${bookMark.ayahNumber}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                showBookmarkActionSheet(
                  context,
                  ref: ref,
                  isDark: isDark,
                  quranBookmark: bookMark,
                );
              },
              icon: const FaIcon(FontAwesomeIcons.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> showBookmarkActionSheet(
  BuildContext context, {
  required WidgetRef ref,
  required bool isDark,
  QuranBookmarkEntity? quranBookmark,
  DhikrBookmark? dhikrBookmark,
}) {
  final theme = Theme.of(context);

  return showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    isScrollControlled: false,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title / subtitle (optional but modern)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Actions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _ActionTile(
              icon: Icons.ios_share_outlined,
              title: 'Share',
              subtitle: 'Share ayah',
              onTap: () {},
            ),

            const SizedBox(height: 8),

            _ActionTile(
              icon: Icons.delete_outline_rounded,
              title: 'Delete',
              subtitle: 'This can’t be undone',
              onTap: () async {
                if (quranBookmark != null) {
                  try {
                    await ref.read(
                      removeQuranBookmarkProvider(quranBookmark.id),
                    )();

                    Navigator.pop(context);

                    if (context.mounted) {
                      AppSnackBar.showSimple(
                        context: context,
                        isDark: isDark,
                        message: 'Bookmark removed ❌',
                        duration: const Duration(seconds: 2),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      AppSnackBar.showSimple(
                        context: context,
                        isDark: isDark,
                        message: 'Delete failed. Please try again.',
                        duration: const Duration(seconds: 2),
                      );
                    }
                  }
                }
              },
            ),

            const SizedBox(height: 16),

            // Cancel button (modern + obvious exit)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}

/// Modern action tile: rounded, card-ish, big tap target.
class _ActionTile extends ConsumerWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    final iconColor = isDark
        ? AppDarkColors.iconSecondary
        : AppLightColors.iconSecondary;

    final titleColor = isDark
        ? AppDarkColors.textPrimary
        : AppLightColors.textPrimary;

    return Material(
      color: isDark ? AppDarkColors.onDarkSurface : AppLightColors.lightSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: titleColor.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: iconColor),
            ],
          ),
        ),
      ),
    );
  }
}
