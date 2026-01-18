import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/Quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AyahOfTheDay extends ConsumerWidget {
  const AyahOfTheDay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    final ayahAsync = ref.watch(ayahOfTheDayProvider);

    return AnimatedSwitcher(
      duration: Durations.medium4,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: ayahAsync.when(
        loading: () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
          child: Container(
            key: const ValueKey('loading'),
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: const Center(
              child: CupertinoActivityIndicator(
                color: AppDarkColors.amber,
                animating: true,
                radius: 18,
              ),
            ),
          ),
        ),
        error: (e, _) => const SizedBox.shrink(),
        data: (ayah) {
          if (ayah == null) return const SizedBox.shrink();

          //Fetch surah for the ayah
          final ayahSurah = ref.watch(ayahSurahProvider(ayah.surahId));
          if (ayahSurah == null) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.only(left: 14.0, right: 14.0, bottom: 14),
            child: GestureDetector(
              key: const ValueKey('data'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullSurahPage(
                      surah: ayahSurah,
                      ayahOfTheDayAyah: ayah.ayahNumber,
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppDarkColors.darkSurface
                      : AppLightColors.amberSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily verse',
                      textAlign: TextAlign.left,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 12),

                    Divider(color: theme.dividerColor),
                    const SizedBox(height: 8),

                    //Ayah text
                    Text(
                      ayah.textEnglish,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Divider(color: theme.dividerColor),
                    const SizedBox(height: 12),

                    //refrence
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quran ${ayahSurah.id}:${ayah.ayahNumber}',
                          style: theme.textTheme.bodySmall!.copyWith(
                            // color: AppLightColors.textBody,
                          ),
                        ),

                        Text(
                          'Click to read more >',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppDarkColors.amber
                                : AppLightColors.textBody,
                            height: 1,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
