import 'package:flutter/cupertino.dart';

class AppIconContainer extends StatelessWidget {
  const AppIconContainer({
    super.key,
    required this.backgroundColor,
    required this.child,
    this.size = 32,
    this.borderRadius = 10,
  });

  final Color backgroundColor;
  final Widget child;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(child: child),
    );
  }
}
