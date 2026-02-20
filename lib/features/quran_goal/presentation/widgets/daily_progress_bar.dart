 import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/today_progress_provider.dart';

class TodayQuranProgressArc extends ConsumerWidget {
  const TodayQuranProgressArc({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final progress = ref.watch(todayProgressProvider);
    final total = progress.totalRead;
    final target = progress.dailyTarget;

    final percentage = target == 0 ? 0.0 : (total / target) * 100;

    return Column(
      children: [
        Text('Today', style: theme.textTheme.labelMedium!.copyWith(height: 1)),

        SizedBox(
          height: 116,
          width: 108,
          child: ArcProgressBar(
            percentage: percentage.clamp(0, 100),
            handleColor: cs.primary,
            foregroundColor: cs.primary,
            backgroundColor: cs.surfaceContainerHighest,
            handleSize: 0,
            centerWidget: Text(
              "${percentage.clamp(0, 100).toStringAsFixed(0)} %",
              style: theme.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            arcThickness: 6,
            strokeCap: StrokeCap.round,
          ),
        ),
      ],
    );
  }
}
