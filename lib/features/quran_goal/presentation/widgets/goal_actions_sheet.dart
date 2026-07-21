import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/edit_quran_goal_sheet.dart';

class GoalSheetActionsSheet extends ConsumerWidget {
  const GoalSheetActionsSheet({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final goal = ref.watch(quranGoalProvider);

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppDragHandle(),

          Text(
            'Edit Goal',
            style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18),
          ),

          // Actions
          _EditGoalAction(
            icon: PhosphorIcons.pen,
            title: 'Adjust',
            onTap: () {
              AppSheets.showBottomSheet(
                context: context,
                child: EditQuranGoalSheet(goal: goal!),
              );
            },
          ),

          _EditGoalAction(
            icon: PhosphorIcons.trash,
            title: 'Delete Goal',
            onTap: () {
              AppSheets.showConfirmSheet(
                context: context,
                useSafeArea: true,
                title: "Delete Goal?",
                description:
                    "This will delete your current Quran goal and reset your stats",
                destructive: true,
                confirmText: "Delete",
                onConfirm: () {
                  ref.read(quranGoalProvider.notifier).deleteGoal();
                  AppNav.pop(context);
                  AppNav.pop(context);
                },
              );
            },
          ),

          _EditGoalAction(
            icon: PhosphorIcons.arrowArcRight,
            title: 'Reset Stats',
            onTap: () {
              AppSheets.showConfirmSheet(
                context: context,
                useSafeArea: true,
                title: "Reset stats?",
                description: "This will clear all your recorded ayahs.",
                destructive: true,
                confirmText: "Reset",
                onConfirm: () {
                  ref.read(quranLogProvider.notifier).resetLogs();
                  AppNav.pop(context);
                  AppNav.pop(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EditGoalAction extends StatelessWidget {
  const _EditGoalAction({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
