import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
 import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/execution_providers.dart';
import 'package:rafeeq/features/bookmarks/widgets/bookmark_tile.dart';

class QuranBookmarksTab extends ConsumerWidget {
  const QuranBookmarksTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookMarks = ref.watch(getAllQuranBookmarksProvider);
    final theme = Theme.of(context);

    return bookMarks.isEmpty
        ? Center(
            child: AppStateView(
              icon: PhosphorIcons.book(),
              title: 'No Bookmarks',
              message:
                  'You have no saved bookmarks yet. Start bookmarking your favorite ayahs to easily read them later.',
              buttonText: "Read Quran",
              onPressed: () =>
                  ref.read(tabsScreenIndexProvider.notifier).state = 1,
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
                        builder: (context) => FullSurahPage(
                          surah: bookMarkSurah,
                          autoScrollAyah: bookMark.ayahNumber,
                        ),
                      ),
                    );
                  }
                },
                child: BookmarkTile(
                  indexDisplay: indexDisplay,
                  quranBookMark: bookMark,
                ),
              );
            },
          );
  }
}
