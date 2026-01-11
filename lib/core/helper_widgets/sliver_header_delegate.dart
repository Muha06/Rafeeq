import 'package:flutter/material.dart';

class SimpleSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SimpleSliverHeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      // 🔥 KEY MOVE
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: overlapsContent ? 2 : 0,
      child: SizedBox.expand(child: child),
    );
  }

  @override
  bool shouldRebuild(covariant SimpleSliverHeaderDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}
