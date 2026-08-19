import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

extension AppAnimations on Widget {
  Widget animatePage() {
    return animate()
        .fadeIn(duration: 350.ms, begin: 0.02, curve: Curves.easeOutCubic)
        .slideY(
          begin: 0.02,
          end: 0,
          duration: 550.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
