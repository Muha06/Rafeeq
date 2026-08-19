import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/app/providers/tabs_screen_provider.dart';
import 'package:rafeeq/core/widgets/app_state_view.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/quran_notifier_provider.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/bookmarks/presentation/widgets/bookmark_tile.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';

class QuranBookmarksTab extends ConsumerWidget {
  const QuranBookmarksTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookMarks = ref.watch(quranBookmarksProvider);

    return bookMarks.isEmpty
        ? Center(
            child: AppStateView(
              icon: PhosphorIcons.book,
              title: 'No Bookmarks',
              message:
                  'You have no saved bookmarks yet. Start bookmarking your favorite ayahs to easily read them later.',
              buttonText: "Read Quran",
              onPressed: () =>
                  ref.read(tabsScreenIndexProvider.notifier).state = 1,
            ),
          )
        : ListView.separated(
            separatorBuilder: (_, _) {
              return const SizedBox(height: 16);
            },
            padding: const EdgeInsets.symmetric(horizontal: 12),
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

                  final surahs = ref.read(surahsProvider).value ?? [];

                  final s = surahs.firstWhere((s) => s.id == bookMark.surahId);

                  final index = surahs.indexOf(s);

                  if (bookMarkSurah != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullSurahPage(
                          initialIndex: index,
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
