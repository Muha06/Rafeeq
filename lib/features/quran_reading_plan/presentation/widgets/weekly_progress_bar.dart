import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/weeky_progress_provider.dart';

class WeeklyQuranProgressArc extends ConsumerWidget {
  const WeeklyQuranProgressArc({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final progress = ref.watch(weeklyProgressProvider);
    final total = progress.totalRead;
    final target = progress.dailyTarget; // assuming already multiplied by 7

    final percentage = target == 0 ? 0.0 : (total / target) * 100;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Weekly', style: theme.textTheme.labelMedium!.copyWith(height: 1)),

        SizedBox(
          height: 116,
          width: 108,
          child: ArcProgressBar(
            percentage: percentage.clamp(0, 100),
            handleColor: cs.primary,
            handleSize: 0,
            arcThickness: 6,
            foregroundColor: cs.primary,
            backgroundColor: cs.surfaceContainerHighest,
            centerWidget: Text(
              "${percentage.clamp(0, 100).toStringAsFixed(0)} %",
              style: theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            strokeCap: StrokeCap.round,
          ),
        ),
      ],
    );
  }
}
