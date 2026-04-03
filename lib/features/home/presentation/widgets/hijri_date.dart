import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/features/calendar/presentation/pages/calendar_page.dart';
import 'package:rafeeq/features/calendar/presentation/providers/hijri_date_providers.dart';

class HijriDateToday extends ConsumerWidget {
  const HijriDateToday({
    super.key,
    required this.foregroundColor,
    required this.fontSize,
  });
  final Color foregroundColor;
  final double fontSize;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hijriState = ref.watch(hijriDateProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        AppNav.push(context, const CalendarPage());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hijriState.formatted,
            style: theme.textTheme.bodySmall!.copyWith(
              color: foregroundColor,
              fontSize: fontSize,
            ),
          ),
          const SizedBox(width: 8),

          Icon(
            PhosphorIcons.caretRight(),
            size: 16,
            color: theme.iconTheme.color,
          ),
        ],
      ),
    );
  }
}
