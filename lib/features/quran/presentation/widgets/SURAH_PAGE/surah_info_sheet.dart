import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/quran/domain/entities/surah_info.dart';
 
class SurahInfoSheet extends StatelessWidget {
  const SurahInfoSheet({super.key, required this.info});

  final SurahInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final bLarge = tt.bodyLarge;
    final bMedium = tt.bodyMedium;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: .9,
        minChildSize: .5,
        maxChildSize: 1,
        builder: (context, controller) {
          return SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppDragHandle(),

                  const SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline_rounded, color: cs.primary),
                      const SizedBox(width: 10),
                      Text(
                        'About this Surah',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ],
                  ),

                  // Surah short text
                  if (info.shortText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(info.shortText, style: theme.textTheme.bodyLarge),
                  ],

                  Html(
                    data: info.text,
                    style: {
                      "h2": Style(
                        fontSize: FontSize(bMedium?.fontSize ?? 22),
                        fontWeight: bMedium!.fontWeight,
                        color: bMedium.color,
                        margin: Margins.only(top: 20, bottom: 10),
                      ),
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(bLarge?.fontSize ?? 22),
                        fontWeight: bLarge?.fontWeight ?? FontWeight.w400,
                        color: bLarge!.color,
                        lineHeight: LineHeight(bLarge.height),
                        // height: Height(bLarge.height ?? 1.65),
                      ),
                      "p": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(bLarge.fontSize ?? 22),
                        fontWeight: bLarge.fontWeight ?? FontWeight.w400,
                        color: bLarge.color,
                        lineHeight: LineHeight(bLarge.height),
                      ),
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
