import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/daily_progress_bar.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/edit_goal_sheet.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/monthly_progress_bar.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/weekly_chart.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/weekly_progress_bar.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class QuranGoalStatsPage extends ConsumerWidget {
  const QuranGoalStatsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My stats'),
        actions: [
          IconButton(
            onPressed: () {
              AppSheets.showConfirmSheet(
                context: context,
                title: "Reset stats?",
                description: "This will clear all your recorded ayahs.",
                destructive: true,
                confirmText: "Reset",
                onConfirm: () {
                  ref.read(quranLogProvider.notifier).resetLogs();
                },
              );
            },
            icon: PhosphorIcon(PhosphorIcons.arrowClockwise()),
            tooltip: 'Reset stats',
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            MyQuranGoalCard(),
            SizedBox(height: 8),

            ProgressBars(
              bars: [
                TodayQuranProgressArc(),
                WeeklyQuranProgressArc(),
                MonthlyQuranProgressArc(),
              ],
            ),
            SizedBox(height: 8),

            WeeklyQuranChart(),
          ],
        ),
      ),
    );
  }
}

class ProgressBars extends StatelessWidget {
  const ProgressBars({super.key, required this.bars});
  final List<Widget> bars;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: cs.surface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Overview', style: theme.textTheme.labelLarge),
          ),
          const SizedBox(height: 16),

          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 0,
            children: bars,
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,

          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: bars,
          // ),
        ],
      ),
    );
  }
}

class MyQuranGoalCard extends ConsumerWidget {
  const MyQuranGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(quranGoalProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: cs.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Active badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("My Goal", style: theme.textTheme.labelLarge),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withAlpha(80),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    goal.isActive ? "Goal Active" : "Goal Paused",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Goal details
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Target: ", style: theme.textTheme.bodySmall),

                      Text(
                        "${goal.dailyTarget} ayahs/day",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),

                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Started: ',
                              style: theme.textTheme.bodySmall!,
                            ),
                            TextSpan(
                              text: goal.formattedStartDate,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Always show bottom sheet to edit
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => EditQuranGoalSheet(goal: goal),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Adjust"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final notifier = ref.read(quranGoalProvider.notifier);
                      notifier.toggleGoalActivity();

                      final updated = ref.read(quranGoalProvider);
                      AppSnackBar.showSimple(
                        context: context,
                        isDark: ref.read(isDarkProvider),
                        message: updated.isActive
                            ? "Goal unpaused"
                            : "Goal paused",
                      );
                    },
                    child: Text(
                      goal.isActive ? "Pause goal" : "Un pause",
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: cs.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
