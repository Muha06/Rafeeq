import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  TimeOfDay reminder = const TimeOfDay(hour: 20, minute: 0);

  final goals = const [
    (amount: 5, title: 'Gentle Start', icon: HugeIconsStroke.leaf01),
    (amount: 10, title: 'Steady Growth', icon: HugeIconsStroke.plant01),
    (amount: 15, title: 'Keep Building', icon: HugeIconsStroke.chartIncrease),
    (amount: 20, title: 'Strong Commitment', icon: HugeIconsStroke.rocket),
  ];

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

            GoalSettingTile(
              icon: HugeIconsStroke.notification01,
              title: 'Daily reminder',
              subtitle: 'Get reminded to complete your goal',
              value: reminder.format(context),
              onTap: () {
                pickReminder();
              },
            ),

            const SizedBox(height: 18),

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
