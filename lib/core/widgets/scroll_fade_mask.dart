import 'package:flutter/material.dart';

class ScrollFadeMask extends StatelessWidget {
  const ScrollFadeMask({
    super.key,
    required this.child,
    this.showTop = true,
    this.showBottom = true,
    this.fadeExtent = 0.2,
  });

  final Widget child;
  final bool showTop;
  final bool showBottom;
  final double fadeExtent;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        final colors = <Color>[];
        final stops = <double>[];

        if (showTop) {
          colors.addAll([Colors.transparent, Colors.black]);
          stops.addAll([0.0, fadeExtent]);
        } else {
          colors.add(Colors.black);
          stops.add(0.0);
        }

        colors.add(Colors.black);
        stops.add(0.5);

        if (showBottom) {
          colors.addAll([Colors.black, Colors.transparent]);
          stops.addAll([1 - fadeExtent, 1.0]);
        } else {
          colors.add(Colors.black);
          stops.add(1.0);
        }

        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: stops,
        ).createShader(bounds);
      },
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }
}
