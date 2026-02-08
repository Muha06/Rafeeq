import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rafeeq/features/calendar/presentation/pages/calendar_page.dart';
import 'package:rafeeq/features/calendar/presentation/providers/hijri_date_providers.dart';

PreferredSizeWidget buildlHijriDate(BuildContext context, WidgetRef ref) {
  final theme = Theme.of(context);
  final hijriState = ref.watch(hijriDateProvider);

  return PreferredSize(
    preferredSize: const Size.fromHeight(24),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CalendarPage()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hijriState.formatted,
              style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
            ),
            const Spacer(),
            const FaIcon(FontAwesomeIcons.chevronRight, size: 16),
          ],
        ),
      ),
    ),
  );
}
