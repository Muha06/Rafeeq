import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/ayah_of_the_day.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';

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
                color: cs.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verse of the day:',
                    textAlign: TextAlign.left,
                    style: theme.textTheme.labelLarge,
                  ),

                  const SizedBox(height: 8),

                  //Ayah text
                  Text(
                    '"${ayah.textEnglish}"',
                    textAlign: TextAlign.left,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),

                  //refrence
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quran ${ayahSurah.id}:${ayah.ayahNumber}',
                        style: theme.textTheme.labelSmall,
                      ),

                      Text(
                        'Read more >',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: cs.primary,
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
