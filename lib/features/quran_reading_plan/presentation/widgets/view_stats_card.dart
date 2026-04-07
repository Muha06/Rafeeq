import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/features/quran_reading_plan/presentation/pages/quran_reading_plan_stats.dart';

class ViewQuranReadingPlanStats extends StatelessWidget {
  const ViewQuranReadingPlanStats({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GestureDetector(
        onTap: () {
          // navigate to goal stats page
          AppNav.push(context, const QuranPlannerPage()).then(
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
                PhosphorIcons.chartBar(),
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
                PhosphorIcons.caretRight(),
                color: theme.colorScheme.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
