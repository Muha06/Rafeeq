import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/Quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/execution_providers.dart';
import 'package:rafeeq/features/bookmarks/widgets/bookmark_tile.dart';
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
