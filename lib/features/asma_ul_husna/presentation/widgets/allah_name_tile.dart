import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/constants/strings/app_strings.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_item.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_source_type.dart';
import 'package:rafeeq/core/features/audio/presentation/providers/audio_controller.dart';
import 'package:rafeeq/core/helpers/app_sheets.dart';
import 'package:rafeeq/core/helpers/app_text_style.dart';
import 'package:rafeeq/core/helpers/app_toast.dart';
import 'package:rafeeq/core/helpers/firebase_analytics/rafeeq_analytics.dart';
import 'package:rafeeq/core/widgets/app_icon_container.dart';
import 'package:rafeeq/core/widgets/app_pressable.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/name_entity.dart';
import 'package:rafeeq/features/asma_ul_husna/domain/entities/translations_enum.dart';
import 'package:rafeeq/features/asma_ul_husna/presentation/widgets/name_details_sheet.dart';

class AllahNameTile extends ConsumerWidget {
  final AllahName name;

  const AllahNameTile({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    final translation = name.translations[AllahNameLanguage.english];

    if (translation == null) {
      return const SizedBox.shrink();
    }

    return AppPressableScale(
      scale: 0.97,
      onTap: () {
        AppSheets.showBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: false,
          child: AllahNameDetailsSheet(name: name),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _NumberBadge(number: name.number),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arabic
                  Text(
                    name.arabic,
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.arabicUi.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Transliteration
                  Text(
                    name.transliteration,
                    style: tt.titleSmall?.copyWith(
                      fontFamily: AppStrings.displayFont,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Meaning
                  Text(
                    translation.meaning,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: tt.labelSmall,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Play
            PlayAllahNameButton(name: name),
          ],
        ),
      ).animate(delay: 50.ms).fadeIn(duration: 200.ms, curve: Curves.easeOut),
    );
  }
}

class _NumberBadge extends ConsumerWidget {
  final int number;
  const _NumberBadge({required this.number});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AppIconContainer(
      backgroundColor: cs.surfaceContainerHigh,
      borderRadius: 14,
      size: 32,
      child: Text('$number', style: theme.textTheme.titleSmall),
    );
  }
}

class PlayAllahNameButton extends ConsumerWidget {
  final AllahName name;

  const PlayAllahNameButton({super.key, required this.name});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final audioState = ref.watch(audioControllerProvider);
    final audioCtrl = ref.read(audioControllerProvider.notifier);

    final itemId = name.id;
    final isCurrent = audioState.currentId == itemId;

    final isPlaying = audioState.isPlaying && isCurrent;
    debugPrint("Isplaying: $isPlaying");

    final isBuffering = audioState.isBuffering && isCurrent;

    return SizedBox(
      height: 48,
      width: 48,
      child: Material(
        color: theme.colorScheme.primaryContainer,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () async {
            try {
              final item = AudioItem(
                id: name.id,
                title: name.transliteration,
                sourceType: AudioSourceType.allahName,
                url: name.audioUrl,
              );

              await audioCtrl.togglePlay(item: item);

              if (!isPlaying) {
                RafeeqAnalytics.logFeature('play_Allah_name_audio');
              }
            } catch (e) {
              AppToast.showError(
                context: context,
                message: "Failed to play audio. Please try again later.",
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(11),
            child: isBuffering
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CupertinoActivityIndicator(),
                  )
                : Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 22,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
          ),
        ),
      ),
    );
  }
}
