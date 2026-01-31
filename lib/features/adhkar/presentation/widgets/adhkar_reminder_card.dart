import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rafeeq/core/themes/dark_colors.dart';
import 'package:rafeeq/core/themes/light_colors.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_list_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/adhkar_categories.dart';
import 'package:rafeeq/core/audio/providers/just_audio_player_provider.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';
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
        "Morning adhkār is a daily shield and a reminder that Allah ﷻ is with you. Take a minute, read, and listen";
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
                          'Tap to read >',
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
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        persist: true,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(12),
        content: AdhkarMiniPlayerSheet(isMorning: isMorning),
        dismissDirection: DismissDirection.none,
      ),
    );
  }
  try {
    final urls = await ref.read(adhkarAudioUrlsProvider.future);
    final url = isMorning ? urls.morningUrl : urls.eveningUrl;

    final active = ref.read(activeAdhkarUrlProvider);

    // Same track -> toggle
    if (active == url) {
      if (player.playing) {
        await player.pause();
      } else {
        await player.play();
      }
      return; // This is OK - finally block will still run
    }

    // New track -> load + play (STREAM)
    ref.read(activeAdhkarUrlProvider.notifier).state = url;

    await player.setUrl(url);

    await player.play();
  } catch (e, st) {
    debugPrint('playAdhkar error: $e');
    debugPrint(st.toString());

    ref.read(activeAdhkarUrlProvider.notifier).state = null;

    if (context.mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not play adhkār. Check connection & try again.'),
        ),
      );
    }
  }
}

class AudioControlsChip extends ConsumerWidget {
  const AudioControlsChip({super.key, required this.isMorning});
  final bool isMorning;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(adhkarPlayerProvider);
    final activeUrl = ref.watch(activeAdhkarUrlProvider);
    final playing = ref.watch(adhkarPlayingProvider).value ?? false;

    final urlsAsync = ref.watch(adhkarAudioUrlsProvider);

    final theme = Theme.of(context);
    final isDark = ref.watch(isDarkProvider);
    final buffering = ref.watch(adhkarBufferingProvider).value ?? false;

    return urlsAsync.when(
      loading: () => OutlinedButton.icon(
        onPressed: null,
        icon: const CupertinoActivityIndicator(),
        label: const Text('Loading'),
      ),
      error: (e, st) => OutlinedButton.icon(
        onPressed: () => ref.invalidate(adhkarAudioUrlsProvider),
        icon: const Icon(CupertinoIcons.exclamationmark_triangle),
        label: const Text('Retry'),
      ),
      data: (urls) {
        final url = isMorning ? urls.morningUrl : urls.eveningUrl;
        final isActive = activeUrl == url;
        final showPlaying = isActive && playing;

        return OutlinedButton.icon(
          onPressed: buffering
              ? null
              : () async {
                  await playAdhkar(ref, context, player, isMorning: isMorning);
                },

          style: theme.outlinedButtonTheme.style!.copyWith(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 4),
            ),
          ),
          icon: buffering
              ? const CupertinoActivityIndicator()
              : Icon(showPlaying ? CupertinoIcons.pause : CupertinoIcons.play),
          label: Text(
            (buffering ? 'Loading' : (showPlaying ? 'Pause' : 'Play')),
            style: theme.textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppDarkColors.iconPrimary
                  : AppLightColors.iconPrimary,
            ),
          ),
        );
      },
    );
  }
}
