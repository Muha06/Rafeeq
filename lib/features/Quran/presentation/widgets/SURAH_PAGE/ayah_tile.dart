import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/functions/clean_arabic_text.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/ayah.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/surah_preferences_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AyahTile extends ConsumerWidget {
  final Ayah ayah;

  const AyahTile({super.key, required this.ayah});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final showTranslation = ref.watch(showTranslationProvider);
    final arabicFontSize = ref.watch(arabicFontSizeProvider);
    final translationFontSize = ref.watch(translationFontSizeProvider);

    return AnimatedSize(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeIn,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // verse number (top-left)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                ayah.ayahNumber.toString(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppDarkColors.amber,
                  fontSize: 16,
                ),
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
                  fontWeight: isDark ? FontWeight.w300 : FontWeight.w400,
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
                        fontSize: translationFontSize,
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('hide')),
            ),
            if (showTranslation) const SizedBox(height: 20),

            Divider(color: theme.dividerColor),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.bookmark_add_outlined,
                    size: 22,
                    color: isDark
                        ? AppDarkColors.iconSecondary
                        : AppLightColors.iconSecondary,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    size: 22,
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
