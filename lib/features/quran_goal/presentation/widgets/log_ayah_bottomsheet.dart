import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/helpers/snackbars.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/today_progress_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

void showAyahLogSheet(BuildContext context, WidgetRef ref) {
  final cs = Theme.of(context).colorScheme;

  int ayahsRead = 1;
  final ayahController = TextEditingController(text: ayahsRead.toString());

  AppSheets.showBottomSheet(
    context: context,
    child: StatefulBuilder(
      builder: (context, setState) {
        final theme = Theme.of(context);

        // Called Whenever we update ayahsRead using Textfield
        void updateController(int value) {
          ayahsRead = value;
          ayahController.text = value.toString();
          // move cursor to end
          ayahController.selection = TextSelection.fromPosition(
            TextPosition(offset: ayahController.text.length),
          );
        }

        // calculate progress
        final todayRange = ref.read(todayRangeProvider);
        final goal = ref.read(quranGoalProvider);
        final todayProgress = ref.watch(progressProvider(todayRange));

        final totalAfterLog = todayProgress.totalRead + ayahsRead;
        final progressPercent = (totalAfterLog / goal!.target).clamp(0.0, 1.0);

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppDragHandle(),

                // Title
                Text(
                  'Today\'s Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Progress info
                Text(
                  '$totalAfterLog / ${goal.target} ${goal.targetUnit.name}',
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

                // Increment / Decrement row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleIconButton(
                      icon: PhosphorIcons.minus,
                      onPressed: ayahsRead > 1
                          ? () {
                              AppHaptics.light();
                              setState(() => ayahsRead--);
                            }
                          : null,
                    ),
                    const SizedBox(width: 16),

                    // TextField for Ayahs Read
                    LogAyahTextField(
                      controller: ayahController,
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed != null) {
                          setState(() => updateController(parsed));
                        }
                      },
                    ),

                    const SizedBox(width: 16),

                    CircleIconButton(
                      icon: PhosphorIcons.plus,
                      onPressed: () {
                        AppHaptics.light();
                        setState(() => ayahsRead++);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (ayahsRead < 1) {
                        AppSheets.showErrorDialog(
                          context: context,
                          message: "Value must be greater than 0",
                        );
                        return;
                      }

                      final wasCompleted =
                          todayProgress.totalRead >= goal.target;

                      // Save log
                      ref.read(quranLogProvider.notifier).addLog(ayahsRead);

                      // Close bottom sheet first
                      AppNav.pop(context);

                      // Re-read AFTER saving

                      final updatedProgress = ref.read(
                        progressProvider(todayRange),
                      );
                      final isCompleted =
                          updatedProgress.totalRead >= goal.target;

                      if (!wasCompleted && isCompleted) {
                        showGoalCompletedDialog(context, ref, goal.target);
                      } else {
                        AppSnackBar.showSimple(
                          context: context,
                          message: 'Reading progress updated.',
                        );
                      }

                      RafeeqAnalytics.logFeature('logged_Quran_progress');
                    },

                    icon: const Icon(PhosphorIcons.floppyDisk),
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

void showGoalCompletedDialog(
  BuildContext context,
  WidgetRef ref,
  int dailyTarget,
) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;

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
            CircleAvatar(
                  radius: 34,
                  backgroundColor: cs.surfaceContainerHighest,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: cs.primary,
                    size: 34,
                  ),
                )
                .animate()
                .scale(
                  begin: const Offset(.8, .8),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                  duration: 1.seconds,
                )
                .fadeIn(),

            const SizedBox(height: 20),

            Text(
                  'Masha’Allah!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: cs.primary,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 100.ms)
                .slideY(begin: .2, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primaryContainer,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                'Goal completed!',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: cs.onPrimaryContainer,
                ),
              ),
            ).animate().fadeIn(delay: 80.ms).scale(),

            const SizedBox(height: 20),

            Text(
              'You reached your Quran goal for today.\n'
              'May Allah ﷻ accept your recitation, increase you in guidance, and make the Quran the light of your heart.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ).animate().fadeIn(delay: 260.ms),

            const SizedBox(height: 28),

            SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      AppNav.pop(context);

                      await ref
                          .read(localNotificationServiceProvider)
                          .showNow(
                            id: 1001,
                            title: '🎉 Goal Completed!',
                            body:
                                'You completed your Quran goal for today. Keep the momentum going!',
                          );
                    },
                    child: const Text('Alhamdulillah'),
                  ),
                )
                .animate()
                .fadeIn(delay: 340.ms)
                .slideY(begin: .2, end: 0, curve: Curves.easeOutCubic),
          ],
        ),
      ),
    ),
  );
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final enabled = onPressed != null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(
          color: enabled
              ? cs.outline
              : cs.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: enabled ? cs.primary : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class LogAyahTextField extends StatelessWidget {
  const LogAyahTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

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
