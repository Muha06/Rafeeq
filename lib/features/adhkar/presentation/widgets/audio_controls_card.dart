import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/app_keys.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/core/audio/providers/just_audio_player_provider.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AdhkarMiniPlayerSheet extends ConsumerWidget {
  const AdhkarMiniPlayerSheet({super.key, required this.isMorning});
  final bool isMorning;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(adhkarPlayerProvider);
    final playing = ref.watch(adhkarPlayingProvider).value ?? false;
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final buffering = ref.watch(adhkarBufferingProvider).value ?? false;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isDark
              ? AppDarkColors.selectedCardBorder.withAlpha(200)
              : AppLightColors.amber,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(
              isMorning ? CupertinoIcons.sun_haze : CupertinoIcons.moon_stars,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Adhkār Playing', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    buffering ? 'Buffering…' : 'Tap pause anytime',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: buffering
                  ? null
                  : () => playing ? player.pause() : player.play(),

              icon: buffering
                  ? const CupertinoActivityIndicator()
                  : Icon(
                      playing
                          ? CupertinoIcons.pause_fill
                          : CupertinoIcons.play_fill,
                    ),
            ),
            IconButton(
              onPressed: () async {
                await player.stop();
                await player.seek(Duration.zero); // reset
                scaffoldMessengerKey.currentState?.clearSnackBars();
              },
              icon: const Icon(CupertinoIcons.xmark),
            ),
          ],
        ),
      ),
    );
  }
}
