import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/goal_actions_sheet.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/progress_bars/daily_progress_bar.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/weekly_chart.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/create_goal_sheet.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

class QuranGoalPage extends ConsumerWidget {
  const QuranGoalPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final quranGoal = ref.watch(quranGoalProvider);
    final hasGoal = quranGoal != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quran Goal'),
        centerTitle: true,
        actions: [
          if (hasGoal)
            IconButton(
              onPressed: () => _showGoalActionsSheet(context),
              icon: const PhosphorIcon(PhosphorIcons.dotsThreeCircle),
            ),
        ],
      ),
      body: hasGoal
          ? _GoalPageBody(quranGoal: quranGoal)
          : _NoGoalState(onCreateGoal: () => openCreateGoalSheet(context, ref)),
    );
  }
}

class _GoalPageBody extends StatefulWidget {
  const _GoalPageBody({required this.quranGoal});

  final QuranGoal quranGoal;

  @override
  State<_GoalPageBody> createState() => _GoalPageBodyState();
}

class _GoalPageBodyState extends State<_GoalPageBody> {
  final controller = PanelController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final collapsedHeight = MediaQuery.sizeOf(context).height * .45;

    return SlidingUpPanel(
      controller: controller,

      minHeight: collapsedHeight,
      maxHeight: MediaQuery.sizeOf(context).height * .65,

      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),

      color: theme.colorScheme.surfaceContainerLow,
      backdropEnabled: true,
      parallaxEnabled: true,
      parallaxOffset: .12,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: collapsedHeight),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: MyQuranGoalCard(quranGoal: widget.quranGoal),
          ),
        ),
      ),

      panelBuilder: () => const _ProgressPanel(),
    );
  }
}

class _ProgressPanel extends StatelessWidget {
  const _ProgressPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.0),
        child: Column(
          children: [
            const AppDragHandle(),

            const SizedBox(height: 8),

            Text('My Progress', style: theme.textTheme.titleMedium),

            const SizedBox(height: 8),

            const TotalQuranProgressArc(height: 160, width: 250),

            const WeeklyQuranChart(),
          ],
        ),
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

class _GoalHero extends ConsumerWidget {
  const _GoalHero({required this.goal});

  final QuranGoal goal;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final hasCompleted = ref.watch(hasCompletedQuranGoalProvider);

    return Center(
      child: GestureDetector(
        onTap: () => _showGoalActionsSheet(context),
        child: Column(
          children: [
            if (hasCompleted) const _GoalCompletedBadge(),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                "${goal.dailyTarget}",
                key: ValueKey(goal.dailyTarget),
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
      ),
    );
  }
}

class _GoalInfo extends StatelessWidget {
  const _GoalInfo({required this.goal});

  final QuranGoal goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _InfoTile(title: "Started", value: goal.formattedStartDate),

            const Spacer(),

            _InfoTile(title: "End Date", value: goal.formattedEndDate),
          ],
        ),

        const SizedBox(height: 20),

        _InfoTile(title: "Remind Me At", value: goal.formattedReminderTime),
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
        Text(title, style: theme.textTheme.labelSmall),
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
                      HugeIconsStroke.quran01,
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

void _showGoalActionsSheet(BuildContext context) {
  AppSheets.showBottomSheet(
    context: context,
    child: const GoalSheetActionsSheet(),
  );
}

class _GoalCompletedBadge extends StatelessWidget {
  const _GoalCompletedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "🏆  Goal Completed!",
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onTertiaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
