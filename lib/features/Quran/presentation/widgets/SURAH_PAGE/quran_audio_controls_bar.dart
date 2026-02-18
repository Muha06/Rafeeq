import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/providers/just_audio_player_provider.dart';
import 'package:rafeeq/features/quran/domain/entities/surah.dart';
import 'package:rafeeq/features/quran/presentation/riverpod/show_audio_controls_bar_provider.dart';
import 'package:rafeeq/features/quran_audio/presentation/providers/reciters_provider.dart';

class QuranAudioControlsBar extends ConsumerWidget {
  const QuranAudioControlsBar({super.key, required this.surah});
  final Surah surah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final buffering = ref.watch(audioBufferingProvider).value ?? false;
    final isPlaying = ref.watch(audioPlayingProvider).value ?? false;
    final audio = ref.watch(audioControllerProvider);

    final hasActive = audio.url != null;
    final showPause = hasActive && isPlaying;

    final ctrl = ref.read(audioControllerProvider.notifier);

    final selectedReciter = ref.watch(selectedReciterProvider);

    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        decoration: BoxDecoration(color: cs.surface),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            /// Surah Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.nameTransliteration,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedReciter.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            /// Play / Pause Button
            GestureDetector(
              onTap: buffering
                  ? null
                  : () => showPause ? ctrl.pause() : ctrl.resume(),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cs.surfaceContainerHighest,
                ),
                child: Icon(
                  showPause ? PhosphorIcons.pause() : PhosphorIcons.play(),
                  size: 26,
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// Close Button
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: cs.surfaceContainerHighest,
              ),
              child: IconButton(
                onPressed: () async {
                  // stop + close
                  await ctrl.stop();
                  //hide bar
                  ref.read(showControlsProvider.notifier).state = false;
                },
                icon: Icon(PhosphorIcons.x(), color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
