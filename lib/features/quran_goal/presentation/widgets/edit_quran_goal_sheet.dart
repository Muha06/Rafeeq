import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/create_goal_sheet.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/log_ayah_bottomsheet.dart';

class EditQuranGoalSheet extends ConsumerStatefulWidget {
  final QuranGoal goal;
  const EditQuranGoalSheet({super.key, required this.goal});

  @override
  ConsumerState<EditQuranGoalSheet> createState() => _EditQuranGoalSheetState();
}

class _EditQuranGoalSheetState extends ConsumerState<EditQuranGoalSheet> {
  late int target;
  late TextEditingController targetController;
  final goalTypeNotifier = ValueNotifier(QuranGoalType.tilawah);
  final targetUnitNotifier = ValueNotifier(QuranTargetUnit.page);

  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  TimeOfDay? reminder;

  @override
  void initState() {
    super.initState();

    target = widget.goal.target;
    endDate = widget.goal.endDate;
    reminder = widget.goal.remindMeAt;

    targetController = TextEditingController(text: target.toString());

    goalTypeNotifier.value = widget.goal.type;
    targetUnitNotifier.value = widget.goal.targetUnit;
  }

  @override
  void dispose() {
    targetController.dispose();
    goalTypeNotifier.dispose();
    targetUnitNotifier.dispose();
    super.dispose();
  }

  void updateController(int value) {
    target = value;
    targetController.text = value.toString();
    // move cursor to end
    targetController.selection = TextSelection.fromPosition(
      TextPosition(offset: targetController.text.length),
    );
  }

  void _updateGoal() {
    final parsed = int.tryParse(targetController.text);

    if (parsed != null && parsed <= 0) {
      AppNav.pop(context);
      AppSnackBar.showSimple(
        context: context,
        message: "Reading target must be at least 1.",
      );
      return;
    }

    ref
        .read(quranGoalProvider.notifier)
        .updateGoal(
          target: parsed ?? target,
          endDate: endDate,
          remindMeAt: reminder,
          targetUnit: targetUnitNotifier.value,
          type: goalTypeNotifier.value,
        );
    RafeeqAnalytics.logFeature('edit_Quran_plan');

    AppNav.pop(context);
    AppNav.pop(context);
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: widget.goal.startDate,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  Future<void> pickReminder() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminder!,
    );

    if (picked != null) {
      setState(() => reminder = picked);
    }
  }

  String formatDate(DateTime date) {
    if (DateUtils.isSameDay(date, DateTime.now())) {
      return "Today";
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppDragHandle(),

            const SizedBox(height: 16),

            Text("Edit", style: theme.textTheme.titleMedium),

            const SizedBox(height: 24),

            GoalTypeTargetRow(
              goalTypeNotifier: goalTypeNotifier,
              targetUnitNotifier: targetUnitNotifier,
            ),

            const SizedBox(height: 16),

            GoalScheduleTile(
              icon: Icons.event_outlined,
              title: 'End Date',
              value: formatDate(endDate),
              onTap: pickEndDate,
            ),

            if (reminder != null)
              GoalScheduleTile(
                icon: Icons.notifications_active_outlined,
                title: 'Remind me at',
                value: reminder!.format(context),
                onTap: pickReminder,
              ),

            // --- Number selector with buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleIconButton(
                  icon: PhosphorIcons.minus,
                  onPressed: target > 1
                      ? () {
                          AppHaptics.selection();

                          setState(() {
                            target--;
                            updateController(target);
                          });
                        }
                      : null,
                ),
                const SizedBox(width: 16),

                LogAyahTextField(
                  controller: targetController,
                  onChanged: (value) {
                    final parsed = int.tryParse(value);
                    if (parsed != null && parsed > 0) {
                      setState(() => updateController(parsed));
                    }
                  },
                ),
                const SizedBox(width: 16),

                CircleIconButton(
                  onPressed: () {
                    AppHaptics.selection();

                    setState(() {
                      target++;
                      updateController(target);
                    });
                  },
                  icon: PhosphorIcons.plus,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // --- Action buttons ---
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => AppNav.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _updateGoal,
                    child: const Text("Update"),
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
