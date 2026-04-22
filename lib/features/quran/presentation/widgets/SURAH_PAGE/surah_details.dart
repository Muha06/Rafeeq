import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';

class SurahDetails extends ConsumerWidget {
  const SurahDetails({super.key, required this.surah, required this.isDark});

  final Surah surah;
  final bool isDark;

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

class _SurahBriefDetailsCard extends StatelessWidget {
  const _SurahBriefDetailsCard({required this.surah});
  final Surah surah;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final place = surah.isMeccan ? 'Makkah' : 'Madinah';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Arabic name (hero)
              Text(
                surah.nameArabic,
                style: AppTextStyles.arabicUi.copyWith(color: cs.onPrimary),
              ),

              const SizedBox(height: 4),

              // English name (secondary)
              Text(
                surah.nameEnglish,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: cs.onPrimary,
                ),
              ),

              const SizedBox(height: 14),

              // metadata row (clean + subtle)
              _Chip(text: '$place • ${surah.versesCount} verses'),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayFullSurahBtn extends ConsumerWidget {
  const PlayFullSurahBtn({super.key, required this.onPlay});

  final VoidCallback onPlay;
  @override
  Widget build(BuildContext context, ref) {
    final audioState = ref.watch(audioControllerProvider);
    final isBuffering = audioState.isBuffering;

    return OutlinedButton.icon(
      icon: isBuffering
          ? const SizedBox(height: 12, child: CupertinoActivityIndicator())
          : Icon(PhosphorIcons.playCircle()),
      onPressed: onPlay,

      label: Text(isBuffering ? 'Loading...' : 'Play surah'),
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
