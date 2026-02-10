import 'package:flutter/material.dart';

/// Pushes a page with a smooth zoom-in transition
void pushZoomPage(BuildContext context, Widget page) async {
  await Future.delayed(const Duration(milliseconds: 160));

  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Incoming page: zoom in more
        final incomingScale = Tween<double>(begin: 0.7, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        // Current page: zoom in slightly
        final currentScale = Tween<double>(begin: 1.0, end: 1.5).animate(
          CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut),
        );

        // Optional fade for polish
        final incomingFade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

        return Stack(
          children: [
            // Current page (background)
            ScaleTransition(
              scale: currentScale,
              child: const SizedBox.expand(),
            ),

            // Incoming page (foreground)
            FadeTransition(
              opacity: incomingFade,
              child: ScaleTransition(scale: incomingScale, child: child),
            ),
          ],
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
