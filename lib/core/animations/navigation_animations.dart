import 'package:flutter/material.dart';

/// Pushes a page with a smooth zoom-in transition
void pushZoomPage(BuildContext context, Widget page) async {
  await Future.delayed(const Duration(milliseconds: 160));

  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: Durations.medium1, // no animation on pop
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scale = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        // Optional fade for smoother modern effect
        final fade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut));

        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    ),
  );
}

void pushLeftPage(BuildContext context, Widget page) async {
  await Future.delayed(const Duration(milliseconds: 160));

  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: Durations.medium1,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide from right to left
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0), // start offscreen right
          end: Offset.zero, // end at original position
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return SlideTransition(position: offsetAnimation, child: child);
      },
    ),
  );
}
