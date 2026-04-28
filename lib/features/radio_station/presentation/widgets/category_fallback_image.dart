import 'package:flutter/material.dart';
import 'package:rafeeq/features/radio_station/domain/entities/radio_station.dart';
import 'package:rafeeq/features/radio_station/domain/enums/radio_audio_category.dart';

class CategoryFallback extends StatelessWidget {
  const CategoryFallback({
    super.key,
    required this.station,
    this.height = 80,
    this.width = 80,
    this.showShadow = true,
    this.isSheet = true,
  });

  final RadioStation station;
  final double height;
  final double width;
  final bool showShadow;
  final bool isSheet;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: cs.onSurfaceVariant.withAlpha(32),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            station.category.icon, // or your switch-case icon
            size: 48,
            color: cs.primary,
          ),
          const SizedBox(height: 8),

          Text(
            station.category.label,
            style: tt.headlineMedium?.copyWith(
              color: cs.onSurface,
              fontSize: isSheet ? 24 : 20,
            ),
          ),
        ],
      ),
    );
  }
}
