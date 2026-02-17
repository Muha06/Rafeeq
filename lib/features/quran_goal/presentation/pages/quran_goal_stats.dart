import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/edit_goal_sheet.dart';

class QuranGoalStatsPage extends StatefulWidget {
  const QuranGoalStatsPage({super.key});

  @override
  State<QuranGoalStatsPage> createState() => _QuranGoalStatsPageState();
}

class _QuranGoalStatsPageState extends State<QuranGoalStatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My stats')),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(children: [MyQuranGoalCard()]),
      ),
    );
  }
}

class MyQuranGoalCard extends ConsumerWidget {
  const MyQuranGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(quranGoalProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cs.surface,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Active badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("My Goal", style: theme.textTheme.titleMedium),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withAlpha(80),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    goal.isActive ? "Active" : "Paused",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Goal details
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Target: ", style: theme.textTheme.bodySmall),

                      Text(
                        "${goal.dailyTarget} ayahs/day",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),

                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Started: ',
                              style: theme.textTheme.bodySmall!,
                            ),
                            TextSpan(
                              text: goal.formattedStartDate,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
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
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => EditQuranGoalSheet(goal: goal),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Adjust"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      ref.read(quranGoalProvider.notifier).setGoal(0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Goal deleted")),
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: Text(
                      "Pause goal",
                      style: theme.textTheme.labelSmall!.copyWith(
                        color: cs.primary,
                      ),
                    ),
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
