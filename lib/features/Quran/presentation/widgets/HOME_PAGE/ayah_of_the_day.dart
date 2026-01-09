import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
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
      child: AnimatedSize(
        duration: Durations.medium4,
        child: ayahAsync.when(
          loading: () => Container(
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
                color: AppColors.amber,
                animating: true,
                radius: 18,
              ),
            ),
          ),
          error: (e, _) => Center(
            key: const ValueKey('error'),
            child: Text('Failed to load Ayah: $e'),
          ),
          data: (ayah) {
            if (ayah == null) return const SizedBox();

            //Fetch surah for the ayah
            final ayahSurah = ref.watch(ayahSurahProvider(ayah.surahId));
            if (ayahSurah == null) return const SizedBox();

            return GestureDetector(
              key: const ValueKey('data'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullSurahPage(surah: ayahSurah),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '==== Ayah of the Day ====',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),

                    //Arabic
                    Text(
                      ayah.textArabic,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontWeight: isDark ? FontWeight.w300 : FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),

                    //Translation
                    Text(
                      ayah.textEnglish,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),

                    //refrence
                    Text(
                      '${ayahSurah.id}:${ayah.ayahNumber}',
                      style: theme.textTheme.bodySmall!.copyWith(
                        color: AppColors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
