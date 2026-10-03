import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rafeeq/core/helpers/app_nav.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/quran/domain/entities/surah_info.dart';
import 'package:rafeeq/features/quran/presentation/pages/surah_page.dart';

class SurahInfoSheet extends StatelessWidget {
  const SurahInfoSheet({super.key, required this.info});

  final SurahInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    debugPrint(info.text);

    return DraggableScrollableSheet(
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

                HtmlWidget(
                  info.text,
                  onTapUrl: (url) {
                    final uri = Uri.tryParse(url);
                    final segments = uri == null
                        ? const <String>[]
                        : uri.pathSegments
                              .where((segment) => segment.isNotEmpty)
                              .toList();

                    if (segments.length < 2) return false;

                    final surahNumber = int.tryParse(segments[0]);
                    final startAyah = int.tryParse(
                      segments[1].split('-').first,
                    );

                    if (surahNumber == null || startAyah == null) return false;

                    AppNav.pop(context);

                    AppNav.push(
                      context,
                      FullSurahPage(
                        initialIndex: surahNumber - 1,
                        autoScrollAyah: startAyah,
                      ),
                    );

                    return true;
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
