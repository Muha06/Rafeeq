import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rafeeq/features/quran/domain/entities/surah_info.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SurahInfoSheet extends StatelessWidget {
  const SurahInfoSheet({super.key, required this.info});

  final SurahInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final bMedium = tt.bodyMedium;
    final tMedium = tt.titleMedium;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: .9,
        minChildSize: .5,
        maxChildSize: .95,
        builder: (context, controller) {
          return SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline_rounded, color: cs.primary),
                    const SizedBox(width: 10),
                    Text(
                      'About this Surah',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text(info.surahName, style: theme.textTheme.titleMedium),

                if (info.shortText.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    info.shortText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      // color: cs.onSurfaceVariant,
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 8),

                Html(
                  data: info.text,
                  style: {
                    "h2": Style(
                      fontSize: FontSize(tMedium?.fontSize ?? 22),
                      fontWeight: tMedium?.fontWeight,
                      margin: Margins.only(top: 20, bottom: 10),
                    ),
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(bMedium?.fontSize ?? 22),
                      fontWeight: bMedium?.fontWeight,
                      lineHeight: const LineHeight(1.8),
                    ),
                    "p": Style(margin: Margins.only(bottom: 18)),
                  },
                ),
              ],
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
