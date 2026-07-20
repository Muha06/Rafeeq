import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/log_ayah_bottomsheet.dart';

class EditQuranGoalSheet extends ConsumerStatefulWidget {
  final QuranGoal goal;
  const EditQuranGoalSheet({super.key, required this.goal});

  @override
  ConsumerState<EditQuranGoalSheet> createState() =>
      _EditQuranGoalSheetState();
}

class _EditQuranGoalSheetState
    extends ConsumerState<EditQuranGoalSheet> {
  late int target;
  late TextEditingController targetController;
  
  @override
  void initState() {
    super.initState();
    target = widget.goal.target;
    targetController = TextEditingController(
      text: widget.goal.target.toString(),
    );
  }

  // Whenever we update target ayahs programmatically, update controller
  void updateController(int value) {
    target = value;
    targetController.text = value.toString();
    // move cursor to end
    targetController.selection = TextSelection.fromPosition(
      TextPosition(offset: targetController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Adjust My Qur'an Reading Plan",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Center(
              child: Text(
                "Set how many ayahs you aim to read daily, Insha'Allah.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),

            // --- Number selector with buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed:target > 1
                      ? () => setState(() {
                          target--;
                          updateController(target);
                        })
                      : null,
                  icon: PhosphorIcon(
                    PhosphorIcons.minus,
                    color: target > 1 ? cs.primary : cs.onSurfaceVariant,
                  ),
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

                IconButton(
                  onPressed: () => setState(() {
                    target++;
                    updateController(target);
                  }),
                  icon: Icon(PhosphorIcons.plus, color: cs.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- Action buttons ---
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final parsed = int.tryParse(targetController.text);

                      if (parsed != null && parsed <= 0) {
                        //just use the prev target & dont update
                        AppNav.pop(context);
                        AppSnackBar.showSimple(
                          context: context,
                          message: "Reading target must be greater than 1",
                        );
                        return;
                      }

                      AppNav.pop(context);
                      ref
                          .read(quranGoalProvider.notifier)
                          .updateGoal(target:  target);
                      RafeeqAnalytics.logFeature('edit_Quran_plan');
                    },
                    child: const Text("Save Plan"),
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
