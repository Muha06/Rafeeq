import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:rafeeq/core/constants/app_assets.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/translations_enum.dart';

class AllahNameShareCard extends StatelessWidget {
  const AllahNameShareCard({
    super.key,
    required this.name,
    this.language = AllahNameLanguage.english, // adjust to your enum
  });

  final AllahName name;
  final AllahNameLanguage language;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final scheme = theme.colorScheme;
    final tertiary = Theme.of(context).colorScheme.tertiary;

    final base = scheme.surfaceContainerLow;
    final onBase = scheme.onSurface;
    final deep = Color.lerp(base, Colors.black, 0.45)!;

    final translation =
        name.translations[language] ?? name.translations.values.firstOrNull;
    final meaning = translation?.meaning ?? ''; // <- adjust field name

    return SizedBox(
      width: 540,
      height: 720,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [base, deep],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Pattern
            CustomPaint(
              painter: _StarPatternPainter(
                color: onBase.withValues(alpha: 0.06),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(44, 44, 44, 44),
              child: Column(
                children: [
                  _Header(number: name.number, color: onBase),
                  const Spacer(flex: 2),

                  // Arabic
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        name.arabic,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.arabicUi.copyWith(
                          color: tertiary,
                          fontSize: 120,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    name.transliteration,
                    textAlign: TextAlign.center,
                    style: tt.titleMedium?.copyWith(
                      fontSize: 30,
                      color: onBase,
                    ),
                  ),
                  const SizedBox(height: 24),

                  _OrnamentDivider(color: tertiary),

                  const SizedBox(height: 24),
                  if (meaning.isNotEmpty)
                    Text(
                      meaning,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: tt.bodyLarge?.copyWith(
                        fontSize: 24,
                        color: onBase.withValues(alpha: 0.95),
                      ),
                    ),
                  const Spacer(flex: 3),
                  _Footer(color: onBase),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.number, required this.color});
  final int number;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Asma ul Husna',
          style: tt.labelLarge?.copyWith(
            fontSize: 18,
            color: color.withValues(alpha: 0.75),
          ),
        ),

        Text(
          '${number.toString().padLeft(2, '0')} / 99',
          style: tt.titleMedium?.copyWith(color: color, fontSize: 18),
        ),
      ],
    );
  }
}

class _OrnamentDivider extends StatelessWidget {
  const _OrnamentDivider({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    Widget line() => Expanded(
      child: Container(height: 1, color: color.withValues(alpha: 0.5)),
    );

    return Row(
      children: [
        const SizedBox(width: 40),
        line(),
        const SizedBox(width: 12),
        Transform.rotate(
          angle: math.pi / 4,
          child: Container(width: 10, height: 10, color: color),
        ),
        const SizedBox(width: 12),
        line(),
        const SizedBox(width: 40),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(AppAssets.appIcon, height: 30, width: 30),
            ),

            const SizedBox(width: 8),

            Text(
              'Rafeeq',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: color,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),
        Text(
          'Your Islamic companion',
          style: TextStyle(fontSize: 14, color: color.withValues(alpha: 0.6)),
        ),
      ],
    );
  }
}

/// Tiled 8-point star (two overlapping squares).
class _StarPatternPainter extends CustomPainter {
  _StarPatternPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const cell = 72.0;
    const r = cell * 0.36;

    for (double y = 0; y <= size.height + cell; y += cell) {
      for (double x = 0; x <= size.width + cell; x += cell) {
        final c = Offset(x, y);
        canvas.drawRect(Rect.fromCircle(center: c, radius: r), paint);

        canvas.save();
        canvas.translate(c.dx, c.dy);
        canvas.rotate(math.pi / 4);
        canvas.drawRect(Rect.fromCircle(center: Offset.zero, radius: r), paint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarPatternPainter old) => old.color != color;
}
