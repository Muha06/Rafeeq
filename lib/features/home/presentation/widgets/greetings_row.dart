import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/calendar/presentation/pages/calendar_page.dart';
import 'package:rafeeq/features/calendar/presentation/providers/hijri_date_providers.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class GreetingsRow extends ConsumerWidget {
  const GreetingsRow({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final hijriState = ref.watch(hijriDateProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          isDark
              ? 'assets/images/home/salam_amber.png'
              : 'assets/images/home/salam_black.png',
          height: isDark ? 30 : 40,
        ),

        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarPage()),
            );
          },
          child: Text(
            hijriState.formatted,
            style: theme.textTheme.bodySmall!.copyWith(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
