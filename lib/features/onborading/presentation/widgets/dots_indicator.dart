import 'package:flutter/material.dart';

class OnboardingDots extends StatelessWidget {
  const OnboardingDots({super.key, required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (i) {
        final active = i == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(right: 6),
          height: 6,
          width: active ? 18 : 6,
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withOpacity(.25),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}
