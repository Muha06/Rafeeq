import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/Quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/execution_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class QuranBookmarksTab extends ConsumerWidget {
  const QuranBookmarksTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookMarks = ref.watch(getAllQuranBookmarksProvider);
    final isDark = ref.watch(isDarkProvider);
    final theme = Theme.of(context);

    return bookMarks.isEmpty
        ? Center(
            child: Text(
              'No bookmarks yet',
              style: theme.textTheme.bodySmall!.copyWith(fontSize: 16),
            ),
          )
        : ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(color: theme.dividerColor);
            },
            itemCount: bookMarks.length,
            itemBuilder: (context, index) {
              final bookMark = bookMarks[index];
              final indexDisplay = index + 1;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final bookMarkSurah = ref.read(
                    ayahSurahProvider(bookMark.surahId),
                  );

                  if (bookMarkSurah != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullSurahPage(surah: bookMarkSurah),
                      ),
                    );
                  }
                },
                child: BookmarkTile(
                  indexDisplay: indexDisplay,
                  bookMark: bookMark,
                  isDark: isDark,
                ),
              );
            },
          );
  }
}

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

            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: isDark
                        ? AppDarkColors.iconSecondary
                        : AppLightColors.iconSecondary,
                  ),
                  onPressed: () async {
                    try {
                      await ref.read(
                        removeQuranBookmarkProvider(bookMark.id),
                      )();

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
                          message: 'Delete failed ❌',
                          duration: const Duration(seconds: 2),
                        );
                      }
                    }
                  },
                ),

                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: isDark
                        ? AppDarkColors.iconSecondary
                        : AppLightColors.iconSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
