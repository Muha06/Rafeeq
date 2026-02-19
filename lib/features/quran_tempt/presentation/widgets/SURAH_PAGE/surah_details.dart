import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/providers/just_audio_player_provider.dart';
import 'package:rafeeq/features/quran_tempt/domain/entities/surah.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class SurahDetails extends ConsumerWidget {
  const SurahDetails({super.key, required this.surah, required this.isDark});

  final Surah surah;
  final bool isDark;

  @override
  Widget build(BuildContext context, ref) {
    final place = surah.isMeccan ? 'Makkah' : 'Madinah';
    final isDark = ref.watch(isDarkProvider);
    final isMakkan = surah.isMeccan;

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.nameArabic,
                        style: theme.textTheme.labelLarge!.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        surah.nameEnglish,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
              right: 24,
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
        Image.asset(
          isDark
              ? 'assets/images/quran/bismillah_dark.png'
              : 'assets/images/quran/bismillah_light.png',
          height: 60,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class PlayFullSurahBtn extends ConsumerWidget {
  const PlayFullSurahBtn({super.key, required this.onPlay});

  final VoidCallback onPlay;
  @override
  Widget build(BuildContext context, ref) {
    final loading = ref.watch(audioBufferingProvider).value;

    return OutlinedButton.icon(
      icon: (loading != null && loading)
          ? const SizedBox(height: 12, child: CupertinoActivityIndicator())
          : const Icon(CupertinoIcons.play),
      onPressed: onPlay,

      label: Text((loading != null && loading) ? 'Loading...' : 'Play surah'),
    );
  }
}

class _Chip extends ConsumerWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
