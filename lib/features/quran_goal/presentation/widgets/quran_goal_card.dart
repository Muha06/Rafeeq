import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/pages/quran_goal_stats.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/progress_custom_paint.dart';

class QuranReadingPlanCard extends ConsumerWidget {
  const QuranReadingPlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quranGoal = ref.watch(quranGoalProvider);
    final hasGoal = quranGoal != null;

    if (!hasGoal) {
      return _NoQuranGoalCard(
        onTap: () {
          AppNav.push(context, const QuranGoalPage());
        },
      );
    }

    final progress = ref.watch(progressProvider);

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () => AppNav.push(context, const QuranGoalPage()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outline),
        ),
        child: Row(
          children: [
            CustomPaint(
              size: const Size(72, 72),
              painter: QuranProgressPainter(
                progress: progress.percentage,
                backgroundColor: cs.surfaceContainerHigh,
                progressColor: cs.primary,
                strokeWidth: 8,
                label: progress.totalRead.toString(),
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top label
                  Text(
                    'Your Quran Journey',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontFamily: AppStrings.displayFont,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Plan title
                  Text(
                    '${quranGoal.dailyTarget} ${quranGoal.targetUnit.label}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: cs.primary,
                    ),
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
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoQuranGoalCard extends StatelessWidget {
  const _NoQuranGoalCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          // color: cs.surface,
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  HugeIconsStroke.quran01,
                  color: cs.onPrimaryContainer,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Quran Goal',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: AppStrings.displayFont,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Set a reading or hifz goal and stay consistent every day.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
