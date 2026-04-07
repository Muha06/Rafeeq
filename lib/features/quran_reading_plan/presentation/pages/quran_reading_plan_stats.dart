import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/quran_reading_plan_provider.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/quran_log_provider.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/widgets/daily_progress_bar.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/widgets/edit_reading_plan_sheet.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/widgets/monthly_progress_bar.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/widgets/weekly_chart.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/widgets/weekly_progress_bar.dart';

class QuranPlannerPage extends ConsumerWidget {
  const QuranPlannerPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reading Plan'),
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
            child: Text('My Progress', style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: 16),

          Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 0,
            children: bars,
          ),
        ],
      ),
    );
  }
}

class MyQuranGoalCard extends ConsumerWidget {
  const MyQuranGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingPlan = ref.watch(quranReadingPlanProvider);
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
                Text("Daily Pace", style: theme.textTheme.titleMedium),

                Chip(
                  label: Text(
                    readingPlan.isActive ? "Active" : "Paused",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Goal details
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${readingPlan.dailyTarget} ayahs/day",
                        style: theme.textTheme.headlineMedium!.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Started: ',
                              style: theme.textTheme.bodySmall,
                            ),

                            TextSpan(
                              text: readingPlan.formattedStartDate,
                              style: theme.textTheme.labelLarge,
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
                      AppSheets.showBottomSheet(
                        context: context,
                        child: EditQuranReadingPlanSheet(plan: readingPlan),
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
                      final notifier = ref.read(
                        quranReadingPlanProvider.notifier,
                      );
                      notifier.toggleReadingPlanActivity();

                      final updated = ref.read(quranReadingPlanProvider);
                      AppSnackBar.showSimple(
                        context: context,
                        message: updated.isActive
                            ? "Target unpaused"
                            : "Target paused",
                      );
                    },
                    child: Text(readingPlan.isActive ? "Pause" : "Unpause"),
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
