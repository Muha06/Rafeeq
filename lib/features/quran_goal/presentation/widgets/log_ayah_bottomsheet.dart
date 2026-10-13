import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/local_notifications/providers/wiring_providers.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_log_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rafeeq/features/user/presentation/providers/user_provider.dart';
import 'package:flutter_confetti_plus/flutter_confetti_plus.dart';

void showAyahLogSheet(BuildContext pageContext, WidgetRef ref) {
  int ayahsRead = 1;
  final ayahController = TextEditingController(text: ayahsRead.toString());

  AppSheets.showBottomSheet(
    context: pageContext,
    reverseAnimationDuration: 450.ms,
    child: StatefulBuilder(
      builder: (context, setState) {
        final theme = Theme.of(context);
        final cs = theme.colorScheme;

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
        final goal = ref.read(quranGoalProvider);
        final progress = ref.watch(todayProgressProvider);

        final totalAfterLog = progress.totalRead + ayahsRead;
        final progressPercent = (totalAfterLog / goal!.dailyTarget).clamp(
          0.0,
          1.0,
        );

        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Save your reading progress, ${ref.read(userNameProvider)}.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),

                // Progress info
                Text(
                  '$totalAfterLog / ${goal.dailyTarget} ${goal.targetUnit.name}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    // color: cs.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),

                LinearProgressIndicator(
                  value: progressPercent,
                  minHeight: 8,
                  color: cs.primary,
                ),

                const SizedBox(height: 32),

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

                const SizedBox(height: 32),

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
                          progress.totalRead >= goal.dailyTarget;

                      // Save log
                      ref.read(quranLogProvider.notifier).addLog(ayahsRead);

                      // Close bottom sheet first
                      AppNav.pop(context);

                      // Re-read AFTER saving

                      final updatedProgress = ref.read(todayProgressProvider);
                      final isCompleted =
                          updatedProgress.totalRead >= goal.dailyTarget;

                      if (!wasCompleted && isCompleted) {
                        ConfettiPlus.success(context);

                        await Future.delayed(500.ms);
                        if (!pageContext.mounted) return;

                        showGoalCompletedDialog(
                          pageContext,
                          ref,
                          goal.dailyTarget,
                        );
                      } else {
                        AppToast.showCompact(
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
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            cs.primary.withValues(alpha: 0.15),
                            cs.primary.withValues(alpha: 0.02),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: cs.primary,
                      size: 38,
                    ),
                  ],
                )
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  curve: Curves.easeInBack,
                  duration: 600.ms,
                )
                .shimmer(
                  delay: 400.ms,
                  duration: 1.seconds,
                  color: cs.onPrimary,
                ),

            const SizedBox(height: 24),

            // Header Title
            Text(
                  'Masha’Allah!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 400.ms)
                .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),

            const SizedBox(height: 12),

            // Subtle Status Badge
            Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.tertiary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    'Goal Completed',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: cs.onPrimary,
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 350.ms, duration: 300.ms)
                .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeInBack),

            const SizedBox(height: 24),

            // Description
            Text(
              'You reached your Quran goal for today.\nMay Allah ﷻ accept your recitation, and make the Quran the light of your heart.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

            const SizedBox(height: 32),

            // Primary Call to Action
            SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      AppNav.pop(context);

                      await Future.delayed(3.seconds);

                      await ref
                          .read(localNotificationServiceProvider)
                          .showNow(
                            id: 1001,
                            title: '🎉 Goal Completed!',
                            body: 'You completed your Quran goal for today. Keep the momentum going!',
                          );
                    },
                    child: const Text('Alhamdulillah'),
                  ),
                )
                .animate()
                .fadeIn(delay: 650.ms, duration: 400.ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
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
    this.enabledBgColor,
    this.enabledBorderColor,
    this.labelColor,
    this.size = 44,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? enabledBgColor;
  final Color? enabledBorderColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final enabled = onPressed != null;

    final enabledBColors = cs.outline;
    final borderColor = enabled
        ? enabledBorderColor ?? enabledBColors
        : cs.outlineVariant.withValues(alpha: 0.4);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: enabledBgColor ?? Colors.transparent,
        border: enabledBgColor == null ? Border.all(color: borderColor) : null,
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: enabled ? labelColor ?? cs.primary : cs.onSurfaceVariant,
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
          onChanged: onChanged,
          controller: controller,
        ),
      ),
    );
  }
}
