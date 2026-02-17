import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';

void showAyahLogSheet(BuildContext context, WidgetRef ref) {
  final cs = Theme.of(context).colorScheme;

  int ayahsRead = 1;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // handles keyboard
    backgroundColor: Colors.transparent, // for rounded corners
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
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

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
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
                    Text(
                      '$ayahsRead',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
