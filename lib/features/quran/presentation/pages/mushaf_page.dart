import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:riverpod/legacy.dart';

// Track the currently highlighted ayah
final highlightedAyahProvider = StateProvider<int?>((ref) {
  debugPrint("Highlighted");
  return null;
});

String cleanAyahText(String ayah, int surahId) {
  // Remove Basmala if not Surah 1
  String cleaned = (ayah.contains('بِسْمِ اللَّهِ') && surahId != 1)
      ? ayah.replaceFirst(
          RegExp(r'بِسْمِ اللَّهِ الرَّحْم[^\s]*نِ الرَّحِيمِ'),
          '',
        )
      : ayah;

  // Remove extra symbols
  cleaned = cleaned.replaceAll('۝', '').trim();
  return cleaned;
}

class MushafPageUI extends ConsumerWidget {
  final List<String> versesList;
  final int page;
  final Surah surah;
  const MushafPageUI({
    super.key,
    required this.versesList,
    required this.page,
    required this.surah,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlightedAyah = ref.watch(highlightedAyahProvider);
    final cs = Theme.of(context).colorScheme;

    final fontSize = ref.watch(surahSettingsProvider).arabicFontSize;

    final theme = Theme.of(context);

    final baseStyle = AppTextStyles.quranAyah.copyWith(
      color: cs.onSurface,
      fontSize: fontSize,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: RichText(
              textAlign: TextAlign.justify,
              textDirection: TextDirection.rtl,
              text: TextSpan(
                style: baseStyle,
                children: [
                  for (var v in versesList) ...[
                    TextSpan(
                      text: cleanAyahText(v, surah.id),
                      style: baseStyle.copyWith(
                        backgroundColor:
                            highlightedAyah != null &&
                                v.contains('($highlightedAyah)')
                            ? Colors.yellow.withAlpha(60)
                            : null,
                      ),
                      recognizer: LongPressGestureRecognizer()
                        ..onLongPress = () {
                          final match = RegExp(
                            r'\((\d+)\)',
                          ).firstMatch(v)?.group(1);

                          if (match != null) {
                            ref.read(highlightedAyahProvider.notifier).state =
                                int.parse(match);

                            debugPrint("Dne: $match");
                          }
                        },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),

          ...[
            Text('Page $page', style: theme.textTheme.labelMedium),
            const Divider(),
          ],
        ],
      ),
    );
  }
}
