import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/app_assets.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/features/quran/domain/entities/ayah.dart';

class AyahShareCard extends StatelessWidget {
  final Ayah ayah;
  final String surahName;

  const AyahShareCard({super.key, required this.ayah, required this.surahName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      width: 1080,
      decoration: BoxDecoration(color: colorScheme.surfaceContainerLowest),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Surah and ayah reference.
            Text(
              '$surahName · ${ayah.surahId}:${ayah.ayahNumber}',
              textAlign: TextAlign.center,
              style: tt.labelLarge?.copyWith(color: colorScheme.onSurface),
            ),

            const SizedBox(height: 36),

            // Arabic ayah.
            SizedBox(
              width: double.infinity,
              child: Text(
                ayah.textArabic,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                softWrap: true,
                style: AppTextStyles.quranAyah.copyWith(
                  fontSize: 30,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 36),

            // English translation.
            // Text(
            //   ayah.textEnglish,
            //   textAlign: TextAlign.center,
            //   style: tt.bodyMedium?.copyWith(
            //     fontSize: 24,
            //     color: colorScheme.onSurface,
            //   ),
            // ),
            SizedBox(
              width: double.infinity,
              child: Text(
                ayah.textEnglish,
                textAlign: TextAlign.center,
                softWrap: true,
                style: tt.bodyMedium?.copyWith(
                  fontSize: 24,
                  height: 1.6,
                  color: colorScheme.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 44),

            // Rafeeq logo.
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                AppAssets.appIcon,
                width: 48,
                height: 48,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Shared from Rafeeq',
              textAlign: TextAlign.center,
              style: tt.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
