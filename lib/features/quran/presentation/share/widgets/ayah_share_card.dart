import 'package:flutter/material.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/core/widgets/share_image_widgets.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';

class AyahShareCard extends StatelessWidget {
  final Ayah ayah;
  final String surahName;

  const AyahShareCard({super.key, required this.ayah, required this.surahName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    final onBase = cs.onSurface;
    final gold = cs.tertiary;

    return Container(
      width: 540,
      color: cs.surfaceContainerLowest,
      child: Stack(
        children: [
          // Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: StarPatternPainter(
                color: onBase.withValues(alpha: 0.04),
              ),
            ),
          ),

          // Content (sets the card height)
          Padding(
            padding: const EdgeInsets.all(44),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Qur\'an',
                      style: tt.labelLarge?.copyWith(
                        fontSize: 18,
                        color: onBase.withValues(alpha: 0.75),
                      ),
                    ),
                    Text(
                      '${ayah.surahId}:${ayah.ayahNumber}',
                      style: tt.titleMedium?.copyWith(
                        fontSize: 18,
                        color: onBase,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 56),

                // Arabic
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    ayah.textArabic,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.quranAyah.copyWith(
                      fontSize: 38,
                      height: 1.9,
                      color: onBase,
                    ),
                  ),
                ),

                const SizedBox(height: 36),
                OrnamentDivider(color: gold),
                const SizedBox(height: 36),

                // Translation
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    ayah.textEnglish,
                    textAlign: TextAlign.center,
                    style: tt.bodyMedium?.copyWith(
                      fontSize: 22,
                      height: 1.6,
                      color: onBase.withValues(alpha: 0.9),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Reference
                Text(
                  surahName,
                  textAlign: TextAlign.center,
                  style: tt.titleSmall?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),

                const SizedBox(height: 56),
                ShareCardFooter(color: onBase),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
