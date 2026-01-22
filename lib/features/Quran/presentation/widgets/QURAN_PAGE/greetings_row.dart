import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class GreetingsRow extends ConsumerWidget {
  const GreetingsRow({super.key, required this.formattedHijri});

  final String formattedHijri;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          isDark
              ? 'assets/images/salam_amber.png'
              : 'assets/images/salam_black.png',
          height: isDark ? 30 : 40,
        ),

        Text(
          formattedHijri,
          style: theme.textTheme.bodySmall!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
