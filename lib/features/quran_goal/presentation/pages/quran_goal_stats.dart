import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/progress_bars/daily_progress_bar.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/adjust_quran_goal_sheet.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/progress_bars/monthly_progress_bar.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/weekly_chart.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/progress_bars/weekly_progress_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuranGoalPage extends ConsumerWidget {
  const QuranGoalPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final quranGoal = ref.watch(quranGoalProvider);
    final hasGoal = quranGoal != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quran Goal'),
        actions: [
          if (hasGoal)
            IconButton(
              onPressed: () {
                AppSheets.showConfirmSheet(
                  context: context,
                  useSafeArea: true,
                  title: "Reset stats?",
                  description: "This will clear all your recorded ayahs.",
                  destructive: true,
                  confirmText: "Reset",
                  onConfirm: () {
                    ref.read(quranLogProvider.notifier).resetLogs();
                  },
                );
              },
              icon: const PhosphorIcon(PhosphorIcons.arrowClockwise),
              tooltip: 'Reset stats',
            ),
        ],
      ),
      body: hasGoal
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MyQuranGoalCard(quranGoal: quranGoal),
                    const SizedBox(height: 8),

                    const ProgressBars(
                      bars: [
                        TodayQuranProgressArc(),
                        WeeklyQuranProgressArc(),
                        MonthlyQuranProgressArc(),
                      ],
                    ),
                    const SizedBox(height: 8),

                    const WeeklyQuranChart(),
                  ],
                ),
              ),
            )
          : _NoGoalState(onCreateGoal: () {}),
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
  const MyQuranGoalCard({super.key, required this.quranGoal});
  final QuranGoal quranGoal;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> toggleGoal() async {
      final notifier = ref.read(quranGoalProvider.notifier);
      notifier.updateGoal(isActive: !quranGoal.isActive);

      final updated = ref.read(quranGoalProvider);
      final goalPaused = !updated!.isActive;
      AppSnackBar.showSimple(
        context: context,
        message: goalPaused ? "Goal unpaused" : "Goal paused",
      );

      await ref
          .read(localNotificationServiceProvider)
          .showNow(
            id: 1002,
            title: goalPaused ? 'Goal Paused' : 'Goal Resumed',
            body: goalPaused
                ? 'Your Quran goal has been paused. You can resume it anytime.'
                : 'Your Quran goal has been resumed. Keep up the great progress!',
          );
    }

    void showEditSheet() {
      // Always show bottom sheet to edit
      AppSheets.showBottomSheet(
        context: context,
        child: EditQuranReadingPlanSheet(goal: quranGoal),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GoalHeader(isActive: quranGoal.isActive),

          const SizedBox(height: 28),

          _GoalHero(dailyTarget: quranGoal.target),

          const SizedBox(height: 28),

          const Divider(),

          const SizedBox(height: 24),

          _GoalInfo(
            startDate: quranGoal.formattedStartDate,
            isActive: quranGoal.isActive,
          ),

          const SizedBox(height: 28),

          _GoalActions(
            isActive: quranGoal.isActive,
            onEdit: showEditSheet,
            onToggle: toggleGoal,
          ),
        ],
      ),
    );
  }
}

class _GoalHeader extends StatelessWidget {
  const _GoalHeader({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Daily Target", style: theme.textTheme.titleMedium),

        _GoalStatusBadge(isActive: isActive),
      ],
    );
  }
}

class _GoalStatusBadge extends StatelessWidget {
  const _GoalStatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: .12)
            : cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle_outline : Icons.pause_outlined,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? "Active" : "Paused",
            style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

class _GoalHero extends StatelessWidget {
  const _GoalHero({required this.dailyTarget});

  final int dailyTarget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              "$dailyTarget",
              key: ValueKey(dailyTarget),
              style: theme.textTheme.displayLarge?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
                height: .9,
              ),
            ),
          ),
          Text(
            "ayahs per day",
            style: theme.textTheme.titleMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalInfo extends StatelessWidget {
  const _GoalInfo({required this.startDate, required this.isActive});

  final String startDate;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _InfoTile(title: "Started", value: startDate),
        ),

        const Spacer(),

        Expanded(
          child: _InfoTile(
            title: "Status",
            value: isActive ? "In Progress" : "Paused",
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.labelLarge),
      ],
    );
  }
}

class _GoalActions extends StatelessWidget {
  const _GoalActions({
    required this.onEdit,
    required this.onToggle,
    required this.isActive,
  });

  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
          label: const Text("Edit"),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: onToggle,
          icon: Icon(
            isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
          ),
          label: Text(isActive ? "Pause" : "Resume"),
        ),
      ],
    );
  }
}

class _NoGoalState extends StatelessWidget {
  const _NoGoalState({required this.onCreateGoal});

  final VoidCallback onCreateGoal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                    width: 92,
                    height: 92,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withValues(alpha: .45),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      PhosphorIcons.flag,
                      size: 42,
                      color: cs.primary,
                    ),
                  )
                  .animate()
                  .scale(duration: 450.ms, curve: Curves.easeOutBack)
                  .fadeIn(),

              const SizedBox(height: 24),

              Text(
                'No Quran Goal Yet',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ).animate(delay: 120.ms).fadeIn().slideY(begin: .15),

              const SizedBox(height: 12),

              Text(
                'Set a personal Quran recitation goal to stay consistent and track your progress every day.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 220.ms).fadeIn().slideY(begin: .15),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child:
                    ElevatedButton(
                          onPressed: onCreateGoal,
                          // icon: const Icon(Icons.add_rounded),
                          child: const Text('Create Goal'),
                        )
                        .animate(delay: 320.ms)
                        .fadeIn()
                        .scale(
                          begin: const Offset(.9, .9),
                          curve: Curves.easeOutBack,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
