import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_ayah_dialog.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/pages/quran_reading_plan_stats.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/progress_provider.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/quran_reading_plan_provider.dart';

class QuranReadingPlanCard extends ConsumerWidget {
  const QuranReadingPlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingPlan = ref.watch(quranReadingPlanProvider);

    // Today range for V1
    final today = DateTime.now();
    final todayRange = DateTimeRange(
      start: DateTime(today.year, today.month, today.day),
      end: DateTime(today.year, today.month, today.day, 23, 59, 59),
    );

    final progress = ref.watch(progressProvider(todayRange));

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () => AppNav.push(context, const QuranPlannerPage()),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: cs.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top label
              Row(
                children: [
                  Text('My Reading Plan', style: theme.textTheme.labelLarge),
                  const Spacer(),

                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      AppNav.push(context, const QuranPlannerPage());
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),

              // Plan title
              Text(
                '${readingPlan.dailyTarget} ayahs / day',
                style: theme.textTheme.titleLarge?.copyWith(color: cs.primary),
              ),
              const SizedBox(height: 16),

              // Progress row
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress.percentage,
                      color: cs.primary.withAlpha(200),
                      backgroundColor: cs.surfaceContainerHighest,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Text(
                    '${(progress.percentage * 100).round()}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // CTA Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    final surahs = ref.read(surahsProvider).value ?? [];

                    showSurahAyahPickerDialog(
                      context: context,
                      surahs: surahs,
                      onGo: (surahId, surahVerse) {
                        final selectedSurah = surahs.firstWhere(
                          (surah) => surah.id == surahId,
                        );
                        AppNav.push(
                          context,
                          FullSurahPage(
                            surah: selectedSurah,
                            autoScrollAyah: surahVerse,
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('Start Reading'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
