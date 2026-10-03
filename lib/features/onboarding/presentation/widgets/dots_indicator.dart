import 'package:flutter/material.dart';

class OnboardingDots extends StatelessWidget {
  const OnboardingDots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(count, (i) {
        final active = i == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(right: 6),
          height: 6,
          width: active ? 18 : 6,
          decoration: BoxDecoration(
            color: active ? cs.primary : cs.onSurfaceVariant,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
