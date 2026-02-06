import 'package:flutter/material.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    this.accent,
    this.child,
  });

  final String imageAsset;
  final String title;
  final String subtitle;
  final Color? accent;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final acc = accent ?? const Color(0xFFE7C56A); // soft gold-ish default

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
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 10),

          // subtitle
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(.76),
              height: 1.35,
            ),
          ),

          if (child != null) ...[
            const SizedBox(height: 18),
            DefaultTextStyle(
              style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
              child: IconTheme(
                data: IconThemeData(color: acc),
                child: child!,
              ),
            ),
          ],

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
