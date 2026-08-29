import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/presentation/widgets/seek_bar.dart';
import 'package:rafeeq/core/helpers/app_haptics.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/widgets/app_drag_handle.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/quran_audio_playlist_sheet.dart';
import 'package:rafeeq/features/quran_radio/presentation/widgets/radio_player_sheet.dart';
import 'package:text_scroll/text_scroll.dart';

class QuranAudioSheet extends ConsumerStatefulWidget {
  const QuranAudioSheet({super.key});

  @override
  ConsumerState<QuranAudioSheet> createState() => _QuranAudioSheetState();
}

class _QuranAudioSheetState extends ConsumerState<QuranAudioSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Image.asset(
                'assets/images/quran/quran.png',
                height: 240,
                width: 240,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: Colors.black87),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                const AppDragHandle(color: Colors.grey),

                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 80, 12, 12),
                  child: Column(
                    children: [
                      // Image
                      Image.asset(
                            'assets/images/quran/quran.png',
                            height: 280,
                            width: 280,
                          )
                          .animate()
                          .fadeIn(duration: 900.ms)
                          .scale(
                            begin: const Offset(1.2, 1.2),
                            end: const Offset(1, 1),
                            curve: Curves.easeOutBack,
                          ),

                      const SizedBox(height: 84),

                      // Surah reciter row
                      const _AudioDetailsRow().animate().fadeIn(
                        duration: 800.ms,
                      ),

                      const SizedBox(height: 16),

                      //Audio seekbar
                      AudioSeekBar(
                        playedTrackColor: Colors.white,
                        bufferedTrackColor: Colors.white.withAlpha(80),
                        baseTrackColor: Colors.white.withAlpha(100),
                        durationColor: Colors.white,
                      ).animate().fadeIn(duration: 800.ms),

                      const SizedBox(height: 32),

                      //Controls
                      const _AudioControls().animate().fadeIn(duration: 800.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioControls extends ConsumerStatefulWidget {
  const _AudioControls({super.key});

  @override
  ConsumerState<_AudioControls> createState() => __AudioControlsState();
}

class __AudioControlsState extends ConsumerState<_AudioControls> {
  Future<void> _togglePlay() async {
    final state = ref.read(audioControllerProvider);
    final ctrl = ref.read(audioControllerProvider.notifier);

    if (state.isPlaying) {
      await ctrl.pause();
    } else {
      await ctrl.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.read(audioControllerProvider.notifier);

    final itemColor = Colors.white;
    final itemColorLight = itemColor.withAlpha(160);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skip prev
        IconButton(
          onPressed: () => ctrl.skipBackward10(),
          icon: Icon(
            HugeIconsStroke.goBackward10Sec,
            size: 36,
            color: itemColorLight,
          ),
        ),

        const SizedBox(width: 16),

        // Previous
        IconButton(
          onPressed: () => ctrl.previous(),
          icon: Icon(HugeIconsSolid.previous, size: 36, color: itemColor),
        ),

        const SizedBox(width: 16),

        AnimatedPlayPauseBtn(
          onPressed: _togglePlay,
          bgColor: itemColor,
          labelColor: Colors.black,
        ),

        const SizedBox(width: 16),

        // Next
        IconButton(
          onPressed: () => ctrl.next(),
          icon: Icon(HugeIconsSolid.next, size: 36, color: itemColor),
        ),

        const SizedBox(width: 16),

        IconButton(
          onPressed: () => ctrl.skipForward10(),
          icon: Icon(
            HugeIconsStroke.goForward10Sec,
            size: 36,
            color: itemColorLight,
          ),
        ),
      ],
    );
  }
}

class _AudioDetailsRow extends ConsumerWidget {
  const _AudioDetailsRow({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final itemColor = Colors.white;

    final title =
        ref.watch(audioControllerProvider.select((state) => state.title)) ??
        'Quran Audio';

    final reciter =
        ref.watch(audioControllerProvider.select((state) => state.artist)) ??
        '-';
    final repeatModeEnabled = ref.watch(
      audioControllerProvider.select((state) => state.isRepeatEnabled),
    );

    final ctrl = ref.read(audioControllerProvider.notifier);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextScroll(
              title,
              mode: TextScrollMode.endless,
              intervalSpaces: 24,
              style: tt.titleLarge?.copyWith(
                fontFamily: AppStrings.displayFont,
                color: itemColor,
              ),
            ),

            const SizedBox(height: 4),

            // Reciter
            TextScroll(
              reciter,
              mode: TextScrollMode.endless,
              style: tt.labelLarge?.copyWith(color: itemColor.withAlpha(160)),
              intervalSpaces: 24,
            ),
          ],
        ),

        const Spacer(),

        // Controls
        Row(
          children: [
            IconButton(
              onPressed: () {
                AppSheets.showBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  clipBehavior: Clip.hardEdge,
                  useSafeArea: false,
                  animationDuration: const Duration(milliseconds: 400),
                  child: const QuranAudioPlaylistSheet(),
                );
              },
              icon: Icon(HugeIconsSolid.playlist03, color: itemColor),
            ),

            const SizedBox(width: 4),

            IconButton(
              onPressed: () {
                AppHaptics.selection();

                ctrl.toggleRepeatMode();

                AppToast.showCompact(
                  context: context,
                  message: repeatModeEnabled
                      ? "Repeat mode disabled"
                      : "Repeat mode enabled",
                );
              },
              color: repeatModeEnabled ? cs.primary : itemColor,
              icon: Icon(
                repeatModeEnabled
                    ? HugeIconsSolid.repeatOff
                    : HugeIconsSolid.repeat,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
