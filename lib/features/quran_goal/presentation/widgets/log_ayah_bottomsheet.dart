import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';

void showAyahLogSheet(BuildContext context, WidgetRef ref) {
  final cs = Theme.of(context).colorScheme;

  int ayahsRead = 1;
  final ayahController = TextEditingController(text: ayahsRead.toString());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // handles keyboard
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        // Whenever we update ayahsRead programmatically, update controller
        void updateController(int value) {
          ayahsRead = value;
          ayahController.text = value.toString();
          // move cursor to end
          ayahController.selection = TextSelection.fromPosition(
            TextPosition(offset: ayahController.text.length),
          );
        }

        // calculate progress
        final goal = ref.read(quranGoalProvider);
        final todayProgress = ref.read(
          progressProvider(
            DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().copyWith(hour: 23, minute: 59, second: 59),
            ),
          ),
        );

        final totalAfterLog = todayProgress.totalRead + ayahsRead;
        final progressPercent = (totalAfterLog / goal.dailyTarget).clamp(
          0.0,
          1.0,
        );

        String encouragement;
        if (progressPercent < 0.5) {
          encouragement = "Keep going, you got this!";
        } else if (progressPercent < 1.0) {
          encouragement = "Masha’Allah, almost there!";
        } else {
          encouragement = "Goal complete! JazakAllahu Khair!";
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: cs.surface),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Log your reading',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Progress info
                Text(
                  '$totalAfterLog / ${goal.dailyTarget} ayahs today',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 8,
                  color: cs.primary,
                ),
                const SizedBox(height: 16),

                Text(
                  encouragement,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Increment / Decrement row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: ayahsRead > 1
                          ? () => setState(() => ayahsRead--)
                          : null,
                      icon: Icon(
                        PhosphorIcons.minus(),
                        color: ayahsRead > 1 ? cs.primary : cs.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // TextField for Ayahs Read
                    LogSetGoalTextfield(
                      controller: ayahController,
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed != null && parsed > 0) {
                          setState(() => updateController(parsed));
                        }
                      },
                    ),

                    const SizedBox(width: 16),

                    IconButton(
                      onPressed: () => setState(() => ayahsRead++),
                      icon: Icon(PhosphorIcons.plus(), color: cs.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Save log
                      ref.read(quranLogProvider.notifier).addLog(ayahsRead);

                      // Close bottom sheet first
                      Navigator.pop(context);

                      debugPrint(todayProgress.totalRead.toString());

                      if (todayProgress.totalRead >= goal.dailyTarget) {
                        showGoalCompletedDialog(
                          context, // can use rootNavigator: true inside dialog if needed
                          goal.dailyTarget,
                        );
                      }
                    },

                    icon: Icon(PhosphorIcons.floppyDisk()),
                    label: const Text('Save'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    ),
  );
}

class LogSetGoalTextfield extends StatelessWidget {
  const LogSetGoalTextfield({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 52,
          maxWidth: 64,
          maxHeight: 52,
        ),
        child: TextField(
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(contentPadding: EdgeInsets.zero),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          onChanged: onChanged,
          controller: controller,
        ),
      ),
    );
  }
}

void showGoalCompletedDialog(BuildContext context, int dailyTarget) {
  final cs = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji / Celebration
            const Text('🎉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            // Title
            Text(
              'Masha’Allah!',
              style: TextStyle(
                color: cs.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Subtitle / message
            Text(
              'You completed your $dailyTarget ayahs today.\nMay Allah ﷻ accept your recitation and reward you abundantly (JazakAllahu Khair)!',
              style: TextStyle(color: cs.onSurface, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // OK button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Alhamdulillah!'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
