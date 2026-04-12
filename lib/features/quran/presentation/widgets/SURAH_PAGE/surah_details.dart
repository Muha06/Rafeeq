import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';

class SurahDetails extends ConsumerWidget {
  const SurahDetails({super.key, required this.surah, required this.isDark});

  final Surah surah;
  final bool isDark;

  @override
  Widget build(BuildContext context, ref) {
    final place = surah.isMeccan ? 'Makkah' : 'Madinah';
    final isMakkan = surah.isMeccan;

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16,
              ),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.nameArabic,
                        style: theme.textTheme.labelLarge!.copyWith(
                          fontSize: 20,
                          color: cs.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        surah.nameEnglish,
                        maxLines: 2,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: cs.onPrimary,
                        ),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          _Chip(text: '#${surah.id}'),
                          const SizedBox(width: 8),
                          _Chip(text: '$place • ${surah.versesCount} verses'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: isMakkan ? 36 : 35,
              right: 20,
              child: Image.asset(
                isMakkan
                    ? 'assets/images/quran/makkan.png'
                    : 'assets/images/quran/madinan.png',
                height: 120,
                width: 120,
              ),
            ),
          ],
        ),
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
