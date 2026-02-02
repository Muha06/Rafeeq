import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/widgets/snackbars.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/bookmarks/domain/entities/quran_bookmark.dart';
import 'package:rafeeq/features/bookmarks/presentation/riverpod/Quran/execution_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AyahTile extends ConsumerWidget {
  final Ayah ayah;

  const AyahTile({super.key, required this.ayah});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final settings = ref.watch(surahSettingsProvider);

    final showTranslation = settings.showTranslation;
    final arabicFontSize = settings.arabicFontSize;
    final translationFontSize = settings.translationFontSize;

    final id = '${ayah.surahId}:${ayah.ayahNumber}';
    final bookmarkedIds = ref.watch(bookmarkedIdsProvider);
    final isBookmarked = bookmarkedIds.contains(id);

    return AnimatedSize(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeIn,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Controls ssection
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppDarkColors.darkSurface
                    : AppLightColors.amberSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${ayah.surahId}: ${ayah.ayahNumber.toString()}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppDarkColors.textPrimary
                          : AppLightColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),

                  IconButton(
                    onPressed: () async {
                      try {
                        final isBookmarked = ref.read(isBookmarkedProvider(id));

                        if (isBookmarked) {
                          // remove bookmark
                          await ref.read(removeQuranBookmarkProvider(id))();

                          AppSnackBar.showSimple(
                            context: context,
                            isDark: isDark,
                            message: 'Bookmark removed ❌',
                            duration: const Duration(seconds: 3),
                          );

                          return;
                        }

                        // add bookmark
                        final ayahSurah = ref.read(
                          ayahSurahProvider(ayah.surahId),
                        );

                        if (ayahSurah != null) {
                          final bookmark = QuranBookmarkEntity(
                            id: '${ayah.surahId}:${ayah.ayahNumber}',
                            surahId: ayah.surahId,
                            surahEnglishName: ayahSurah.nameTransliteration,
                            ayahNumber: ayah.ayahNumber,
                            createdAt: DateTime.now(),
                          );

                          await ref.read(addQuranBookmarkProvider(bookmark))();
                        }

                        AppSnackBar.showSimple(
                          context: context,
                          isDark: isDark,
                          message: 'Bookmark added ✅',
                          duration: const Duration(seconds: 3),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Bookmark failed: $e')),
                        );
                      }
                    },
                    icon: Icon(
                      isBookmarked
                          ? Icons.bookmark_added
                          : Icons.bookmark_add_outlined,
                      size: 22,
                      color: isBookmarked
                          ? isDark
                                ? AppDarkColors.amber
                                : AppLightColors.iconAccent
                          : isDark
                          ? AppDarkColors.iconPrimary
                          : AppLightColors.iconPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {},
                    icon: Icon(
                      Icons.share,
                      size: 22,
                      color: isDark
                          ? AppDarkColors.iconPrimary
                          : AppLightColors.iconPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // arabic text (right)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                cleanAyah(ayah.textArabic),
                textDirection: TextDirection.rtl,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontWeight: isDark ? FontWeight.w500 : FontWeight.w400,
                  fontSize: arabicFontSize,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Translation
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: showTranslation
                  ? Text(
                      key: const ValueKey('translation'),
                      ayah.textEnglish,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: isDark ? FontWeight.w400 : FontWeight.w500,
                        color: isDark
                            ? AppDarkColors.textPrimary
                            : AppLightColors.textPrimary,
                        fontSize: translationFontSize,
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('hide')),
            ),
            if (showTranslation) const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
