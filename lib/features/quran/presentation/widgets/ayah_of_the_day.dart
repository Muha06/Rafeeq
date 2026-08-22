import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/helpers/app_clipboard.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/quran_notifier_provider.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/log_ayah_bottomsheet.dart';

class AyahOfTheDay extends ConsumerWidget {
  const AyahOfTheDay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final ayahAsync = ref.watch(ayahOfTheDayProvider);

    return AnimatedSwitcher(
      duration: Durations.medium4,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: ayahAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (e, _) => const SizedBox.shrink(),
        data: (ayah) {
          if (ayah == null) return const SizedBox.shrink();

          //Fetch surah for the ayah
          final ayahSurah = ref.watch(ayahSurahProvider(ayah.surahId));
          if (ayahSurah == null) return const SizedBox.shrink();

          return GestureDetector(
            key: const ValueKey('data'),
            onTap: () {
              final surahs = ref.read(surahsProvider).value ?? [];

              final s = surahs.firstWhere((s) => s.id == ayah.surahId);

              final index = surahs.indexOf(s);

              AppNav.push(
                context,
                FullSurahPage(
                  initialIndex: index,
                  autoScrollAyah: ayah.ayahNumber,
                ),
              );
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // color: cs.surface,
                border: Border.all(color: cs.outline),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VERSE OF THE DAY',
                            textAlign: TextAlign.left,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontFamily: AppStrings.displayFont,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "Quran ${ayahSurah.id}:${ayah.ayahNumber}",
                            textAlign: TextAlign.left,
                            style: theme.textTheme.labelSmall,
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Copy
                      Consumer(
                        builder: (context, ref, _) {
                          final bookmarkId = ayah.verseKey;
                          final isBookmarked = ref.watch(
                            isQuranBookmarkedProvider(bookmarkId),
                          );

                          return CircleIconButton(
                            size: 36,
                            
                            icon: isBookmarked
                                ? HugeIconsSolid.bookmark01
                                : HugeIconsStroke.bookmark01,
                            onPressed: () async {
                              try {
                                AppHaptics.selection();

                                final ayahSurah = ref.read(
                                  ayahSurahProvider(ayah.surahId),
                                );

                                final bookmark = QuranBookmarkEntity(
                                  id: bookmarkId,
                                  surahId: ayah.surahId,
                                  surahName:
                                      ayahSurah?.nameTransliteration ?? '',
                                  ayahArabic: ayah.textArabic,
                                  ayahTranslation: ayah.textEnglish,
                                  ayahNumber: ayah.ayahNumber,
                                  createdAt: DateTime.now(),
                                );

                                //toggle
                                final isBookmarked = await ref
                                    .read(quranBookmarksProvider.notifier)
                                    .toggle(bookmark);

                                if (!context.mounted) return;

                                AppToast.showCompact(
                                  context: context,
                                  message: isBookmarked
                                      ? "Ayah Bookmarked"
                                      : "Removed from bookmarks",
                                );
                              } catch (e) {
                                AppToast.showCompact(
                                  context: context,
                                  message:
                                      "Failed to bookmark ayah. Please try again later",
                                );
                              }
                            },
                          );
                        },
                      ),

                      const SizedBox(width: 8),

                      CircleIconButton(
                        size: 36,
                        icon: Icons.content_copy,
                        onPressed: () {
                          AppClipboard.copyAyah(ayah: ayah);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  //Ayah text
                  Text(
                    '"${ayah.textEnglish}"',
                    textAlign: TextAlign.left,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),

                  //refrence
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Read more >',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
