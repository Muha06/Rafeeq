import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/features/onboarding/presentation/provider/quran_goal_target.dart';
import 'package:rafeeq/features/user/presentation/providers/user_provider.dart';

class CreateGoalSlide extends ConsumerStatefulWidget {
  const CreateGoalSlide({super.key});

  @override
  ConsumerState<CreateGoalSlide> createState() => _CreateGoalSlideState();
}

class _CreateGoalSlideState extends ConsumerState<CreateGoalSlide> {
  int selectedGoal = 10;

  final goals = const [
    (amount: 5, title: 'Gentle Start', icon: HugeIconsStroke.leaf01),
    (amount: 10, title: 'Steady Growth', icon: HugeIconsStroke.plant01),
    (amount: 15, title: 'Keep Building', icon: HugeIconsStroke.chartIncrease),
    (amount: 20, title: 'Strong Commitment', icon: HugeIconsStroke.rocket),
  ];

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(userNameProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Set a daily target you plan to complete, $name',
              textAlign: TextAlign.center,
              style: tt.headlineSmall?.copyWith(
                fontFamily: AppStrings.displayFont,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Start with what feels realistic. You can always increase it later.',
              textAlign: TextAlign.center,
              style: tt.bodyMedium,
            ),

            const SizedBox(height: 24),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: goals.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final goal = goals[index];

                return CreateGoalTile(
                  amount: goal.amount,
                  title: goal.title,
                  icon: goal.icon,
                  isSelected: selectedGoal == goal.amount,
                  onTap: () {
                    setState(() {
                      selectedGoal = goal.amount;
                    });

                    ref.read(quranGoalTargetProvider.notifier).state =
                        goal.amount;
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            Text(
              '“The most beloved deeds to Allah are those that are consistent, even if they are few.”',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyReminderSlide extends StatefulWidget {
  const DailyReminderSlide({super.key, required this.onReminderChanged});

  final ValueChanged<TimeOfDay> onReminderChanged;

  @override
  State<DailyReminderSlide> createState() => _DailyReminderSlideState();
}

class _DailyReminderSlideState extends State<DailyReminderSlide> {
  TimeOfDay reminder = const TimeOfDay(hour: 20, minute: 0);
  late final TextEditingController _hourController;
  late final TextEditingController _minuteController;

  @override
  void initState() {
    super.initState();
    _hourController = TextEditingController(text: '08');
    _minuteController = TextEditingController(text: '00');
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void updateReminder({bool? isPm}) {
    final selectedHour = int.tryParse(_hourController.text);
    final selectedMinute = int.tryParse(_minuteController.text);

    if (selectedHour == null || selectedHour < 1 || selectedHour > 12) return;
    if (selectedMinute == null || selectedMinute < 0 || selectedMinute > 59) {
      return;
    }
    final selectedIsPm = isPm ?? reminder.period == DayPeriod.pm;

    final updatedReminder = TimeOfDay(
      hour: (selectedHour % 12) + (selectedIsPm ? 12 : 0),
      minute: selectedMinute,
    );

    if (updatedReminder.hour == reminder.hour &&
        updatedReminder.minute == reminder.minute) {
      return;
    }

    setState(() => reminder = updatedReminder);
    widget.onReminderChanged(updatedReminder);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose a daily reminder',
                  textAlign: TextAlign.center,
                  style: tt.headlineSmall?.copyWith(
                    fontFamily: AppStrings.displayFont,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pick a time that works for your daily Quran reading.',
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium,
                ),
              ],
            ),
          ),

          
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  reminder.format(context),
                  textAlign: TextAlign.center,
                  style: tt.displaySmall?.copyWith(
                    color: cs.primary,
                    fontFamily: AppStrings.displayFont,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _TimePartTextField(
                        label: 'HOUR',
                        controller: _hourController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => updateReminder(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TimePartTextField(
                        label: 'MINUTE',
                        controller: _minuteController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => updateReminder(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AmPmSelector(
                        label: 'AM/PM',
                        isPm: reminder.period == DayPeriod.pm,
                        onChanged: (isPm) => updateReminder(isPm: isPm),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimePartTextField extends StatelessWidget {
  const _TimePartTextField({
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.onChanged,
    this.inputFormatters = const [],
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            textAlign: TextAlign.center,
            inputFormatters: inputFormatters,
            style: tt.titleMedium?.copyWith(color: cs.onSurface),
            onChanged: onChanged,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmPmSelector extends StatelessWidget {
  const _AmPmSelector({
    required this.label,
    required this.isPm,
    required this.onChanged,
  });

  final String label;
  final bool isPm;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SegmentedButton<bool>(
      direction: Axis.vertical,
      showSelectedIcon: false,
      style: ButtonStyle(
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return cs.primary;
          }

          return cs.surface;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return cs.onPrimary;
          }

          return cs.onSurface;
        }),
      ),
      segments: const [
        ButtonSegment(value: false, label: Text('AM')),
        ButtonSegment(value: true, label: Text('PM')),
      ],
      selected: {isPm},
      onSelectionChanged: (selection) => onChanged(selection.first),
    );
  }
}

class CreateGoalTile extends StatelessWidget {
  const CreateGoalTile({
    super.key,
    required this.amount,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final int amount;
  final String title;
  final dynamic icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected ? cs.primaryContainer : cs.surface,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: isSelected ? cs.primary : cs.onSurfaceVariant,
            ),

            const SizedBox(height: 10),

            Text('$amount', style: tt.headlineSmall),

            Text(
              'ayahs',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              style: tt.labelLarge?.copyWith(
                color: isSelected ? cs.onPrimaryContainer : cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalSettingTile extends StatelessWidget {
  const GoalSettingTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onTap,
  });

  final dynamic icon;
  final String title;
  final String subtitle;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: cs.primary),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Text(value, style: tt.labelLarge?.copyWith(color: cs.primary)),

            const SizedBox(width: 4),

            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: cs.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
