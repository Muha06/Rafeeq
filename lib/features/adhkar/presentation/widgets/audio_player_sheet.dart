import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/core/features/audio/providers/just_audio_player_provider.dart';

class AdhkarMiniPlayerSheet extends ConsumerWidget {
  const AdhkarMiniPlayerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final audio = ref.watch(audioControllerProvider);
    final ctrl = ref.read(audioControllerProvider.notifier);

    final playing = ref.watch(audioPlayingProvider).value ?? false;
    final buffering = ref.watch(audioBufferingProvider).value ?? false;

    final hasActive = audio.url != null;
    final showPause = hasActive && playing;

    final icon = switch (audio.source) {
      AudioSourceType.adhkar => CupertinoIcons.moon_stars,
      AudioSourceType.quranSurah ||
      AudioSourceType.quranAyah => CupertinoIcons.book,
      _ => CupertinoIcons.music_note_2,
    };

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon),
                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          audio.title ?? 'Now playing',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(
                        buffering ? 'Buffering…' : 'Tap pause anytime',
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: buffering
                            ? null
                            : () => showPause ? ctrl.pause() : ctrl.resume(),

                        icon: buffering
                            ? const CupertinoActivityIndicator()
                            : Icon(
                                showPause
                                    ? CupertinoIcons.pause_fill
                                    : CupertinoIcons.play_fill,
                              ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ctrl.stop();
                        },

                        icon: const Icon(CupertinoIcons.xmark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
