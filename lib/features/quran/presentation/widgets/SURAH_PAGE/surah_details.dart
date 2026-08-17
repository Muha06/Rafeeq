import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_details_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_info_sheet.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class SurahDetails extends ConsumerWidget {
  const SurahDetails({super.key, required this.surah});

  final Surah surah;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        _SurahBriefDetailsCard(surah: surah),

        const SizedBox(height: 8),

        //Bismillah
        if (surah.id != 9) ...[
          Image.asset(
            'assets/images/quran/bismillah.png',
            color: cs.onSurface,
            height: 60,
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _SurahBriefDetailsCard extends ConsumerWidget {
  const _SurahBriefDetailsCard({required this.surah});
  final Surah surah;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final place = surah.isMeccan ? 'Makkah' : 'Madinah';

    Future<void> openSurahInfoSheet() async {
      final info = await ref.read(surahInfoProvider(surah.id).future);

      if (!context.mounted || info == null) return;

      Navigator.of(context).push(
        ModalBottomSheetRoute(
          isScrollControlled: true,
          sheetAnimationStyle: const AnimationStyle(
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
            duration: Duration(milliseconds: 400),
            reverseDuration: Duration(milliseconds: 300),
          ),
          builder: (context) {
            return SurahInfoSheet(info: info);
          },
        ),
      );
    }

    return GestureDetector(
      onTap: openSurahInfoSheet,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    surah.nameEnglish,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: cs.onPrimary,
                    ),
                  ),
                ),

                IconButton(
                  icon: Icon(
                    HugeIconsStroke.informationCircle,
                    color: cs.onPrimary,
                  ),
                  visualDensity: VisualDensity.compact,
                  onPressed: openSurahInfoSheet,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  surah.nameArabic,
                  style: AppTextStyles.arabicUi.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                const Spacer(),

                _Chip(text: '$place  •  ${surah.versesCount} verses'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends ConsumerWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.onPrimary.withAlpha(100)),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall!.copyWith(color: cs.onPrimary),
      ),
    );
  }
}
