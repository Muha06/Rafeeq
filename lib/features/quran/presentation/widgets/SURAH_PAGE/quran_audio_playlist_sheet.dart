import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/play_surah_btn.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/core/widgets/app_sliver_stichy_header.dart';

class QuranAudioPlaylistSheet extends ConsumerStatefulWidget {
  const QuranAudioPlaylistSheet({super.key});

  @override
  ConsumerState<QuranAudioPlaylistSheet> createState() =>
      _QuranAudioPlaylistSheetState();
}

class _QuranAudioPlaylistSheetState
    extends ConsumerState<QuranAudioPlaylistSheet> {
  @override
  Widget build(BuildContext context) {
    final surahs = ref.watch(surahsProvider).value ?? [];

    return DraggableScrollableSheet(
      minChildSize: 0.5,
      initialChildSize: 0.5,
      maxChildSize: 1,
      expand: false,
      builder: (context, scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            const SliverPersistentHeader(
              pinned: true,
              delegate: AppSliverPinnedHeaderDelegate(
                height: 100,
                child: _QueueHeader(),
              ),
            ),

            SliverList.separated(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                return QuranAudioPlaylistTile(surah: surahs[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ],
        );
      },
    );
  }
}

class _QueueHeader extends StatelessWidget {
  const _QueueHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.bottomSheetTheme.backgroundColor,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const AppDragHandle(margin: EdgeInsets.only(top: 8)),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Queue',
              style: theme.textTheme.titleMedium?.copyWith(
                fontFamily: AppStrings.displayFont,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Align(
            alignment: Alignment.centerLeft,
            child: _PlayingSurahIndicator(),
          ),

          const SizedBox(height: 16),
        ],
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

    return AppPressableScale(
      child: ListTile(
        onTap: () async {
          final isCurrent =
              ref.read(audioControllerProvider).currentId ==
              '${ref.read(selectedReciterProvider).id}:${surah.id}';

          if (isCurrent) return;

          final ctrl = ref.read(audioControllerProvider.notifier);

          await ctrl.skipToIndex(surah.id - 1);
        },
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        leading: SizedBox(
          width: 28,
          child: Text(
            surah.id.toString(),
            style: tt.labelSmall,
            textAlign: TextAlign.end,
          ),
        ),
        title: Text(
          surah.nameTransliteration,
          style: tt.labelLarge?.copyWith(
            color: isPlaying ? Colors.green : null,
            fontWeight: isPlaying ? FontWeight.bold : null,
          ),
        ),
        subtitle: Text(surah.nameEnglish),
        trailing: isPlaying
            ? PlayFullSurahBtn(
                initialIndex: surah.id - 1,
                builder: (isBuffering, isLoading, isPlaying) =>
                    (isLoading || isBuffering)
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : SizedBox(
                        height: 32,
                        width: 32,
                        child: Icon(
                          isPlaying
                              ? HugeIconsSolid.pause
                              : HugeIconsSolid.play,
                        ),
                      ),
              )
            : null,
      ),
    );
  }
}
