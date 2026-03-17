import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/pages/mushaf_page.dart';
import 'package:quran/quran.dart' as quran;

class SurahPages {
  final int startPage;
  final int endPage;

  SurahPages({required this.startPage, required this.endPage});

  int get totalPages => endPage - startPage + 1;
}

SurahPages getSurahPages(int surahNumber) {
  const firstVerse = 1;
  final lastVerse = quran.getVerseCount(surahNumber);

  final startPage = quran.getPageNumber(surahNumber, firstVerse);
  debugPrint("Start page: $startPage");

  final endPage = quran.getPageNumber(surahNumber, lastVerse);
  debugPrint("End page: $endPage");

  return SurahPages(startPage: startPage, endPage: endPage);
}

// Provider that returns all verses as strings
final pageVersesProvider = Provider.family<List<List<String>>, SurahPages>((
  ref,
  pages,
) {
  final allPages = <List<String>>[];

  for (int page = pages.startPage; page <= pages.endPage; page++) {
    final verses = quran.getVersesTextByPage(
      page,
      verseEndSymbol: true,
      surahSeperator: quran.SurahSeperator.none,
    );

    allPages.add(verses);
  }

  return allPages;
});

class MushafScrollView extends ConsumerWidget {
  final Surah surah;

  const MushafScrollView({super.key, required this.surah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = getSurahPages(
      surah.id,
    ); //get range of pages surah in eg: 1 - 49

    final pagesVerses = ref.watch(pageVersesProvider(pages));

    return Scrollbar(
      interactive: true,
      thickness: 14,
      child: ListView.builder(
        itemCount: pagesVerses.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return PageSurahNameCard(surah: surah);
          }
          final pageVerses = pagesVerses[index - 1];

          return MushafPageUI(
            versesList: pageVerses,
            surah: surah,
            page: pages.startPage + index - 1,
          );
        },
      ),
    );
  }
}

class PageSurahNameCard extends StatelessWidget {
  const PageSurahNameCard({super.key, required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/quran/surah_header.png',
              color: cs.onSurface,
              width: double.infinity,
              fit: BoxFit.contain,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                children: [
                  Text(
                    surah.nameTransliteration,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge,
                  ),

                  const Spacer(),
                  Text('~', style: theme.textTheme.titleLarge),

                  const Spacer(),

                  Text(
                    surah.nameArabic,
                    style: AppTextStyles.quranAyah.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
