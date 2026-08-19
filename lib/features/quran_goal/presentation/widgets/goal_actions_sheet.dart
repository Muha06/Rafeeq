import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/core/widgets/bottom_sheet_action.dart';
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppDragHandle(),

            const SizedBox(height: 16),

            Text('Manage Your Quran Goal', style: theme.textTheme.titleMedium),

            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  title: 'Delete',
                  onTap: () {
                    AppSheets.showConfirmSheet(
                      context: context,
                      useSafeArea: true,
                      icon: HugeIconsSolid.delete02,
                      title: "Delete Goal?",
                      description:
                          "This will delete your current Quran goal and reset your progress",
                      destructive: true,
                      confirmText: "Delete",
                      onConfirm: () {
                        AppHaptics.selection();
                        ref.read(quranGoalProvider.notifier).deleteGoal();
                        AppNav.pop(context);
                        AppNav.pop(context);
                      },
                    );
                  },
                ),

                _EditGoalAction(
                  icon: PhosphorIcons.arrowArcRight,
                  title: 'Reset',
                  onTap: () {
                    AppSheets.showConfirmSheet(
                      context: context,
                      useSafeArea: true,
                      icon: PhosphorIcons.arrowArcRight,
                      title: "Reset stats?",
                      description:
                          "This will clear all your recorded progress.",
                      destructive: true,
                      confirmText: "Reset",
                      onConfirm: () {
                        AppHaptics.selection();
                        ref.read(quranLogProvider.notifier).resetLogs();
                        AppNav.pop(context);
                        AppNav.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BottomSheetActionBtn(
        iconData: icon,
        label: title,
        onPressed: onTap,
      ),
    );
  }
}
