import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_tempt/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran_tempt/presentation/riverpod/ayah_of_the_day.dart';

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
            child: CupertinoActivityIndicator(animating: true, radius: 18),
          ),
        ),
        error: (e, _) => const SizedBox.shrink(),
        data: (ayah) {
          if (ayah == null) return const SizedBox.shrink();

          //Fetch surah for the ayah
          final ayahSurah = ref.watch(ayahSurahProvider(ayah.surahId));
          if (ayahSurah == null) return const SizedBox();

          return GestureDetector(
            key: const ValueKey('data'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullSurahPage(
                    surah: ayahSurah,
                    autoScrollAyah: ayah.ayahNumber,
                  ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verse of the day',
                    textAlign: TextAlign.left,
                    style: theme.textTheme.labelLarge,
                  ),

                  const SizedBox(height: 8),

                  //Ayah text
                  Text(
                    ayah.textEnglish,
                    textAlign: TextAlign.left,
                    style: theme.textTheme.bodyMedium,
                  ),
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
                        style: theme.textTheme.bodySmall!.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
