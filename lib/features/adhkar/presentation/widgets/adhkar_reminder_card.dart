import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_list_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/adhkar_categories.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/audio_provider.dart';
import 'package:rafeeq/features/adhkar/presentation/widgets/audio_controls_card.dart';
import 'package:rafeeq/features/settings/presentation/provider/theme_provider.dart';

class AdhkarReminderCard extends ConsumerWidget {
  const AdhkarReminderCard({super.key, required this.isMorning});
  final bool isMorning;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final theme = Theme.of(context);
    const String morningMsg =
        "Morning adhkār is a daily shield and a reminder that Allah ﷻ is with you. Take a minute, breathe, and listen";
    const String eveningMsg =
        'Evening adhkār is your nightly shield — protection, calm, and barakah by Allah ﷻ. Read along, breathe, and listen.';

    return Padding(
      padding: const EdgeInsets.only(left: 14.0, right: 14, top: 4, bottom: 16),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark
                  ? AppDarkColors.darkSurface
                  : AppLightColors.amberSoft,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMorning ? "Morning Adhkār ☀️" : 'Evening Adhkar 🌙',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isMorning ? morningMsg : eveningMsg,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: AudioControlsChip(isMorning: isMorning)),
                      GestureDetector(
                        onTap: () {
                          final categories = ref.read(
                            getAdhkarCategoriesProvider,
                          );
                          final keyword = isMorning ? 'morning' : 'evening';
                          final category = categories.firstWhere(
                            (c) => c.title.toLowerCase().contains(keyword),
                            orElse: () => categories.first,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AdhkarListPage(category: category),
                            ),
                          );
                        },
                        child: Text(
                          'Tap to start >',
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: isDark ? AppLightColors.amber : Colors.black,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Image.asset(
              'assets/images/adhkar/mosque.png',
              height: 30,
              width: 30,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> playAdhkar(
  WidgetRef ref,
  BuildContext context,
  AudioPlayer player, {
  required bool isMorning,
}) async {
  final asset = isMorning
      ? 'assets/adhkar/audio/morning_adhkar.mp3'
      : 'assets/adhkar/audio/evening_adhkar.mp3';

  final active = ref.read(activeAdhkarAssetProvider);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      persist: true,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.all(12),
      content: AdhkarMiniPlayerSheet(),
      dismissDirection: DismissDirection.none, // optional: prevent swipe away
    ),
  );

  // Same track -> toggle
  if (active == asset) {
    if (player.playing) {
      await player.pause();
    } else {
      await player.play();
    }
    return;
  }

  // New track -> load + play
  ref.read(activeAdhkarAssetProvider.notifier).state = asset;
  await player.setAudioSource(AudioSource.asset(asset));
  await player.play();
}

class AudioControlsChip extends ConsumerWidget {
  const AudioControlsChip({super.key, required this.isMorning});
  final bool isMorning;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(adhkarPlayerProvider);

    final asset = isMorning
        ? 'assets/adhkar/audio/morning_adhkar.mp3'
        : 'assets/adhkar/audio/evening_adhkar.mp3';

    final activeAsset = ref.watch(activeAdhkarAssetProvider);
    final isActive = activeAsset == asset;

    final playing = ref.watch(adhkarPlayingProvider).value ?? false;

    final showPlaying = isActive && playing;
    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);

    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: () async {
            await playAdhkar(ref, context, player, isMorning: isMorning);
          },
          style: theme.outlinedButtonTheme.style!.copyWith(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          icon: Icon(
            showPlaying ? CupertinoIcons.pause : CupertinoIcons.play,
            color: isDark
                ? AppDarkColors.iconPrimary
                : AppLightColors.iconPrimary,
          ),
          label: Text(
            showPlaying ? 'Pause' : 'Play',
            style: theme.textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppDarkColors.textPrimary
                  : AppLightColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
