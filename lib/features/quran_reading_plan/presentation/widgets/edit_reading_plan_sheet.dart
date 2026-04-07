import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/quran_reading_plan/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/providers/quran_reading_plan_provider.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/widgets/log_ayah_bottomsheet.dart';

class EditQuranReadingPlanSheet extends ConsumerStatefulWidget {
  final QuranReadingPlan plan;
  const EditQuranReadingPlanSheet({super.key, required this.plan});

  @override
  ConsumerState<EditQuranReadingPlanSheet> createState() =>
      _EditQuranReadingPlanSheetState();
}

class _EditQuranReadingPlanSheetState
    extends ConsumerState<EditQuranReadingPlanSheet> {
  late int targetAyahs;
  late TextEditingController targetAyahController;
  @override
  void initState() {
    super.initState();
    targetAyahs = widget.plan.dailyTarget;
    targetAyahController = TextEditingController(
      text: widget.plan.dailyTarget.toString(),
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

              LogAyahTextField(
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
                        message: "Reading target must be greater than 1",
                      );
                      return;
                    }

                    AppNav.pop(context);
                    ref
                        .read(quranReadingPlanProvider.notifier)
                        .setTarget(targetAyahs);
                    RafeeqAnalytics.logFeature('edit_Quran_plan');
                  },
                  child: const Text("Save Plan"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
