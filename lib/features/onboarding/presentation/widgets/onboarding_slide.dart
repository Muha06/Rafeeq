import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.accent,
    this.child,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final Color accent;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
      child: Column(
        children: [
          const Spacer(),

          // hero image
          Image.asset(imageAsset, height: 250, fit: BoxFit.contain),

          const SizedBox(height: 26),

          // title
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: cs.onSurface,
            ),
          ),

          const SizedBox(height: 10),

          // subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
          ),

          if (child != null) ...[const SizedBox(height: 18), child!],

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
