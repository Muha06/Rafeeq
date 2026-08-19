import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rafeeq/core/constants/spacing/app_spacing.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';

void openCreateGoalSheet(BuildContext context, WidgetRef ref) {
  AppSheets.showBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    child: const CreateGoalSheet(),
  );
}

class CreateGoalSheet extends ConsumerStatefulWidget {
  const CreateGoalSheet({super.key});

  @override
  ConsumerState<CreateGoalSheet> createState() => _CreateGoalSheetState();
}

class _CreateGoalSheetState extends ConsumerState<CreateGoalSheet> {
  String formatDate(DateTime date) {
    if (DateUtils.isSameDay(date, DateTime.now())) {
      return "Today";
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  final targetController = TextEditingController();

  QuranGoalType goalType = QuranGoalType.tilawah;
  QuranTargetUnit targetUnit = QuranTargetUnit.ayah;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  TimeOfDay reminder = const TimeOfDay(hour: 20, minute: 0);

  final goalTypeNotifier = ValueNotifier(QuranGoalType.tilawah);
  final targetUnitNotifier = ValueNotifier(QuranTargetUnit.ayah);

  void createGoal() {
    final target = int.tryParse(targetController.text.trim());

    if (target == null || target <= 0) {
      AppSheets.showErrorDialog(
        context: context,
        message: "Target cannot be empty",
      );

      debugPrint("error");
      return;
    }

    final goal = QuranGoal(
      type: goalTypeNotifier.value,
      targetUnit: targetUnitNotifier.value,
      target: target,
      startDate: startDate,
      endDate: endDate,
      remindMeAt: reminder,
      createdAt: DateTime.now(),
    );

    AppNav.pop(context);

    ref.read(quranGoalProvider.notifier).createGoal(goal);
  }

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        startDate = picked;

        if (endDate.isBefore(startDate)) {
          endDate = startDate;
        }
      });
    }
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  Future<void> pickReminder() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminder,
    );

    if (picked != null) {
      setState(() => reminder = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        12,
        12,
        12,
        MediaQuery.of(context).viewInsets.bottom + 8,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppDragHandle(),

              const SizedBox(height: 8),

              Text(
                "Create Quran Goal",
                style: theme.textTheme.headlineSmall?.copyWith(fontSize: 24),
              ),

              const SizedBox(height: AppSpacing.xxl),

              GoalTypeTargetRow(
                goalTypeNotifier: goalTypeNotifier,
                targetUnitNotifier: targetUnitNotifier,
              ),

              const SizedBox(height: 16),

              GoalTargetField(
                controller: targetController,
                unit: targetUnit.label,
              ),

              const SizedBox(height: 16),

              GoalScheduleTile(
                icon: Icons.calendar_today_outlined,
                title: 'Start Date',
                value: formatDate(startDate),
                onTap: pickStartDate,
              ),

              GoalScheduleTile(
                icon: Icons.event_outlined,
                title: 'End Date',
                value: formatDate(endDate),
                onTap: pickEndDate,
              ),

              GoalScheduleTile(
                icon: Icons.notifications_active_outlined,
                title: 'Daily Reminder',
                value: reminder.format(context),
                onTap: pickReminder,
              ),

              const SizedBox(height: 16),

              GoalCreateButton(onPressed: createGoal),
            ],
          ).animate().fade(),
        ),
      ),
    );
  }
}

class GoalTypeTargetRow extends StatelessWidget {
  const GoalTypeTargetRow({
    super.key,
    required this.goalTypeNotifier,
    required this.targetUnitNotifier,
  });

  final ValueNotifier<QuranGoalType> goalTypeNotifier;
  final ValueNotifier<QuranTargetUnit> targetUnitNotifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GoalDropdown<QuranGoalType>(
            label: 'Goal Type',
            valueListenable: goalTypeNotifier,
            items: QuranGoalType.values,
            itemLabel: (e) => e.label,
            onChanged: (value) {
              if (value == null) return;
              goalTypeNotifier.value = value;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GoalDropdown<QuranTargetUnit>(
            label: 'Target Unit',
            valueListenable: targetUnitNotifier,
            items: QuranTargetUnit.values,
            itemLabel: (e) => e.label,
            onChanged: (value) {
              if (value == null) return;
              targetUnitNotifier.value = value;
            },
          ),
        ),
      ],
    );
  }
}

class GoalScheduleTile extends StatelessWidget {
  const GoalScheduleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 18, color: cs.onSurfaceVariant),

              const SizedBox(width: 14),

              Expanded(child: Text(title, style: theme.textTheme.labelLarge)),

              Text(value, style: theme.textTheme.bodyMedium),

              const SizedBox(width: 4),

              Icon(Icons.chevron_right_rounded, color: cs.outline),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalDropdown<T> extends StatelessWidget {
  const GoalDropdown({
    super.key,
    required this.label,
    required this.valueListenable,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
  });

  final String label;
  final ValueNotifier<T?> valueListenable;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide(color: cs.outline),
    );

    return DropdownButtonFormField2<T>(
      isExpanded: true,
      onChanged: onChanged,
      valueListenable: valueListenable,
      items: items
          .map(
            (item) => DropdownItem<T>(
              value: item,
              child: Text(itemLabel(item), style: theme.textTheme.labelLarge),
            ),
          )
          .toList(),
      decoration: InputDecoration(
        labelText: label,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
      buttonStyleData: const FormFieldButtonStyleData(
        height: 24,
        width: 64,
        padding: EdgeInsets.symmetric(horizontal: 8),
      ),
      iconStyleData: IconStyleData(
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: cs.onSurfaceVariant,
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 8,
        maxHeight: 250,
      ),
    );
  }
}

class GoalTargetField extends StatelessWidget {
  const GoalTargetField({
    super.key,
    required this.controller,
    required this.unit,
  });

  final TextEditingController controller;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      width: 160,
      height: 48,
      child: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineMedium?.copyWith(
          color: cs.primary,
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: "Target e.g. 30",
          hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
            fontSize: 24,
          ),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 24),
        ),
      ),
    );
  }
}

class GoalCreateButton extends StatelessWidget {
  const GoalCreateButton({
    super.key,
    required this.onPressed,
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.auto_stories_outlined),
        label: const Text("Create Goal"),
      ),
    );
  }
}
