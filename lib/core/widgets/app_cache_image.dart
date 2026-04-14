import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius = 12,
    this.placeholder,
    this.errorWidget,
  });

  final String? imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    final placeholderWidget =
        placeholder ??
        const Center(child: CircularProgressIndicator(strokeWidth: 2));

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(width: width, height: height, child: child),
    );
  }
}
