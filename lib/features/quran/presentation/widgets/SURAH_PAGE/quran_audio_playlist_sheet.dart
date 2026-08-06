import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/core/widgets/scroll_fade_mask.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/play_surah_btn.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';

class QuranAudioPlaylistSheet extends StatefulWidget {
  const QuranAudioPlaylistSheet({super.key});

  @override
  State<QuranAudioPlaylistSheet> createState() =>
      _QuranAudioPlaylistSheetState();
}

class _QuranAudioPlaylistSheetState extends State<QuranAudioPlaylistSheet> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppDragHandle(margin: EdgeInsets.only(top: 8)),
            const SizedBox(height: 4),

            // Text: Queue
            Text(
              'Queue',
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'PlayFairDisplay',
              ),
            ),
            const SizedBox(height: 12),

            const _PlayingSurahIndicator(),
            const SizedBox(height: 16),

            // List of queued items
            const Expanded(child: QuranAudioPlaylist()),
          ],
        ),
      ),
    );
  }
}

class QuranAudioPlaylist extends ConsumerWidget {
  const QuranAudioPlaylist({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final surahs = ref.watch(surahsProvider).value ?? [];

    return ScrollFadeMask(
      showTop: false,
      child: ListView.separated(
        scrollCacheExtent: const ScrollCacheExtent.pixels(164),
        clipBehavior: Clip.hardEdge,
        separatorBuilder: (context, i) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: Divider(height: 12),
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: surahs.length,
        itemBuilder: (context, i) {
          final surah = surahs[i];

          return QuranAudioPlaylistTile(surah: surah);
        },
      ),
    );
  }
}

class _PlayingSurahIndicator extends ConsumerWidget {
  const _PlayingSurahIndicator({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final playingTitle = ref.watch(audioControllerProvider).title;

    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'Now Playing:  ', style: tt.labelMedium),
          TextSpan(text: playingTitle, style: tt.labelLarge),
        ],
      ),
    );
  }
}

class QuranAudioPlaylistTile extends ConsumerWidget {
  const QuranAudioPlaylistTile({super.key, required this.surah});
  final Surah surah;

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    final playingTitle = ref.watch(
      audioControllerProvider.select((s) => s.title),
    );
    final isPlaying = playingTitle == "Surat ${surah.nameTransliteration}";
    debugPrint("rebuilt");

    return GestureDetector(
      onTap: () async {
        final isCurrent =
            ref.read(audioControllerProvider).currentId ==
            '${ref.read(selectedReciterProvider).id}:${surah.id}';

        if (isCurrent) return;

        final ctrl = ref.read(audioControllerProvider.notifier);

        await ctrl.skipToIndex(surah.id - 1);
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 28,
            child: Center(
              child: Text(
                surah.id.toString(),
                style: tt.labelSmall,
                textAlign: TextAlign.end,
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah.nameTransliteration,
                  style: tt.labelLarge?.copyWith(
                    color: isPlaying ? Colors.green : null,
                  ),
                ),
                const SizedBox(height: 2),

                Text(surah.nameEnglish, style: tt.labelMedium),
              ],
            ),
          ),

          if (isPlaying)
            Center(
              child: PlayFullSurahBtn(
                initialIndex: surah.id - 1,
                builder: (isBuffering, isLoading, isPlaying) =>
                    (isLoading || isBuffering)
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        isPlaying ? HugeIconsSolid.pause : HugeIconsSolid.play,
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
