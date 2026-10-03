import 'package:flutter/material.dart';

class AppPressableScale extends StatefulWidget {
  const AppPressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.9,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;
  final Curve curve;

  @override
  State<AppPressableScale> createState() => _AppPressableScaleState();
}

class _AppPressableScaleState extends State<AppPressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (mounted) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: (_) => _setPressed(true),
      onPointerDown: (_) {
        _setPressed(true);
      },
      onPointerUp: (_) {
        _setPressed(false);
      },
      onPointerCancel: (_) {
        _setPressed(false);
      },
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) {
          _setPressed(false);

          widget.onTap?.call();
        },
        onTapCancel: () => _setPressed(false),
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _pressed ? widget.scale : 1.0,
          duration: widget.duration,
          curve: widget.curve,
          child: widget.child,
        ),
      ),
    );
  }
}
