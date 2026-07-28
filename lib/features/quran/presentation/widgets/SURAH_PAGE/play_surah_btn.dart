import 'package:flutter/material.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/fetch_surahs_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/show_audio_controls_bar_provider.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/reciter_entity.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/wiring_providers.dart';
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
  const PlayFullSurahBtn({super.key, required this.initialIndex});

  final int initialIndex;

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
      final isNewTrack = state.currentId != audioId;

      try {
        if (!isNewTrack) {
          if (isPlaying) {
            await ctrl.stop();
          } else {
            await ctrl.play();
          }
        } else {
          setState(() {
            _isLoading = true;
          });

          final tracks = await ref
              .read(getSurahAudioTrackUseCaseProvider)
              .call(reciter: reciter);

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

          debugPrint("Loading playlist...");

          ctrl.loadPlaylist(
            items: audioItems,
            initialIndex: widget.initialIndex,
          );

          debugPrint("Playlist loaded");
        }

        ref.read(showAudioControlsProvider.notifier).state = true;
      } catch (e, st) {
        debugPrint('Error playing surah audio: $e');
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

    final surah = surahs[widget.initialIndex];
    if (surahs.length <= widget.initialIndex) {
      return const SizedBox.shrink();
    }

    return TextButton.icon(
      icon: (isBuffering || _isLoading)
          ? const SizedBox(height: 12, child: CupertinoActivityIndicator())
          : isPlaying
          ? const Icon(HugeIconsStroke.stop)
          : const Icon(PhosphorIcons.playCircle),
      onPressed: () async {
        if (isBuffering || _isLoading) return;

        if (isPlaying) {
          ref.read(audioControllerProvider.notifier).stop();
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
            : isPlaying
            ? 'Stop'
            : 'Play surah',
      ),
    );
  }
}
