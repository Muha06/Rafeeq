import 'package:flutter/material.dart';

/// Softly fades the edges of [child] so content looks like it dissolves
/// instead of being cut off. Works on any background (it's an alpha mask).
///
/// Use it around marquees, horizontal lists, chip rows, or (with
/// [Axis.vertical]) scrollable content.
class AppEdgeFade extends StatelessWidget {
  const AppEdgeFade({
    super.key,
    required this.child,
    this.fadeLength = 24,
    this.axis = Axis.horizontal,
    this.fadeStart = true,
    this.fadeEnd = true,
    this.enabled = true,
  });

  final Widget child;

  /// Length of each faded edge, in logical pixels.
  final double fadeLength;

  /// Horizontal fades left/right edges (RTL aware), vertical fades top/bottom.
  final Axis axis;

  /// Fade the leading edge (left in LTR, top for vertical).
  final bool fadeStart;

  /// Fade the trailing edge (right in LTR, bottom for vertical).
  final bool fadeEnd;

  /// When false, [child] is returned untouched, with no mask layer.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled || (!fadeStart && !fadeEnd)) return child;

    final isHorizontal = axis == Axis.horizontal;
    final textDirection = Directionality.of(context);

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (bounds) {
        final extent = isHorizontal ? bounds.width : bounds.height;
        final fade = extent <= 0 ? 0.0 : (fadeLength / extent).clamp(0.0, 0.5);

        return LinearGradient(
          begin: isHorizontal
              ? AlignmentDirectional.centerStart
              : Alignment.topCenter,
          end: isHorizontal
              ? AlignmentDirectional.centerEnd
              : Alignment.bottomCenter,
          colors: [
            fadeStart ? Colors.transparent : Colors.black,
            Colors.black,
            Colors.black,
            fadeEnd ? Colors.transparent : Colors.black,
          ],
          stops: [0.0, fade, 1.0 - fade, 1.0],
        ).createShader(bounds, textDirection: textDirection);
      },
      child: child,
    );
  }
}
