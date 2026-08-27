import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri_date/hijri.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/clean_arabic_text.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';
import 'package:rafeeq/features/calendar/presentation/widgets/day_cell.dart';
import 'package:rafeeq/features/quran_goal/presentation/widgets/log_ayah_bottomsheet.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
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

  void _openHijriOffsetSheet(BuildContext context) {
    AppSheets.showBottomSheet(
      context: context,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(hijriDateProvider);
            final notifier = ref.read(hijriDateProvider.notifier);

            final theme = Theme.of(context);
            final cs = theme.colorScheme;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Adjust Hijri Date', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),

                  Text(
                    'Hijri dates can vary slightly depending on your region.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    state.formatted,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: cs.primary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      CircleIconButton(
                        onPressed: state.offsetDays <= -2
                            ? null
                            : () => notifier.decrement(),

                        icon: Icons.remove,
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

                      CircleIconButton(
                        onPressed: state.offsetDays >= 2
                            ? null
                            : notifier.increment,
                        icon: Icons.add,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

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
                        child: ElevatedButton(
                          onPressed: () => AppNav.pop(context),
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
      ),
    );
  }

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

  // Return list of upcoming Hijri events for next n days
  List<IslamicEvent> _monthEvents() {
    final today = ref.read(hijriDateProvider);
    final currentMonth = today.hijri.hMonth;

    final events = HijriDate.getEventsForMonth(currentMonth);

    return events;
  }

  @override
  Widget build(BuildContext context) {
    final hijriState = ref.watch(hijriDateProvider);
    final offset = hijriState.offsetDays;
    final isDark = ref.watch(isDarkProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final collapsedHeight = MediaQuery.sizeOf(context).height * .15;

    final events = _monthEvents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextButton.icon(
              icon: Icon(HugeIconsStroke.settings05, color: cs.onSurface),
              label: Text('Adjust date', style: theme.textTheme.labelLarge),
              onPressed: () => _openHijriOffsetSheet(context),
            ),
          ),
        ],
      ),
      body: SlidingUpPanel(
        minHeight: collapsedHeight,
        maxHeight: MediaQuery.sizeOf(context).height * .5,

        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),

        color: theme.colorScheme.surface,
        backdropEnabled: true,
        parallaxEnabled: true,
        parallaxOffset: .12,

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
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
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: cs.primary,
                        ),
                      ),

                      Text(
                        offset == 0
                            ? 'Offset: 0'
                            : 'Offset: ${offset > 0 ? '+' : ''}$offset',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Calendar
                TableCalendar(
                  rowHeight: 64,
                  daysOfWeekHeight: 32,
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2035, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  calendarFormat: CalendarFormat.month,
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                  },
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: theme.textTheme.labelLarge!,
                    weekendStyle: theme.textTheme.labelLarge!,
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon: AppIconContainer(
                      backgroundColor: cs.primary,
                      borderRadius: 999,
                      child: Icon(Icons.chevron_left, color: cs.onPrimary),
                    ),
                    rightChevronIcon: AppIconContainer(
                      backgroundColor: cs.primary,
                      borderRadius: 999,
                      child: Icon(Icons.chevron_right, color: cs.onPrimary),
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    headerTitleBuilder: (context, day) {
                      final gregorianTitle =
                          '${_monthName(day.month)} ${day.year}';
                      final hijriTitle = hijriHeaderForFocusedMonth(
                        day,
                        offset,
                      );
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            gregorianTitle,
                            style: theme.textTheme.titleMedium,
                          ),

                          const SizedBox(height: 2),

                          Text(
                            hijriTitle,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: cs.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) => DayCell(
                      day: day,
                      offsetDays: offset,
                      isDark: isDark,
                      isSelected: isSameDay(day, _selectedDay),
                    ),
                    todayBuilder: (context, day, focusedDay) => DayCell(
                      day: day,
                      offsetDays: offset,
                      isDark: isDark,
                      isToday: true,
                      isSelected: isSameDay(day, _selectedDay),
                    ),
                    selectedBuilder: (context, day, focusedDay) => DayCell(
                      day: day,
                      offsetDays: offset,
                      isDark: isDark,
                      isSelected: true,
                    ),
                    outsideBuilder: (context, day, focusedDay) => DayCell(
                      day: day,
                      offsetDays: offset,
                      isDark: isDark,
                      isOutside: true,
                      isSelected: isSameDay(day, _selectedDay),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        panelBuilder: () =>
            _MonthlyEvenetsPanel(hijriState: hijriState, events: events),
      ),
    );
  }
}

class _MonthlyEvenetsPanel extends ConsumerWidget {
  const _MonthlyEvenetsPanel({
    super.key,
    required this.hijriState,
    required this.events,
  });
  final List<IslamicEvent> events;
  final TodayHijriDate hijriState;

  @override
  Widget build(BuildContext context, ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AppDragHandle(),

          const SizedBox(height: 8),

          Text(
            "Events in ${hijriState.hijri.longMonthName}",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),

          events.isNotEmpty
              ? Expanded(
                  child: ListView(
                    children: events.map((event) {
                      final today = ref.read(hijriDateProvider).hijri.hDay;
                      final isToday = event.days.contains(today);

                      return IslamicEventTile(isToday: isToday, event: event);
                    }).toList(),
                  ),
                )
              : const Text('No events this month'),
        ],
      ),
    );
  }
}

class IslamicEventTile extends StatelessWidget {
  const IslamicEventTile({
    super.key,
    required this.event,
    required this.isToday,
  });

  final IslamicEvent event;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      onTap: () {
        _showEventDetailsSheet(context, event);
      },
      title: Text(event.getTitle('en')),
      trailing: isToday
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Today",
                style: TextStyle(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            )
          : null,
    );
  }
}

void _showEventDetailsSheet(BuildContext context, IslamicEvent event) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;

  AppSheets.showBottomSheet(
    context: context,
    child: SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // English & Arabic titles
              Center(
                child: Text(
                  event.titleEnglish,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 4),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  cleanDhikr(event.titleArabic),
                  style: AppTextStyles.arabicUi.copyWith(color: cs.onSurface),
                ),
              ),

              const SizedBox(height: 16),

              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Month: ', style: theme.textTheme.bodySmall),
                    TextSpan(
                      text: '${event.month}\n',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    TextSpan(text: 'Days: ', style: theme.textTheme.bodySmall),
                    TextSpan(
                      text: event.days.join(', '),
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Hadiths section
              if (event.hadiths.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: theme.colorScheme.surfaceContainerHighest,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Hadiths & References',
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),

                      ...event.hadiths.map(
                        (h) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            cleanDhikr(h.hadith),
                            style: AppTextStyles.arabicUi.copyWith(
                              color: cs.onSurface,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              // Close button
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () => AppNav.pop(context),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
  );
}
