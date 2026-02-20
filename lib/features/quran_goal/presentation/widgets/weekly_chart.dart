import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/quran_goal_provider.dart';
import 'package:rafeeq/features/quran_goal/presentation/providers/weeky_progress_provider.dart';

class WeeklyQuranChart extends ConsumerWidget {
  const WeeklyQuranChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final weeklyRead = ref.watch(weeklyProgressByDayProvider);
    final dailyTarget = ref.watch(quranGoalProvider).dailyTarget;

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: cs.surface,
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: dailyTarget.toDouble(), // Fixed scale
          barTouchData: const BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: dailyTarget / 5,
                getTitlesWidget: (val, meta) => Text(
                  val.toInt().toString(),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  final index = val.toInt();
                  return Text(
                    days[index % 7],
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (index) {
            final value = weeklyRead[index]
                .clamp(0, dailyTarget.toDouble())
                .toDouble();
            final todayIndex = DateTime.now().weekday - 1; // Mon=0
            final isToday = todayIndex == index;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: value == dailyTarget
                      ? cs
                            .primary //change to green
                      : isToday
                      ? cs.primary
                      : cs.primary.withAlpha(120),
                  width: 14,
                  borderRadius: BorderRadius.circular(999),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
