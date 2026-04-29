import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum AppImageShape { circle, rounded }

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
    this.shape = AppImageShape.rounded,
    this.placeholder,
    this.errorWidget,
  });

  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double borderRadius;
  final AppImageShape shape;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final placeholderWidget =
        placeholder ??
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );

    final error =
        errorWidget ?? const Center(child: Icon(Icons.broken_image_outlined));

    // If no image URL, show error widget
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildWrapper(error);
    }

    return _buildWrapper(
      CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, _) => placeholderWidget,
        errorWidget: (_, _, _) => error,
      ),
    );
  }

  Widget _buildWrapper(Widget child) {
    final content = SizedBox(width: width, height: height, child: child);

    if (shape == AppImageShape.circle) {
      return ClipOval(child: content);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: content,
    );
  }
}
