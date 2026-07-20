import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/pages/quran_goal_stats.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';

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
      onTap: () => AppNav.push(context, const QuranGoalPage()),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: cs.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top label
              Row(
                children: [
                  Text('My Quran Goal', style: theme.textTheme.labelLarge),
                  const Spacer(),

                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      AppNav.push(context, const QuranGoalPage());
                    },
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Plan title
              Text(
                '${quranGoal.target} ${quranGoal.targetUnit.label}',
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
            ],
          ),
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
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
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
                child: Icon(Icons.flag_rounded, color: cs.onPrimaryContainer),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Quran Goal',
                      style: theme.textTheme.titleMedium,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Set a reading or hifz goal and stay consistent every day.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
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
