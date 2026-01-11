import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 
class GreetingsRow extends ConsumerWidget {
  const GreetingsRow({super.key, required this.formattedHijri});

  final String formattedHijri;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/salam_amber.png', height: 50, width: 100),

        Text(formattedHijri, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
