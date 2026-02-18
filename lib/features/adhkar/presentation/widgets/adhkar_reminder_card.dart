import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafeeq/core/features/audio/domain/entities/audio_state.dart';
import 'package:rafeeq/core/features/audio/providers/audio_controller.dart';
import 'package:rafeeq/features/adhkar/presentation/pages/adhkar_list_page.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/adhkar_categories.dart';
import 'package:rafeeq/core/features/audio/providers/just_audio_player_provider.dart';
import 'package:rafeeq/features/adhkar/presentation/riverpod/get_adhkars_provider.dart';

class AdhkarReminderCard extends ConsumerWidget {
  const AdhkarReminderCard({super.key, required this.isMorning});
  final bool isMorning;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    const String morningMsg =
        "Morning adhkār is a daily shield and a reminder that Allah ﷻ is with you. Take a minute, read, and listen";
    const String eveningMsg =
        'Evening adhkār is your nightly shield — protection, calm, and barakah by Allah ﷻ. Read along, breathe, and listen.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: cs.surface,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMorning ? "Morning Adhkār" : 'Evening Adhkar',
                    style: theme.textTheme.labelLarge,
                  ),

                  const SizedBox(height: 10),
                  Text(
                    isMorning ? morningMsg : eveningMsg,
                    style: theme.textTheme.bodyMedium!,
                  ),
                  const SizedBox(height: 14),

                  //Actions
                  Row(
                    children: [
                      AudioControlsChip(isMorning: isMorning),

                      const Spacer(),

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
                            fontWeight: FontWeight.bold,
                            height: 1,
                            color: cs.primary,
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

class AudioControlsChip extends ConsumerWidget {
  const AudioControlsChip({super.key, required this.isMorning});
  final bool isMorning;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlsAsync = ref.watch(adhkarAudioUrlsProvider);

    final theme = Theme.of(context);

    final playing = ref.watch(audioPlayingProvider).value ?? false;
    final buffering = ref.watch(audioBufferingProvider).value ?? false;

    final audio = ref.watch(audioControllerProvider);
    final ctrl = ref.watch(audioControllerProvider.notifier);

    return urlsAsync.when(
      loading: () => TextButton.icon(
        key: const ValueKey('loading'),
        onPressed: null,
        style: theme.textButtonTheme.style!,
        icon: const CupertinoActivityIndicator(),
        label: Text('Loading', style: theme.textTheme.bodySmall!),
      ),
      error: (e, st) => TextButton.icon(
        key: const ValueKey('error'),
        onPressed: () => ref.invalidate(adhkarAudioUrlsProvider),
        style: theme.textButtonTheme.style!.copyWith(),
        icon: const Icon(CupertinoIcons.exclamationmark_triangle),
        label: Text(
          'Retry',
          style: theme.textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      data: (urls) {
        final url = isMorning ? urls.morningUrl : urls.eveningUrl;
        final title = isMorning ? 'Morning adhkar' : 'Evening adhkar';

        final isActive =
            audio.source == AudioSourceType.adhkar && audio.url == url;

        final showPause = playing && isActive;

        return TextButton.icon(
          onPressed: buffering
              ? null
              : () {
                  if (showPause) {
                    ctrl.pause();
                  } else {
                    ctrl.playUrl(
                      url: url,
                      source: AudioSourceType.adhkar,
                      id: isMorning ? 'adhkar_morning' : 'adhkar_evening',
                      title: title,
                      context: context,
                    );
                  }
                },

          style: theme.textButtonTheme.style,
          icon: buffering
              ? const CupertinoActivityIndicator()
              : Icon(showPause ? CupertinoIcons.pause : CupertinoIcons.play),
          label: buffering
              ? Text('Loading', style: theme.textTheme.bodySmall!)
              : Text(
                  (showPause ? 'Pause' : 'Play'),
                  style: theme.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
        );
      },
    );
  }
}
