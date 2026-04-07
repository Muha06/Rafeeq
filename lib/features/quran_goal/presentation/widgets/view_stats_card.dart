import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/quran_goal/presentation/pages/quran_goal_stats.dart';

class ViewQuranGoalStats extends StatelessWidget {
  const ViewQuranGoalStats({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          // navigate to goal stats page
          AppNav.push(context, const QuranGoalStatsPage()).then(
            (value) =>
                RafeeqAnalytics.logScreenView('Quran_progress_stats_page'),
          );
        },
        child: Container(
          height: 64,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                CupertinoIcons.chart_bar,
                color: theme.colorScheme.onPrimary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'View your Quran Goal stats',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              Icon(
                CupertinoIcons.chevron_forward,
                color: theme.colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
