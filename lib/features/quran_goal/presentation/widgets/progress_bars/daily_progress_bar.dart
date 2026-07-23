import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/total_progress_provider.dart';

class TotalQuranProgressArc extends ConsumerWidget {
  const TotalQuranProgressArc({
    super.key,
    required this.height,
    required this.width,
  });
  final double height;
  final double width;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final goal = ref.watch(quranGoalProvider);

    final progress = ref.watch(totalQuranProgressProvider);
    final totalRead = progress.totalRead;
    final totalTarget = progress.totalTarget;

    final percentage = totalTarget == 0 ? 0.0 : (totalRead / totalTarget) * 100;

    return SizedBox(
      height: height,
      width: width,
      child: ArcProgressBar(
        percentage: percentage.clamp(0, 100),
        handleColor: cs.primary,
        foregroundColor: cs.primary,
        backgroundColor: cs.surfaceContainerHighest,
        handleSize: 0,
        centerWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${percentage.clamp(0, 100).toStringAsFixed(0)} %",
              style: theme.textTheme.titleMedium!.copyWith(),
            ),

            const SizedBox(height: 8),

            Text(
              "${totalRead.toString()} ${goal?.targetUnit.label} read",
              maxLines: 2,
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
        arcThickness: 6,
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
