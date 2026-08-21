import 'package:flutter/material.dart';

class AppSliverPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  const AppSliverPinnedHeaderDelegate({
    required this.child,
    required this.height,
  });

  final Widget child;
  final double height;

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
    return child;
  }

  @override
  bool shouldRebuild(covariant AppSliverPinnedHeaderDelegate oldDelegate) {
    return height != oldDelegate.height || child != oldDelegate.child;
  }
}
