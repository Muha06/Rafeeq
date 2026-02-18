import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';

/// A day tile showing BOTH: Gregorian day + Hijri day (small)
class DayCell extends ConsumerWidget {
  const DayCell({
    super.key,
    required this.day,
    required this.offsetDays,
    this.isDark = false,
    this.isToday = false,
    this.isSelected = false,
    this.isOutside = false,
  });

  final DateTime day;
  final bool isDark;
  final int offsetDays;
  final bool isToday;
  final bool isSelected;
  final bool isOutside;

  @override
  Widget build(BuildContext context, ref) {
    // Convert gregorian -> hijri, then apply offset
    final hijri = HijriDate.fromDate(day);
    final adjusted = offsetDays == 0 ? hijri : hijri.addDays(offsetDays);

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final opacity = isOutside ? 0.35 : 1.0;
    final dateTextColor = isSelected ? cs.onPrimary : cs.onSurfaceVariant;
    final todayBgColor = isToday
        ? cs.surfaceContainerHighest
        : Colors.transparent;

    return Opacity(
      opacity: opacity,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.symmetric(vertical: 0),
        decoration: BoxDecoration(
          color: isToday
              ? todayBgColor
              : isSelected
              ? cs.primary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Gregorian day number
            Text(
              '${day.day}',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: dateTextColor,
              ),
            ),
            const SizedBox(height: 2),
            
            // Hijri day number (small)
            Text(
              '${adjusted.hDay}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(color: dateTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
