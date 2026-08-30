import 'package:flutter/material.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_settings_provider.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/reciter_entity.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/get_surah_tracks_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/widgets/reciter_picker_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_item.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';

class PlayFullSurahBtn extends ConsumerStatefulWidget {
  const PlayFullSurahBtn({super.key, required this.initialIndex, this.builder});

  final int initialIndex;
  final Widget Function(bool isBuffering, bool isLoading, bool isPlaying)?
  builder;

  @override
  ConsumerState<PlayFullSurahBtn> createState() => _PlayFullSurahBtnState();
}

class _PlayFullSurahBtnState extends ConsumerState<PlayFullSurahBtn> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  List<Surah> get surahs => ref.read(surahsProvider).value ?? [];

  @override
  Widget build(BuildContext context) {
    Future<void> playSurahAudio({required Surah surah}) async {
      if (surahs.isEmpty) return;

      final reciter = ref.read(selectedReciterProvider);
      final audioId = '${reciter.id}:${surah.id}';

      final state = ref.read(audioControllerProvider);
      final ctrl = ref.read(audioControllerProvider.notifier);

      final isPlaying = state.isPlaying;
      final isSameTrack = state.currentId == audioId;

      try {
        if (isSameTrack) {
          if (isPlaying) {
            await ctrl.pause();
          } else {
            await ctrl.play();
          }
        } else {
          setState(() {
            _isLoading = true;
          });

          final tracks = await ref.read(surahTracksProvider(reciter).future);

          final audioItems = tracks
              .map(
                (t) => AudioItem(
                  id: '${t.reciterId}:${t.surahId}',
                  title: "Surat ${t.surahName}",
                  artist: reciter.name,
                  url: t.url,
                  sourceType: AudioSourceType.quranSurah,
                ),
              )
              .toList();

          ctrl.loadPlaylist(
            items: audioItems,
            initialIndex: widget.initialIndex,
          );
        }

        ref.read(surahSettingsProvider.notifier).showAudioControls(true);
      } catch (e, st) {
        debugPrintStack(stackTrace: st);

        if (!context.mounted) return;

        AppToast.showError(context: context, message: 'Something went wrong');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    final audioState = ref.watch(audioControllerProvider);
    final isBuffering = audioState.isBuffering;
    final isPlaying = audioState.isPlaying;
    final sourceType = audioState.sourceType;

    if (surahs.length <= widget.initialIndex) {
      return const SizedBox.shrink();
    }

    final surah = surahs[widget.initialIndex];

    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (widget.builder != null) {
      return AppPressableScale(
        onTap: () => playSurahAudio(surah: surah),
        child: widget.builder!(isBuffering, _isLoading, isPlaying),
      );
    }

    return AppPressableScale(
      scale: 0.8,
      child: TextButton.icon(
        icon: (isBuffering || _isLoading)
            ? const SizedBox(
                height: 12,
                width: 12,
                child: CupertinoActivityIndicator(),
              )
            : (isPlaying && sourceType == AudioSourceType.quranSurah)
            ? const Icon(HugeIconsStroke.stop)
            : const Icon(PhosphorIcons.playCircle),
        onPressed: () async {
          if (isBuffering || _isLoading) return;

          if (isPlaying) {
            await ref.read(audioControllerProvider.notifier).pause();
            return;
          }

          //select reciter
          final reciter = await AppSheets.showBottomSheet<ReciterEntity?>(
            context: context,
            child: const ReciterPickerSheet(),
          );

          if (reciter == null) return;

          await playSurahAudio(surah: surah);

          await RafeeqAnalytics.logFeature("Play-surah-audio");
        },

        label: Text(
          isBuffering
              ? 'Loading...'
              : _isLoading
              ? 'Downloading surah tracks...'
              : (isPlaying && sourceType == AudioSourceType.quranSurah)
              ? 'Stop'
              : 'Play surah',
          style: theme.textButtonTheme.style?.textStyle
              ?.resolve({})
              ?.copyWith(
                color: _isLoading || isBuffering ? cs.onSurfaceVariant : null,
              ),
        ),
      ),
    );
  }
}
