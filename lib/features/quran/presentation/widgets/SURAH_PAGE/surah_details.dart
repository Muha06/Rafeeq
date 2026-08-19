import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/play_surah_btn.dart';

class BasmallaPlayBtnColumn extends ConsumerWidget {
  const BasmallaPlayBtnColumn({
    super.key,
    required this.surah,
    required this.initialIndex,
  });

  final Surah surah;
  final int initialIndex;
  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: _SurahDetails(surah: surah),
        ),

        const SizedBox(height: 12),

        //Bismillah
        if (surah.id != 9) ...[
          Image.asset(
            'assets/images/quran/bismillah.png',
            color: cs.onSurface,
            height: 60,
          ),
          const SizedBox(height: 8),
        ],

        const SizedBox(height: 8),
        PlayFullSurahBtn(initialIndex: initialIndex),
      ],
    );
  }
}

class _SurahDetails extends StatelessWidget {
  const _SurahDetails({super.key, required this.surah});
  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cs = theme.colorScheme;

    final style = tt.labelMedium?.copyWith(color: cs.onSurface);

    return Container(
      padding: const EdgeInsets.all(6),
      height: 40,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          // surah name
          Text(surah.nameTransliteration, style: style),

          const SizedBox(width: 8),
          const Text("|"),
          const SizedBox(width: 8),

          //revealed place
          Text(surah.isMeccan ? "🕋 Mekkah" : "🕌 Madinah", style: style),

          const SizedBox(width: 8),
          const Text("|"),
          const SizedBox(width: 8),

          Text("${surah.versesCount} ayahs", style: style),
        ],
      ),
    );
  }
}
