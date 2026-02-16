import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/hijri_date_providers.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String _hijriMonthYearFor(DateTime date, int offsetDays) {
    final h = HijriDate.fromDate(date);
    final adjusted = offsetDays == 0 ? h : h.addDays(offsetDays);
    return '${adjusted.longMonthName} ${adjusted.hYear}';
  }

  //return hijri year & month for specific date
  String hijriHeaderForFocusedMonth(DateTime focusedDay, int offsetDays) {
    final first = DateTime(focusedDay.year, focusedDay.month, 1);
    final last = DateTime(focusedDay.year, focusedDay.month + 1, 0);

    final firstLabel = _hijriMonthYearFor(first, offsetDays);
    final lastLabel = _hijriMonthYearFor(last, offsetDays);

    return firstLabel == lastLabel ? firstLabel : '$firstLabel – $lastLabel';
  }

  String _monthName(int m) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final hijriState = ref.watch(hijriDateProvider);
    final offset = hijriState.offsetDays;
    final isDark = ref.watch(isDarkProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton.icon(
              icon: const Icon(Icons.tune),
              label: Text(
                'Adjust date',
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.textTheme.bodyLarge!.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => _openHijriOffsetSheet(context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header preview (Today)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hijriState.formatted,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    offset == 0
                        ? 'Offset: 0'
                        : 'Offset: ${offset > 0 ? '+' : ''}$offset',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Expanded(
              child: TableCalendar(
                rowHeight: 52, // each row height
                daysOfWeekHeight: 32,
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: _focusedDay, //today

                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) => _focusedDay = focusedDay,

                calendarFormat: CalendarFormat.month, //  force month view
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month', //  only one option exists
                },

                //Day of week style
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: Theme.of(context).textTheme.labelSmall!,
                  weekendStyle: Theme.of(context).textTheme.labelSmall!,
                ),

                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),

                calendarBuilders: CalendarBuilders(
                  //Month section
                  headerTitleBuilder: (context, day) {
                    //show Gregorion month & year
                    final gregorianTitle =
                        '${_monthName(day.month)} ${day.year}';
                    //show Hijri month & year
                    final hijriTitle = hijriHeaderForFocusedMonth(day, offset);

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          gregorianTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hijriTitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) => _DayCell(
                    day,
                    isDark,
                    offset,
                    isSelected: isSameDay(day, _selectedDay),
                  ),
                  todayBuilder: (context, day, focusedDay) => _DayCell(
                    day,
                    isDark,
                    offset,
                    isToday: true,
                    isSelected: isSameDay(day, _selectedDay),
                  ),
                  selectedBuilder: (context, day, focusedDay) =>
                      _DayCell(day, isDark, offset, isSelected: true),
                  outsideBuilder: (context, day, focusedDay) => _DayCell(
                    day,
                    isDark,
                    offset,
                    isOutside: true,
                    isSelected: isSameDay(day, _selectedDay),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openHijriOffsetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(hijriDateProvider);
          final notifier = ref.read(hijriDateProvider.notifier);

          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Adjust Hijri date',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(state.formatted),
                const SizedBox(height: 16),

                Row(
                  children: [
                    IconButton(
                      onPressed: state.offsetDays <= -2
                          ? null
                          : () => notifier.decrement(),

                      icon: const Icon(Icons.remove),
                    ),
                    Expanded(
                      child: Slider(
                        min: -2,
                        max: 2,
                        divisions: 4,
                        value: state.offsetDays.toDouble(),
                        label: state.offsetDays.toString(),
                        onChanged: (v) => notifier.setOffset(v.round()),
                      ),
                    ),
                    IconButton(
                      onPressed: state.offsetDays >= 2
                          ? null
                          : notifier.increment,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: state.offsetDays == 0
                            ? null
                            : notifier.reset,
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Done'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A day tile showing BOTH: Gregorian day + Hijri day (small)
class _DayCell extends ConsumerWidget {
  const _DayCell(
    this.day,
    this.isDark,
    this.offsetDays, {
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
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
