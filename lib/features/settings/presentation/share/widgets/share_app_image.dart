// features/settings/presentation/share/app_share_card.dart
import 'package:flutter/material.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/app_assets.dart';
import 'package:rafeeq/core/widgets/share_image_widgets.dart';

class AppShareCard extends StatelessWidget {
  const AppShareCard({super.key});

  static const double width = 540;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    final onBase = cs.onSurface;
    final gold = cs.tertiary;

    return Container(
      width: width,
      color: cs.surfaceContainerLowest,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: StarPatternPainter(
                color: onBase.withValues(alpha: 0.04),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(44),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),

                // App icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    AppAssets.appIcon,
                    width: 104,
                    height: 104,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Rafeeq',
                  style: tt.headlineMedium?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                    color: onBase,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your Islamic companion',
                  style: tt.bodyLarge?.copyWith(
                    fontSize: 20,
                    color: onBase.withValues(alpha: 0.65),
                  ),
                ),

                const SizedBox(height: 36),
                OrnamentDivider(color: gold),
                const SizedBox(height: 36),

                // Features
                const Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _FeaturePill(
                      icon: HugeIconsStroke.quran02,
                      label: "Qur'an",
                    ),
                    _FeaturePill(
                      icon: HugeIconsStroke.clock01,
                      label: 'Salah times',
                    ),
                    _FeaturePill(icon: HugeIconsStroke.tasbih, label: 'Adhkār'),
                    _FeaturePill(
                      icon: HugeIconsStroke.compass01,
                      label: 'Qibla',
                    ),
                    _FeaturePill(
                      icon: HugeIconsStroke.liveStreaming01,
                      label: 'Haramain Live',
                    ),
                    _FeaturePill(
                      icon: HugeIconsStroke.radio01,
                      label: 'Quran Radio',
                    ),
                    _FeaturePill(
                      icon: HugeIconsStroke.calendar03,
                      label: 'Hijri Calendar',
                    ),
                    _FeaturePill(
                      icon: HugeIconsStroke.target01,
                      label: 'Quran Goals',
                    ),
                    _FeaturePill(
                      icon: HugeIconsStroke.bookmark01,
                      label: 'Bookmarks',
                    ),
                  ],
                ),

                const SizedBox(height: 36),

                // Hadith
                Text(
                  '“Whoever guides to good will have a reward similar to that of its doer.”',
                  textAlign: TextAlign.center,
                  style: tt.bodyLarge?.copyWith(
                    fontSize: 22,
                    height: 1.55,
                    color: onBase.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Sahih Muslim',
                  style: tt.titleSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),

                const SizedBox(height: 40),

                // Call to action
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Download Rafeeq',
                    style: tt.labelLarge?.copyWith(
                      fontSize: 20,
                      color: cs.onPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: cs.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(fontSize: 16, color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}
