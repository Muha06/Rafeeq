import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/goal_actions_sheet.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/progress_bars/daily_progress_bar.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/progress_bars/monthly_progress_bar.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/weekly_chart.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/create_goal_sheet.dart';
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
                AppSheets.showBottomSheet(
                  context: context,
                  child: const GoalSheetActionsSheet(),
                );
              },
              icon: const PhosphorIcon(PhosphorIcons.dotsThreeCircle),
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
          : _NoGoalState(onCreateGoal: () => openCreateGoalSheet(context, ref)),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GoalHero(goal: quranGoal),

          const SizedBox(height: 28),

          const Divider(),

          const SizedBox(height: 24),

          _GoalInfo(goal: quranGoal),
        ],
      ),
    );
  }
}

class _GoalHero extends StatelessWidget {
  const _GoalHero({required this.goal});

  final QuranGoal goal;

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
              "${goal.target}",
              key: ValueKey(goal.target),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
                fontSize: 64,
              ),
            ),
          ),
          Text(
            goal.targetUnit.label,
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
  const _GoalInfo({required this.goal});

  final QuranGoal goal;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoTile(title: "Started", value: goal.formattedStartDate),

        const Spacer(),

        _InfoTile(title: "End Date", value: goal.formattedEndDate),
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
