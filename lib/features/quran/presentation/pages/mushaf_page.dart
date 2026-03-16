import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/current_reading_provider.dart';
import 'package:riverpod/legacy.dart';

// Track the currently highlighted ayah
final highlightedAyahProvider = StateProvider<int?>((ref) => null);



class MushafPageUI extends ConsumerWidget {
  final int pageNumber;
  const MushafPageUI({super.key, required this.pageNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlightedAyah = ref.watch(highlightedAyahProvider);
    final versesList = ref.watch(pageVersesProvider);

    final baseStyle = AppTextStyles.quranAyah.copyWith(
      fontSize: 32,
      height: 1.6,
      color: Colors.black,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: RichText(
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
          text: TextSpan(
            style: baseStyle,
            children: [
              for (var v in versesList) ...[
                TextSpan(
                  text: '$v ',
                  style: baseStyle.copyWith(
                    backgroundColor:
                        highlightedAyah != null &&
                            v.contains('($highlightedAyah)')
                        ? Colors.yellow.withOpacity(0.3)
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
                      }
                    },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
