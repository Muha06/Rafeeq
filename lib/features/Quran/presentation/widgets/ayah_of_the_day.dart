import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_colors.dart';
import 'package:rafeeq/features/Quran/domain/entities/surah.dart';
import 'package:rafeeq/features/Quran/presentation/pages/full_surah_page.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/Quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AyahOfTheDay extends ConsumerWidget{
  const AyahOfTheDay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    final ayahAsync = ref.watch(ayahOfTheDayProvider);

    return ayahAsync.when(
      data: (ayah) {
        if (ayah == null) return const SizedBox();

        //fetch all surahs
        final List<Surah> surahs = ref
            .watch(surahsFutureProvider)
            .maybeWhen(data: (list) => list, orElse: () => []);

        //fetch the surah in which ayah is in
        final ayahSurah = surahs.firstWhere(
          (s) => s.id == ayah.surahId,
          orElse: () => const Surah(
            id: 0,
            nameArabic: '',
            nameEnglish: '',
            nameTransliteration: '',
            versesCount: 0,
            isMeccan: false,
          ),
        );

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullSurahPage(surah: ayahSurah),
              ),
            );
          },
          child: AnimatedSize(
            duration: Durations.short3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.amber),
      ),
      error: (e, _) => Center(child: Text('Failed to load Ayah: $e')),
    );
  }
}
