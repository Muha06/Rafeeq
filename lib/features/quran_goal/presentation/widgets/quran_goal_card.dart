import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';
import 'package:rafeeq/features/quran_goal/domain/entities/quran_goal.dart';
import 'package:rafeeq/features/quran_goal/presentation/pages/quran_goal_stats.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/progress_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/progress_custom_paint.dart';

class QuranReadingPlanCard extends ConsumerWidget {
  const QuranReadingPlanCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quranGoal = ref.watch(quranGoalProvider);
    final hasGoal = quranGoal != null;

    if (!hasGoal) {
      return _NoQuranGoalCard(
        onTap: () {
          AppNav.push(context, const QuranGoalPage());
        },
      );
    }

    final progress = ref.watch(todayProgressProvider);

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AppPressableScale(
      scale: 0.97,
      onTap: () => AppNav.push(context, const QuranGoalPage()),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/quran/quran_goal_card_2.png',
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        cs.shadow.withValues(alpha: 0.65),
                        cs.shadow.withValues(alpha: 0.25),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CustomPaint(
                      size: const Size(82, 82),
                      painter: QuranProgressPainter(
                        progress: progress.percentage.toDouble(),
                        label: '${(progress.percentage * 100).round()}%',
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        progressColor: cs.tertiary,
                        strokeWidth: 7,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Your Quran Journey',
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontFamily: AppStrings.displayFont,
                              fontSize: 22,
                              color: Colors.white.withValues(alpha: 0.9),
                              letterSpacing: 0.3,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            '${quranGoal.dailyTarget} ${quranGoal.targetUnit.label}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    AppIconContainer(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      borderRadius: 999,
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoQuranGoalCard extends StatelessWidget {
  const _NoQuranGoalCard({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          // color: cs.surface,
          border: Border.all(color: cs.outline),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  HugeIconsStroke.quran01,
                  color: cs.onPrimaryContainer,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create a Quran Goal',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: AppStrings.displayFont,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Set a reading or hifz goal and stay consistent every day.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
