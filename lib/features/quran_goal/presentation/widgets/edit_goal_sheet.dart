import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/helpers/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/log_ayah_bottomsheet.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class EditQuranGoalSheet extends ConsumerStatefulWidget {
  final QuranGoal goal;
  const EditQuranGoalSheet({super.key, required this.goal});

  @override
  ConsumerState<EditQuranGoalSheet> createState() => _EditQuranGoalSheetState();
}

class _EditQuranGoalSheetState extends ConsumerState<EditQuranGoalSheet> {
  late int targetAyahs;
  late TextEditingController targetAyahController;
  @override
  void initState() {
    super.initState();
    targetAyahs = widget.goal.dailyTarget;
    targetAyahController = TextEditingController(
      text: widget.goal.dailyTarget.toString(),
    );
  }

  // Whenever we update target ayahs programmatically, update controller
  void updateController(int value) {
    targetAyahs = value;
    targetAyahController.text = value.toString();
    // move cursor to end
    targetAyahController.selection = TextSelection.fromPosition(
      TextPosition(offset: targetAyahController.text.length),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- Islamic-friendly title ---
          Text(
            "Adjust My Qur'an Goal",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Center(
            child: Text(
              "Set how many ayahs you aim to read daily, Insha'Allah.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Number selector with buttons ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: targetAyahs > 1
                    ? () => setState(() {
                        targetAyahs--;
                        updateController(targetAyahs);
                      })
                    : null,
                icon: PhosphorIcon(
                  PhosphorIcons.minus(),
                  color: targetAyahs > 1 ? cs.primary : cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),

              LogSetGoalTextfield(
                controller: targetAyahController,
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
                  targetAyahs++;
                  updateController(targetAyahs);
                }),
                icon: Icon(PhosphorIcons.plus(), color: cs.primary),
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
                    final parsed = int.tryParse(targetAyahController.text);

                    if (parsed != null && parsed <= 0) {
                      //just use the prev target & dont update
                      AppNav.pop(context);
                      AppSnackBar.showSimple(
                        context: context,
                        isDark: ref.read(isDarkProvider),
                        message: "Active goal target must be greater than 1",
                      );
                      return;
                    }

                    AppNav.pop(context);
                    ref.read(quranGoalProvider.notifier).setGoal(targetAyahs);
                    RafeeqAnalytics.logFeature('edit_Quran_goal');
                  },
                  child: const Text("Save Goal"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
