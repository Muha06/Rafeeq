import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_item.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/themes/app_text_style.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/show_audio_controls_bar_provider.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/surah_details_provider.dart';
import 'package:rafeeq/features/quran/presentation/widgets/SURAH_PAGE/surah_info_sheet.dart';
import 'package:rafeeq/features/quran_audio/domain/entities/reciter_entity.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/surah_audio_providers.dart';
import 'package:rafeeq/features/quran_audio/presentation/widgets/reciter_picker_sheet.dart';
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  style: theme.textTheme.labelLarge?.copyWith(
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
                onPressed: () async {
                  final info = await ref.read(
                    surahInfoProvider(surah.id).future,
                  );

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
                },
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
    );
  }
}

class PlayFullSurahBtn extends ConsumerWidget {
  const PlayFullSurahBtn({super.key, required this.surah});

  final Surah surah;
  @override
  Widget build(BuildContext context, ref) {
    Future<void> playSurahAudio({
      required WidgetRef ref,
      required int surahId,
      required String surahName,
    }) async {
      final reciter = ref.read(selectedReciterProvider);

      final audioId = '${surahId}_${reciter.id}';

      try {
        final surahTrack = await ref
            .read(getSurahAudioTrackUseCaseProvider)
            .call(surahId: surahId, surahName: surahName, reciter: reciter);

        //show controls
        ref.read(showAudioControlsProvider.notifier).state = true;

        final item = AudioItem(
          id: audioId,
          title: surahTrack.surahName,
          sourceType: AudioSourceType.quranSurah,
          imageUrl: null,
          artist: reciter.name,
          url: surahTrack.url,
        );

        await ref.read(audioControllerProvider.notifier).togglePlay(item: item);
      } catch (e) {
        debugPrint("Error playng : $e");
        if (!context.mounted) return;

        AppToast.showError(context: context, message: "Something went wrong");
      }
    }

    final audioState = ref.watch(audioControllerProvider);
    final isBuffering = audioState.isBuffering;

    return TextButton.icon(
      icon: isBuffering
          ? const SizedBox(height: 12, child: CupertinoActivityIndicator())
          : const Icon(PhosphorIcons.playCircle),
      onPressed: () async {
        //select reciter
        final reciter = await AppSheets.showBottomSheet<ReciterEntity?>(
          context: context,
          child: const ReciterPickerSheet(),
        );

        if (reciter == null) return;

        await playSurahAudio(
          ref: ref,
          surahId: surah.id,
          surahName: surah.nameTransliteration,
        );

        await RafeeqAnalytics.logFeature("Play-surah-audio");
      },

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
