import 'package:flutter/material.dart';

class OnboardingSlide extends StatefulWidget {
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
  State<OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    // Initialize controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Initialize Animations
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween(
      begin: const Offset(0, .05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
     return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
          child: Column(
            children: [
              const Spacer(),

              // hero image
              Image.asset(widget.imageAsset, height: 250, fit: BoxFit.contain),

              const SizedBox(height: 26),

              // title
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),

              const SizedBox(height: 26),

              // subtitle
              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),

              if (widget.child != null) ...[
                const SizedBox(height: 18),
                widget.child!,
              ],

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
