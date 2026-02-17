import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/ui_helpers.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_ayah_dialog.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';

class QuranGoalCard extends ConsumerWidget {
  const QuranGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(quranGoalProvider);

    // Today range for V1
    final today = DateTime.now();
    final todayRange = DateTimeRange(
      start: DateTime(today.year, today.month, today.day),
      end: DateTime(today.year, today.month, today.day, 23, 59, 59),
    );

    final progress = ref.watch(progressProvider(todayRange));

    final cs = Theme.of(context).colorScheme;

    return Card(
      color: cs.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top label
            Row(
              children: [
                Text(
                  'My Quran Goal',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
                const Spacer(),
                
                TextButton(
                  onPressed: () {
                    ref.read(quranGoalProvider.notifier).setGoal(5);
                    ref.read(quranLogProvider.notifier).resetLogs();
                  },
                  child: const Text("reset"),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Goal title
            Text(
              '${goal.dailyTarget} ayahs per day',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Progress row
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress.percentage,
                    color: cs.primary,
                    backgroundColor: cs.surfaceContainerHighest,
                    minHeight: 8,
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
              child: ElevatedButton(
                onPressed: () async {
                  final surahs = ref.read(surahsFutureProvider).value;

                  if (surahs == null) return;

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
    );
  }
}
